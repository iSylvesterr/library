-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterGui = game:GetService("StarterGui");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local TextChatService = game:GetService("TextChatService");
local LocalPlayer = Players.LocalPlayer;
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local CanPlayerUseChatService = require(ReplicatedStorage.Database.Components.Common.Roblox.CanPlayerUseChatService);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local ChatModes = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.ChatModes);
local Platforms = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.Platforms);
local HTML = require(ReplicatedStorage.Database.Custom.GameStats.UI.Chat.HTML);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
require(script:WaitForChild("Types"));
local u2 = nil;
local u3 = nil;
local u4 = { Platforms.PC };
local All = ChatModes.Modes.All;
local u5 = false;
local u6 = false;
local u7 = {};
local u8 = {};
local u9 = 0;
local u10 = nil;

local function IsSystemChatMessagesEnabled() -- Line: 70
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") ~= false;
end;

local function EscapeRichText(p11) -- Line: 76
    return p11:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
end;

local function ColorToRGB(p12) -- Line: 85
    local v13 = math.floor(p12.R * 255 + 0.5);
    local v14 = math.floor(p12.G * 255 + 0.5);
    local v15 = math.floor(p12.B * 255 + 0.5);

    return string.format("rgb(%d,%d,%d)", v13, v14, v15);
end;

local function IsCompetitiveServerGamemode() -- Line: 94
    return workspace:GetAttribute("ServerGamemode") == "Competitive";
end;

local function GetChatNameColorFormat(p16) -- Line: 100
    -- upvalues: HTML (copy)
    return HTML.TeamColors[p16.team] or "";
end;

local function GetPlaceholderText() -- Line: 106
    -- upvalues: u4 (ref), Platforms (copy), InputController (copy)
    return table.find(u4, Platforms.Mobile) and "Tap to chat" or ((table.find(u4, Platforms.Console) or table.find(u4, Platforms.VR)) and "" or string.format("Team Chat (%s) | All Chat (%s)", InputController.GetActionKeybind("Team Message") or "U", InputController.GetActionKeybind("Chat Message") or "Y"));
end;

local function OpenChatFrame(u17) -- Line: 127
    -- upvalues: Profiler (copy), u6 (ref), u9 (ref), RunServiceController (copy)
    Profiler.mark("UI.Chat.OpenChatFrame");

    if not (u17.frame and u17.frame.Parent) then
        return;
    end;

    if u6 then
        return;
    end;

    if u17.fadeConnection or u17.frame.Message.TextTransparency >= 1 then
        return;
    end;

    local TextTransparency = u17.frame.Message.TextTransparency;
    local u18 = os.clock();
    u9 = u9 + 1;
    local u19 = nil;
    u19 = RunServiceController.BindToHeartbeat(`UI.Chat.FadeMessage.{u9}`, function() -- Line: 151
        -- upvalues: u17 (copy), u19 (ref), u6 (ref), u18 (copy), TextTransparency (copy)
        if not (u17.frame and u17.frame.Parent) then
            u19:Disconnect();
            u17.fadeConnection = nil;

            return;
        end;

        if u6 then
            u19:Disconnect();
            u17.fadeConnection = nil;
            u17.frame.Message.TextTransparency = 0;

            return;
        end;

        local v20 = (os.clock() - u18) / 3;
        local v21 = math.min(v20, 1);
        u17.frame.Message.TextTransparency = TextTransparency + (1 - TextTransparency) * v21;

        if v21 >= 1 then
            u19:Disconnect();
            u17.fadeConnection = nil;
        end;
    end);
    u17.fadeConnection = u19;
end;

local function SetChatActive(p22) -- Line: 182
    -- upvalues: u6 (ref), u3 (ref), GetPlaceholderText (copy), u7 (copy), OpenChatFrame (copy)
    u6 = p22;
    u3.Chat.ScrollingFrame.ScrollBarImageTransparency = p22 and 0 or 1;
    u3.Chat.BackgroundTransparency = p22 and 0.55 or 1;
    u3.Type.BackgroundTransparency = p22 and 0.55 or 1;
    u3.BackgroundTransparency = p22 and 0.55 or 1;
    u3.Type.TextBox.PlaceholderColor3 = p22 and Color3.fromRGB(141, 141, 141) or Color3.new(1, 1, 1);

    if not p22 then
        u3.Type.TextBox.PlaceholderText = GetPlaceholderText();
    end;

    local v23 = os.clock();

    for _, v in ipairs(u7) do
        if p22 then
            if v.fadeConnection then
                v.fadeConnection:Disconnect();
                v.fadeConnection = nil;
            end;

            v.frame.Message.TextTransparency = 0;
        else
            local v24 = v23 - v.timestamp;

            if v24 > 10 then
                v.frame.Message.TextTransparency = 1;
            else
                task.delay(10 - v24, OpenChatFrame, v);
            end;
        end;
    end;
end;

local function CloseChat() -- Line: 227
    -- upvalues: u6 (ref), LocalPlayer (copy), MenuState (copy), CameraController (copy), u3 (ref), SetChatActive (copy)
    if not u6 then
        return;
    end;

    LocalPlayer:SetAttribute("IsPlayerChatting", nil);
    local v25 = LocalPlayer.PlayerGui:FindFirstChild("MainGui") and LocalPlayer.PlayerGui.MainGui:FindFirstChild("Menu");

    if v25 then
        v25 = v25.Visible;
    end;

    if not (v25 or (MenuState.IsCaseSceneActive() or MenuState.IsInspectActive())) then
        CameraController.setMouseEnabled(false);
    end;

    u3.Type.TextBox:ReleaseFocus();
    u3.Type.TextBox.TextTransparency = 1;
    u3.Type.TextBox.Text = "";
    SetChatActive(false);
end;

local function AddMessageToUI(p26) -- Line: 252
    -- upvalues: u7 (copy), u6 (ref), OpenChatFrame (copy), u3 (ref), Profiler (copy)
    local v27 = #u7 >= 15 and u7[15];

    if v27 then
        v27.frame:Destroy();
        table.remove(u7, 15);
    end;

    table.insert(u7, 1, p26);

    for i, v in ipairs(u7) do
        v.frame.LayoutOrder = #u7 - i;
    end;

    p26.frame.Message.TextTransparency = 0;

    if not u6 then
        task.delay(10, OpenChatFrame, p26);
    end;

    p26.frame.Parent = u3.Chat.ScrollingFrame;
    Profiler.defer("UI.Chat.ScrollToBottomDeferred", function() -- Line: 283
        -- upvalues: u3 (ref)
        u3.Chat.ScrollingFrame.CanvasPosition = Vector2.new(0, u3.Chat.ScrollingFrame.AbsoluteCanvasSize.Y);
    end);
end;

local function ProcessMessageQueue() -- Line: 291
    -- upvalues: Profiler (copy), u5 (ref), u8 (copy), u10 (ref), u2 (ref), AddMessageToUI (copy), RunServiceController (copy), ProcessMessageQueue (copy)
    Profiler.mark("UI.Chat.ProcessMessageQueue");

    if u5 or #u8 == 0 then
        if #u8 == 0 and u10 then
            u10:Disconnect();
            u10 = nil;
        end;

        return;
    end;

    local v28 = 0;
    u5 = true;

    while #u8 > 0 and v28 < 2 do
        local v29 = table.remove(u8, 1);

        if v29 then
            local v30 = u2:Clone();
            v30.Message.Text = v29.text;
            AddMessageToUI({
                fadeConnection = nil,
                frame = v30,
                timestamp = v29.timestamp,
                text = v29.text
            });
            v28 = v28 + 1;
        end;
    end;

    u5 = false;

    if #u8 ~= 0 or not u10 then
        if #u8 > 0 and not u10 then
            u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 333
                -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
                Profiler.mark("UI.Chat.Heartbeat");
                ProcessMessageQueue();
            end);
        end;

        return;
    end;

    u10:Disconnect();
    u10 = nil;
end;

local function EnsureMessageQueueProcessing() -- Line: 342
    -- upvalues: u5 (ref), ProcessMessageQueue (copy), u8 (copy), u10 (ref), RunServiceController (copy), Profiler (copy)
    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 == 0 or u10 then
        return;
    end;

    u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
        -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
        Profiler.mark("UI.Chat.Heartbeat");
        ProcessMessageQueue();
    end);
end;

local function QueueMessage(p31) -- Line: 360
    -- upvalues: Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    Profiler.mark("UI.Chat.QueueMessage");
    local v32 = {
        text = p31,
        timestamp = os.clock()
    };
    table.insert(u8, v32);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.OpenChat(p33) -- Line: 374
    -- upvalues: Profiler (copy), u6 (ref), CanPlayerUseChatService (copy), LocalPlayer (copy), u4 (ref), Platforms (copy), BuyMenu (copy), All (ref), u3 (ref), ChatModes (copy), SetChatActive (copy), CameraController (copy)
    Profiler.mark((`UI.Chat.OpenChat.{p33}`));

    if u6 then
        return;
    end;

    if not CanPlayerUseChatService(LocalPlayer) then
        return;
    end;

    if table.find(u4, Platforms.Mobile) then
        return;
    end;

    BuyMenu.closeFrame();
    All = p33;
    u3.Visible = true;
    u3.Type.TextBox.PlaceholderText = ChatModes.Labels[p33];
    u3.Type.TextBox.TextTransparency = 0;
    u3.Type.TextBox.Text = "";
    SetChatActive(true);
    CameraController.setMouseEnabled(true);
    LocalPlayer:SetAttribute("IsPlayerChatting", true);
    u3.Type.TextBox:CaptureFocus();
    task.delay(0, function() -- Line: 413
        -- upvalues: u3 (ref)
        u3.Type.TextBox.Text = "";
    end);
end;

function u1.ProcessChatData(p34, p35) -- Line: 420
    -- upvalues: Profiler (copy), HTML (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    Profiler.mark("UI.Chat.ProcessChatData");
    local v36;

    if p35 then
        v36 = HTML.Prefixes[p34.team] or HTML.Prefixes.All;
    else
        v36 = HTML.Prefixes.All;
    end;

    local v37 = (not (p34.role and HTML.Roles[p34.role]) and "" or HTML.Roles[p34.role]) .. v36 .. string.format(HTML.TeamColors[p34.team] or "", (p34.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))) .. (not p34.verified and "" or HTML.Badges.Verified .. " ") .. (p34.alive and "" or HTML.Suffixes.Dead) .. ": " .. p34.message;
    Profiler.mark("UI.Chat.QueueMessage");
    local v38 = {
        text = v37,
        timestamp = os.clock()
    };
    table.insert(u8, v38);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessTeamJoin(p39, p40) -- Line: 444
    -- upvalues: HTML (copy), Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    local v41 = HTML.TeamJoinMessages[p40];

    if not v41 then
        return;
    end;

    local v42 = string.format(v41, p39);
    Profiler.mark("UI.Chat.QueueMessage");
    local v43 = {
        text = v42,
        timestamp = os.clock()
    };
    table.insert(u8, v43);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessPlayerLeave(p44) -- Line: 455
    -- upvalues: HTML (copy), Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    local v45 = string.format(HTML.PlayerLeave, p44);
    Profiler.mark("UI.Chat.QueueMessage");
    local v46 = {
        text = v45,
        timestamp = os.clock()
    };
    table.insert(u8, v46);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessPlayerBanned(p47) -- Line: 461
    -- upvalues: HTML (copy), Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    local v48 = string.format(HTML.PlayerBanned, p47);
    Profiler.mark("UI.Chat.QueueMessage");
    local v49 = {
        text = v48,
        timestamp = os.clock()
    };
    table.insert(u8, v49);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessSystemMessage(p50) -- Line: 467
    -- upvalues: HTML (copy), Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    local v51 = string.format(HTML.SystemMessage, (p50:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")));
    Profiler.mark("UI.Chat.QueueMessage");
    local v52 = {
        text = v51,
        timestamp = os.clock()
    };
    table.insert(u8, v52);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessTeamDamage(p53) -- Line: 473
    -- upvalues: HTML (copy), Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    if p53.messageType ~= "Warning" then
        if p53.messageType == "Announcement" then
            local v54 = p53.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
            local v55 = string.format(HTML.TeamDamageAnnouncement, v54);
            Profiler.mark("UI.Chat.QueueMessage");
            local v56 = {
                text = v55,
                timestamp = os.clock()
            };
            table.insert(u8, v56);

            if u5 then
                return;
            end;

            ProcessMessageQueue();

            if #u8 ~= 0 then
                if u10 then
                    return;
                end;

                u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
                    -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
                    Profiler.mark("UI.Chat.Heartbeat");
                    ProcessMessageQueue();
                end);
            end;
        end;

        return;
    end;

    local TeamDamageWarning = HTML.TeamDamageWarning;
    Profiler.mark("UI.Chat.QueueMessage");
    local v57 = {
        text = TeamDamageWarning,
        timestamp = os.clock()
    };
    table.insert(u8, v57);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessKillMessage(p58) -- Line: 487
    -- upvalues: Profiler (copy), LocalPlayer (copy), HTML (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    Profiler.mark("UI.Chat.ProcessKillMessage");

    if tostring(p58.Killer) == tostring(LocalPlayer.UserId) then
        local v59 = p58.Points or 11;
        local v60 = string.format(HTML.Points.Deathmatch, v59, v59 == 1 and "point" or "points", p58.Weapon);
        Profiler.mark("UI.Chat.QueueMessage");
        local v61 = {
            text = v60,
            timestamp = os.clock()
        };
        table.insert(u8, v61);

        if u5 then
            return;
        end;

        ProcessMessageQueue();

        if #u8 ~= 0 then
            if u10 then
                return;
            end;

            u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
                -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
                Profiler.mark("UI.Chat.Heartbeat");
                ProcessMessageQueue();
            end);
        end;
    end;
end;

function u1.ProcessMoneyReward(p62) -- Line: 498
    -- upvalues: HTML (copy), Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    local v63 = HTML.Money[p62.source];

    if not v63 then
        return;
    end;

    local v64 = tonumber(p62.amount);

    if not v64 then
        return;
    end;

    if p62.source ~= "Kill" then
        local v65 = string.format(v63, (math.abs(v64)));
        Profiler.mark("UI.Chat.QueueMessage");
        local v66 = {
            text = v65,
            timestamp = os.clock()
        };
        table.insert(u8, v66);

        if u5 then
            return;
        end;

        ProcessMessageQueue();

        if #u8 ~= 0 then
            if u10 then
                return;
            end;

            u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
                -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
                Profiler.mark("UI.Chat.Heartbeat");
                ProcessMessageQueue();
            end);
        end;

        return;
    end;

    local v67 = p62.weaponName and HTML.Money.KillWithWeapon or HTML.Money.Kill;
    local v68 = p62.weaponName and string.format(v67, v64, p62.weaponName) or string.format(v67, v64);
    Profiler.mark("UI.Chat.QueueMessage");
    local v69 = {
        text = v68,
        timestamp = os.clock()
    };
    table.insert(u8, v69);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessDefuseStart(p70) -- Line: 525
    -- upvalues: HTML (copy), Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    local v71 = HTML.TeamColors[p70.team] or "";
    local v72 = p70.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v73;

    if v71 == "" then
        v73 = v72 .. " ";
    else
        v73 = string.format(v71, v72);
    end;

    local v74 = (HTML.Prefixes[p70.team] or HTML.Prefixes.All) .. v73 .. string.format("<font color=\"%s\">@%s</font>", HTML.DefuseStartLocationColor, (("Bombsite " .. (p70.site or "?")):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))) .. "<font color=\"rgb(255,255,255)\">: </font>" .. HTML.DefuseStartAction;
    Profiler.mark("UI.Chat.QueueMessage");
    local v75 = {
        text = v74,
        timestamp = os.clock()
    };
    table.insert(u8, v75);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessGrenadeThrow(p76) -- Line: 540
    -- upvalues: HTML (copy), Profiler (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    local v77 = HTML.TeamColors[p76.team] or "";
    local v78 = p76.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v79;

    if v77 == "" then
        v79 = v78 .. " ";
    else
        v79 = string.format(v77, v78);
    end;

    local v80 = HTML.Prefixes[p76.team] or HTML.Prefixes.All;
    local v81 = HTML.GrenadeDisplayNames[p76.grenadeName] or p76.grenadeName:gsub(" Grenade", "");
    local v82 = v80 .. v79 .. "<font color=\"rgb(255,255,255)\">: </font>" .. string.format("<font color=\"%s\">%s!</font>", HTML.GrenadeColors[p76.grenadeName] or "rgb(255,255,255)", (v81:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")));
    Profiler.mark("UI.Chat.QueueMessage");
    local v83 = {
        text = v82,
        timestamp = os.clock()
    };
    table.insert(u8, v83);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessCaseOpened(p84) -- Line: 553
    -- upvalues: Profiler (copy), HTML (copy), Rarities (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    Profiler.mark("UI.Chat.ProcessCaseOpened");
    local v85 = HTML.TeamColors[p84.team] or "";
    local v86 = p84.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v87;

    if v85 == "" then
        v87 = v86 .. " ";
    else
        v87 = string.format(v85, v86);
    end;

    local Color = (Rarities[p84.rarity] or Rarities.Stock).Color;
    local v88 = math.floor(Color.R * 255 + 0.5);
    local v89 = math.floor(Color.G * 255 + 0.5);
    local v90 = math.floor(Color.B * 255 + 0.5);
    local v91 = string.format("rgb(%d,%d,%d)", v88, v89, v90);
    local v92 = p84.weaponName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v93 = p84.skinName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v94 = v87 .. "<font color=\"rgb(255,255,255)\">opened a case and found: </font>" .. string.format("<font color=\"%s\">%s</font>", v91, (p84.statTrak and "KillTrak™ " or "") .. v92 .. " | " .. v93);
    Profiler.mark("UI.Chat.QueueMessage");
    local v95 = {
        text = v94,
        timestamp = os.clock()
    };
    table.insert(u8, v95);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

function u1.ProcessTradeUp(p96) -- Line: 574
    -- upvalues: Profiler (copy), HTML (copy), Rarities (copy), u8 (copy), u5 (ref), ProcessMessageQueue (copy), u10 (ref), RunServiceController (copy)
    Profiler.mark("UI.Chat.ProcessTradeUp");
    local v97 = HTML.TeamColors[p96.team] or "";
    local v98 = p96.displayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v99;

    if v97 == "" then
        v99 = v98 .. " ";
    else
        v99 = string.format(v97, v98);
    end;

    local Color = (Rarities[p96.rarity] or Rarities.Stock).Color;
    local v100 = math.floor(Color.R * 255 + 0.5);
    local v101 = math.floor(Color.G * 255 + 0.5);
    local v102 = math.floor(Color.B * 255 + 0.5);
    local v103 = string.format("rgb(%d,%d,%d)", v100, v101, v102);
    local v104 = p96.weaponName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v105 = p96.skinName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
    local v106 = v99 .. "<font color=\"rgb(255,255,255)\">traded up and crafted: </font>" .. string.format("<font color=\"%s\">%s</font>", v103, (p96.statTrak and "KillTrak™ " or "") .. v104 .. " | " .. v105);
    Profiler.mark("UI.Chat.QueueMessage");
    local v107 = {
        text = v106,
        timestamp = os.clock()
    };
    table.insert(u8, v107);

    if u5 then
        return;
    end;

    ProcessMessageQueue();

    if #u8 ~= 0 then
        if u10 then
            return;
        end;

        u10 = RunServiceController.BindToHeartbeat("UI.Chat.ProcessMessageQueue", function() -- Line: 352
            -- upvalues: Profiler (ref), ProcessMessageQueue (ref)
            Profiler.mark("UI.Chat.Heartbeat");
            ProcessMessageQueue();
        end);
    end;
end;

local u108 = {
    ["Show Player Crosshairs"] = true,
    ["Show my crosshair when spectating bots"] = true
};

local function CopySpectatedCrosshair() -- Line: 606
    -- upvalues: ReplicatedStorage (copy), u1 (copy), LocalPlayer (copy), DataController (copy), u108 (copy)
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
    local Settings = require(ReplicatedStorage.Interface.Screens.Menu.Settings);
    local v109 = SpectateController.GetCurrentSpectateInstance();

    if v109 then
        v109 = v109.Player;
    end;

    if not v109 then
        u1.ProcessSystemMessage("You must be spectating a player to use /cc.");

        return;
    end;

    if v109 == LocalPlayer then
        u1.ProcessSystemMessage("You can\'t copy your own crosshair.");

        return;
    end;

    local v110 = DataController.Get(v109, "Settings.Game.Crosshair");

    if type(v110) ~= "table" then
        u1.ProcessSystemMessage((`Couldn't read {v109.DisplayName}'s crosshair.`));

        return;
    end;

    local v111 = false;

    for i, v in pairs(v110) do
        if not u108[i] then
            Settings.SettingChanged("Game", i, v);
            v111 = true;
        end;
    end;

    if v111 then
        u1.ProcessSystemMessage((`Copied {v109.DisplayName}'s crosshair.`));
    end;
end;

local function ToggleDeveloperConsole() -- Line: 646
    -- upvalues: StarterGui (copy)
    local success, result = pcall(StarterGui.GetCore, StarterGui, "DevConsoleVisible");

    if not success then
        return;
    end;

    pcall(StarterGui.SetCore, StarterGui, "DevConsoleVisible", not result);
end;

function u1.HandleChatCommand(p112) -- Line: 657
    -- upvalues: CopySpectatedCrosshair (copy), StarterGui (copy), Router (copy)
    local v113 = string.lower(string.match(p112, "^%s*(%S+)") or "");

    if v113 == "/cc" then
        CopySpectatedCrosshair();

        return true;
    end;

    if v113 == "/console" or v113 == "/newconsole" then
        local success, result = pcall(StarterGui.GetCore, StarterGui, "DevConsoleVisible");

        if success then
            pcall(StarterGui.SetCore, StarterGui, "DevConsoleVisible", not result);
        end;

        return true;
    end;

    if v113 ~= "/modpanel" and v113 ~= "/mp" then
        return false;
    end;

    task.defer(Router.broadcastRouter, "mp:toggle");

    return true;
end;

function u1.Initialize(p114, p115) -- Line: 682
    -- upvalues: Profiler (copy), u3 (ref), u4 (ref), GetUserPlatform (copy), u2 (ref), ReplicatedStorage (copy), u6 (ref), BuyMenu (copy), LocalPlayer (copy), SetChatActive (copy), ChatModes (copy), All (ref), CloseChat (copy), u1 (copy), TextChatService (copy), CanPlayerUseChatService (copy), Platforms (copy)
    Profiler.mark("UI.Chat.Initialize");
    u3 = p115;
    u4 = GetUserPlatform();
    u2 = ReplicatedStorage.Assets.UI.Chat.Template;
    u2.Message.RichText = true;

    for _, child in ipairs(u3.Chat.ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    u3.Type.TextBox.ClearTextOnFocus = false;
    u3.Type.TextBox.Focused:Connect(function() -- Line: 704
        -- upvalues: u6 (ref), u3 (ref), BuyMenu (ref), LocalPlayer (ref), SetChatActive (ref), Profiler (ref), ChatModes (ref), All (ref)
        if not u6 then
            u3.Type.TextBox:ReleaseFocus();

            return;
        end;

        BuyMenu.closeFrame();
        LocalPlayer:SetAttribute("IsPlayerChatting", true);
        u3.Type.TextBox.TextTransparency = 0;
        SetChatActive(true);
        task.delay(0, function() -- Line: 721
            -- upvalues: Profiler (ref), u3 (ref)
            debug.setmemorycategory("UI.Chat.ClearFocusedTextDeferred");
            Profiler.mark("UI.Chat.ClearFocusedTextDeferred");
            u3.Type.TextBox.Text = "";
        end);

        if ChatModes.Labels[All] then
            u3.Type.TextBox.PlaceholderText = ChatModes.Labels[All];
        end;
    end);
    u3.Type.TextBox.FocusLost:Connect(function(p116) -- Line: 734
        -- upvalues: u3 (ref), CloseChat (ref), u1 (ref), LocalPlayer (ref), All (ref), ChatModes (ref), TextChatService (ref)
        local v117 = (not p116 or string.len(u3.Type.TextBox.Text) <= 0) and "" or u3.Type.TextBox.Text;
        CloseChat();

        if p116 and #v117 > 0 then
            if u1.HandleChatCommand(v117) then
                return;
            end;

            if #v117 <= 100 then
                local Character = LocalPlayer.Character;
                local v118;

                if Character then
                    v118 = Character:FindFirstChildOfClass("Humanoid");
                else
                    v118 = Character;
                end;

                local v119;

                if Character then
                    v119 = Character:GetAttribute("Dead") ~= true and (v118 and v118.Health > 0 and true or false);
                else
                    v119 = false;
                end;

                local v120 = LocalPlayer:GetAttribute("Team");
                local v121 = not v120 or v120 == "Spectators";
                local v122 = workspace:GetAttribute("ServerGamemode") == "Competitive";
                local v123;

                if All == ChatModes.Modes.All then
                    v123 = (v119 or (v121 or v122 and not v121)) and "All" or "AllDead";
                else
                    v123 = (v119 or v122 and not v121) and "Team" or "TeamDead";
                end;

                local v124 = TextChatService:FindFirstChild(v123);

                if v124 then
                    v124:SendAsync(v117);
                end;
            end;
        end;
    end);
    SetChatActive(false);
    u3.Visible = false;
    local v125 = CanPlayerUseChatService(LocalPlayer) and not table.find(u4, Platforms.Mobile);

    if not v125 then
        u3:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 817
            -- upvalues: u3 (ref)
            if u3.Visible then
                u3.Visible = false;
            end;
        end);
    end;
end;

function u1.Start() -- Line: 827
    -- upvalues: Profiler (copy), TextChatService (copy), LocalPlayer (copy), Players (copy), u1 (copy), Remotes (copy), DataController (copy), UserInputService (copy), ChatModes (copy)
    debug.setmemorycategory("UI.Chat.Start");
    Profiler.mark("UI.Chat.Start.Begin");
    local All2 = TextChatService:WaitForChild("All", 10);
    local AllDead = TextChatService:WaitForChild("AllDead", 10);
    local Team = TextChatService:WaitForChild("Team", 10);
    local TeamDead = TextChatService:WaitForChild("TeamDead", 10);
    Profiler.mark("UI.Chat.Start.ChannelsLoaded");
    local u126 = true;

    local function updateLocalPlayerAliveStatus() -- Line: 840
        -- upvalues: LocalPlayer (ref), u126 (ref)
        local Character = LocalPlayer.Character;
        local v127;

        if Character then
            v127 = Character:FindFirstChildOfClass("Humanoid");
        else
            v127 = Character;
        end;

        if not Character then
            u126 = false;

            return;
        end;

        local v128 = Character:GetAttribute("Dead") ~= true and (v127 and v127.Health > 0 and true or false);
        u126 = v128;
    end;

    local Character = LocalPlayer.Character;
    Character = Character;
    local v129;

    if Character then
        v129 = Character:FindFirstChildOfClass("Humanoid");
    else
        v129 = Character;
    end;

    if Character then
        local v130 = Character:GetAttribute("Dead") ~= true and (v129 and v129.Health > 0 and true or false);
        u126 = v130;
    else
        u126 = false;
    end;

    LocalPlayer.CharacterAdded:Connect(function(p131) -- Line: 860
        -- upvalues: LocalPlayer (ref), u126 (ref)
        local Character2 = LocalPlayer.Character;
        local v132;

        if Character2 then
            v132 = Character2:FindFirstChildOfClass("Humanoid");
        else
            v132 = Character2;
        end;

        if Character2 then
            local v133 = Character2:GetAttribute("Dead") ~= true and (v132 and v132.Health > 0 and true or false);
            u126 = v133;
        else
            u126 = false;
        end;

        p131:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 862
            -- upvalues: LocalPlayer (ref), u126 (ref)
            local Character3 = LocalPlayer.Character;
            local v134;

            if Character3 then
                v134 = Character3:FindFirstChildOfClass("Humanoid");
            else
                v134 = Character3;
            end;

            if not Character3 then
                u126 = false;

                return;
            end;

            local v135 = Character3:GetAttribute("Dead") ~= true and (v134 and v134.Health > 0 and true or false);
            u126 = v135;
        end);
    end);

    local function getPlayerAliveStatus(p136) -- Line: 870
        -- upvalues: Players (ref)
        local v137 = Players:GetPlayerByUserId(p136);

        if not (v137 and v137.Character) then
            return false;
        end;

        local Character2 = v137.Character;
        local v138 = Character2:FindFirstChildOfClass("Humanoid");
        local v139 = Character2:GetAttribute("Dead") ~= true and (v138 and v138.Health > 0 and true or false);

        return v139;
    end;

    local u140 = {};

    local function processChannelMessage(p141, p142, p143) -- Line: 888
        -- upvalues: u140 (ref), Players (ref), getPlayerAliveStatus (copy), LocalPlayer (ref), u126 (ref), u1 (ref)
        if p141.Status ~= Enum.TextChatMessageStatus.Success then
            return;
        end;

        local MessageId = p141.MessageId;

        if MessageId and u140[MessageId] then
            return;
        end;

        if MessageId then
            u140[MessageId] = true;
            local v144 = 0;

            for _ in u140 do
                v144 = v144 + 1;
            end;

            if v144 > 100 then
                u140 = {
                    [MessageId] = true
                };
            end;
        end;

        local TextSource = p141.TextSource;

        if not TextSource then
            return;
        end;

        local UserId = TextSource.UserId;

        if not UserId then
            return;
        end;

        local u145 = Players:GetPlayerByUserId(UserId);

        if not u145 then
            return;
        end;

        local v146 = getPlayerAliveStatus(UserId);
        local v147 = u145:GetAttribute("Team");
        local v148 = LocalPlayer:GetAttribute("Team");
        local v149 = workspace:GetAttribute("ServerGamemode") == "Competitive";

        if p142 == "All" or p142 == "AllDead" then
            if u126 and (not v146 and (p142 == "All" and not v149)) then
                return;
            end;
        elseif p142 == "Team" or p142 == "TeamDead" then
            if v147 ~= v148 then
                return;
            end;

            if p142 == "Team" and (u126 and not (v146 or v149)) then
                return;
            end;
        end;

        local v150 = 0;
        local success, result = pcall(function() -- Line: 964
            -- upvalues: u145 (copy)
            return u145:GetRankInGroup(33751825);
        end);

        if success then
            v150 = result or v150;
        end;

        u1.ProcessChatData({
            verified = u145.HasVerifiedBadge,
            userId = UserId,
            displayName = u145.DisplayName,
            team = v147 or "Spectators",
            message = p141.Text,
            alive = v146,
            role = v150
        }, p143);
    end;

    if All2 then
        function All2.OnIncomingMessage(p151) -- Line: 989
            -- upvalues: processChannelMessage (copy)
            processChannelMessage(p151, "All", false);

            return nil;
        end;
    end;

    if AllDead then
        function AllDead.OnIncomingMessage(p152) -- Line: 996
            -- upvalues: processChannelMessage (copy)
            processChannelMessage(p152, "AllDead", false);

            return nil;
        end;
    end;

    if Team then
        function Team.OnIncomingMessage(p153) -- Line: 1003
            -- upvalues: processChannelMessage (copy)
            processChannelMessage(p153, "Team", true);

            return nil;
        end;
    end;

    if TeamDead then
        function TeamDead.OnIncomingMessage(p154) -- Line: 1010
            -- upvalues: processChannelMessage (copy)
            processChannelMessage(p154, "TeamDead", true);

            return nil;
        end;
    end;

    Remotes.Chat.ChatTeamJoin.Listen(function(p155) -- Line: 1017
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessTeamJoin(p155.name, p155.team);
    end);
    Remotes.Chat.ChatPlayerLeave.Listen(function(p156) -- Line: 1025
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessPlayerLeave(p156.name);
    end);
    Remotes.Chat.ChatPlayerBanned.Listen(function(p157) -- Line: 1033
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessPlayerBanned(p157.name);
    end);
    Remotes.Chat.ChatSystemMessage.Listen(function(p158) -- Line: 1041
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessSystemMessage(p158.message);
    end);
    Remotes.Chat.ChatTeamDamage.Listen(function(p159) -- Line: 1049
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessTeamDamage(p159);
    end);
    Remotes.Chat.ChatPlayerKilled.Listen(function(p160) -- Line: 1057
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessKillMessage(p160);
    end);
    Remotes.Chat.ChatMoneyReward.Listen(function(p161) -- Line: 1065
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessMoneyReward(p161);
    end);
    Remotes.Chat.ChatCaseOpened.Listen(function(p162) -- Line: 1073
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessCaseOpened(p162);
    end);
    Remotes.Chat.ChatTradeUp.Listen(function(p163) -- Line: 1080
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessTradeUp(p163);
    end);
    Remotes.Chat.ChatGrenadeThrow.Listen(function(p164) -- Line: 1088
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessGrenadeThrow(p164);
    end);
    Remotes.Chat.ChatDefuseStart.Listen(function(p165) -- Line: 1096
        -- upvalues: DataController (ref), LocalPlayer (ref), u1 (ref)
        if DataController.Get(LocalPlayer, "Settings.Game.HUD.System Chat Messages") == false then
            return;
        end;

        u1.ProcessDefuseStart(p165);
    end);
    UserInputService.InputBegan:Connect(function(p166, p167) -- Line: 1104
        -- upvalues: u1 (ref), ChatModes (ref)
        if p167 or (p166.UserInputType ~= Enum.UserInputType.Keyboard or p166.KeyCode ~= Enum.KeyCode.Slash) then
            return;
        end;

        u1.OpenChat(ChatModes.Modes.All);
    end);
end;

return u1;