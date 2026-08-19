-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local u1 = {
    not_in_guild = "You\'re not in a guild",
    no_invite_permission = "Only Owners and Elders can invite",
    already_member = "They\'re already in your guild",
    target_in_guild = "They\'re already in a guild",
    guild_full = "Your guild is full",
    invite_cooldown = "Slow down -- wait a few seconds",
    already_invited_recently = "You already invited them recently",
    target_not_in_server = "They need to be in this server"
};
local v2 = {
    StartOrder = 9
};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = {};
local u10 = {};

local function trackRowConn(p11) -- Line: 48
    -- upvalues: u9 (copy)
    table.insert(u9, p11);
end;

local function clearRows() -- Line: 52
    -- upvalues: u9 (copy), u10 (copy)
    for _, v in u9 do
        pcall(function() -- Line: 54
            -- upvalues: v (copy)
            v:Disconnect();
        end);
    end;

    table.clear(u9);

    for _, v in u10 do
        if v.Parent then
            v:Destroy();
        end;
    end;

    table.clear(u10);
end;

local function setNameChain(p12, p13) -- Line: 65
    p12.Text = p13;
    local GuildTextLabelName2 = p12:FindFirstChild("GuildTextLabelName2");

    if GuildTextLabelName2 and GuildTextLabelName2:IsA("TextLabel") then
        GuildTextLabelName2.Text = p13;
    end;
end;

local function applyHeadshot(u14, u15) -- Line: 73
    -- upvalues: Players (copy)
    task.spawn(function() -- Line: 74
        -- upvalues: Players (ref), u15 (copy), u14 (copy)
        local success, result = pcall(function() -- Line: 75
            -- upvalues: Players (ref), u15 (ref)
            return Players:GetUserThumbnailAsync(u15, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
        end);

        if success and (typeof(result) == "string" and u14.Parent) then
            u14.Image = result;
        end;
    end);
end;

local function sendInvite(u16, u17) -- Line: 88
    -- upvalues: Networking (copy), NotificationController (copy), u1 (copy)
    u17.Active = false;

    if u17:IsA("TextButton") or u17:IsA("ImageButton") then
        u17.AutoButtonColor = false;
    end;

    task.spawn(function() -- Line: 93
        -- upvalues: Networking (ref), u16 (copy), NotificationController (ref), u17 (copy), u1 (ref)
        local v18, v19, v20 = pcall(function() -- Line: 94
            -- upvalues: Networking (ref), u16 (ref)
            return Networking.Guild.Invite:Fire(u16);
        end);

        if not v18 then
            NotificationController:CreateNotification("Try again");
            u17.Active = true;

            return;
        end;

        if v19 then
            NotificationController:CreateNotification("Guild invite sent!");

            return;
        end;

        local v21 = tostring(v20 or "");
        NotificationController:CreateNotification(u1[v21] or ((v21 == "" or not v21) and "Could not invite" or v21));
        u17.Active = true;
    end);
end;

local function fetchMemberSet() -- Line: 120
    -- upvalues: Networking (copy)
    local v22 = {};
    local success, result = pcall(function() -- Line: 122
        -- upvalues: Networking (ref)
        return Networking.Guild.GetMyGuild:Fire();
    end);

    if success and (typeof(result) == "table" and (typeof(result.Guild) == "table" and typeof(result.Guild.Members) == "table")) then
        for i in result.Guild.Members do
            local v23 = tonumber(i);

            if v23 then
                v22[v23] = true;
            end;
        end;
    end;

    return v22;
end;

local function renderRow(p24, p25, u26) -- Line: 136
    -- upvalues: u10 (copy), Players (copy), sendInvite (copy), u9 (copy)
    local v27 = p24:Clone();
    v27.Name = `Player_{u26.UserId}`;
    v27.LayoutOrder = #u10 + 1;
    v27.Visible = true;
    v27.Parent = p25;
    table.insert(u10, v27);
    local PlayerName = v27:FindFirstChild("PlayerName");

    if PlayerName and PlayerName:IsA("TextLabel") then
        local DisplayName = u26.DisplayName;
        PlayerName.Text = DisplayName;
        local GuildTextLabelName2 = PlayerName:FindFirstChild("GuildTextLabelName2");

        if GuildTextLabelName2 and GuildTextLabelName2:IsA("TextLabel") then
            GuildTextLabelName2.Text = DisplayName;
        end;
    end;

    local PlayerImage = v27:FindFirstChild("PlayerImage");

    if PlayerImage then
        PlayerImage = PlayerImage:FindFirstChild("Icon");
    end;

    if PlayerImage and PlayerImage:IsA("ImageLabel") then
        local UserId = u26.UserId;
        task.spawn(function() -- Line: 74
            -- upvalues: Players (ref), UserId (copy), PlayerImage (copy)
            local success, result = pcall(function() -- Line: 75
                -- upvalues: Players (ref), UserId (ref)
                return Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
            end);

            if success and (typeof(result) == "string" and PlayerImage.Parent) then
                PlayerImage.Image = result;
            end;
        end);
    end;

    local InviteButton = v27:FindFirstChild("InviteButton");

    if InviteButton and InviteButton:IsA("GuiButton") then
        local v28 = InviteButton.MouseButton1Click:Connect(function() -- Line: 157
            -- upvalues: sendInvite (ref), u26 (copy), InviteButton (copy)
            sendInvite(u26.UserId, InviteButton);
        end);
        table.insert(u9, v28);
    end;
end;

local function populate() -- Line: 163
    -- upvalues: u8 (ref), u4 (ref), u5 (ref), clearRows (copy), fetchMemberSet (copy), Players (copy), LocalPlayer (copy), renderRow (copy), u6 (ref)
    if not u8 then
        return;
    end;

    if not (u4 and u5) then
        return;
    end;

    local v29 = u4;
    local v30 = u5;
    clearRows();
    local v31 = fetchMemberSet();

    if not u8 then
        return;
    end;

    local v32 = 0;

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer and not (v31[v.UserId] or v:GetAttribute("GuildId")) then
            renderRow(v30, v29, v);
            v32 = v32 + 1;
        end;
    end;

    if u6 then
        u6.Visible = v32 == 0;
    end;

    v29.Visible = v32 > 0;
end;

local function ResolveRefs(p33) -- Line: 191
    -- upvalues: u7 (ref), u6 (ref), u4 (ref), u5 (ref)
    local Frame = p33:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    local Header = Frame:FindFirstChild("Header");

    if Header then
        local ExitButton = Header:FindFirstChild("ExitButton");

        if ExitButton and ExitButton:IsA("GuiButton") then
            u7 = ExitButton;
        end;
    end;

    local Content = Frame:FindFirstChild("Content");

    if not Content then
        return;
    end;

    local StatusLabel = Content:FindFirstChild("StatusLabel");

    if StatusLabel and StatusLabel:IsA("TextLabel") then
        u6 = StatusLabel;
    end;

    local ScrollingFrame = Content:FindFirstChild("ScrollingFrame");

    if ScrollingFrame and ScrollingFrame:IsA("ScrollingFrame") then
        u4 = ScrollingFrame;
        local PlayerTemplate = ScrollingFrame:FindFirstChild("PlayerTemplate");

        if PlayerTemplate and PlayerTemplate:IsA("GuiObject") then
            u5 = PlayerTemplate;
            PlayerTemplate.Visible = false;
        end;
    end;
end;

local function BindButtons() -- Line: 218
    -- upvalues: u7 (ref), GuiController (copy)
    if u7 then
        u7.MouseButton1Click:Connect(function() -- Line: 220
            -- upvalues: GuiController (ref)
            if not GuiController:IsOpen("GuildInvite") then
                return;
            end;

            GuiController:Open("ViewGuildPage", nil, { "HUD" });

            if GuiController:IsOpen("GuildInvite") then
                GuiController:Close();
            end;
        end);
    end;
end;

function v2.Init(p34) -- Line: 232
end;

function v2.Start(p35) -- Line: 234
    -- upvalues: PlayerGui (copy), u3 (ref), ResolveRefs (copy), u7 (ref), GuiController (copy), u8 (ref), populate (copy), clearRows (copy), Players (copy)
    task.spawn(function() -- Line: 235
        -- upvalues: PlayerGui (ref), u3 (ref), ResolveRefs (ref), u7 (ref), GuiController (ref), u8 (ref), populate (ref), clearRows (ref), Players (ref)
        local GuildInvite = PlayerGui:WaitForChild("GuildInvite", 30);

        if not (GuildInvite and GuildInvite:IsA("ScreenGui")) then
            return;
        end;

        u3 = GuildInvite;
        GuildInvite.Enabled = false;
        ResolveRefs(GuildInvite);

        if u7 then
            u7.MouseButton1Click:Connect(function() -- Line: 220
                -- upvalues: GuiController (ref)
                if not GuiController:IsOpen("GuildInvite") then
                    return;
                end;

                GuiController:Open("ViewGuildPage", nil, { "HUD" });

                if GuiController:IsOpen("GuildInvite") then
                    GuiController:Close();
                end;
            end);
        end;

        GuiController.GuiFocusedSignal:Connect(function(p36) -- Line: 245
            -- upvalues: GuildInvite (copy), u8 (ref), populate (ref)
            if p36 == GuildInvite then
                u8 = true;
                populate();
            end;
        end);
        GuiController.GuiUnfocusedSignal:Connect(function(p37) -- Line: 251
            -- upvalues: GuildInvite (copy), u8 (ref), clearRows (ref)
            if p37 == GuildInvite then
                u8 = false;
                clearRows();
            end;
        end);
        Players.PlayerAdded:Connect(function() -- Line: 259
            -- upvalues: u8 (ref), populate (ref)
            if u8 then
                populate();
            end;
        end);
        Players.PlayerRemoving:Connect(function() -- Line: 262
            -- upvalues: u8 (ref), populate (ref)
            if u8 then
                task.defer(populate);
            end;
        end);
    end);
end;

return v2;