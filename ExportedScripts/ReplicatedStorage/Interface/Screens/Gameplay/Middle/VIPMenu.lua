-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u2 = RunService:IsStudio();
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps;
local u3 = { {
        Name = "DropKnife",
        Label = "Drop Knife",
        Key = "KnifeDropEnabled"
    }, {
        Name = "FreezeTimer",
        Label = "Freeze Timer",
        Key = "TimerFrozen"
    }, {
        Name = "KillTrading",
        Label = "Kill Trading",
        Key = "KillTradingEnabled"
    }, {
        Name = "InfiniteAmmo",
        Label = "Infinite Ammo",
        Key = "InfiniteAmmoEnabled"
    }, {
        Name = "InfiniteCash",
        Label = "Infinite Cash",
        Key = "InfiniteCashEnabled"
    }, {
        Name = "DisableTeamLimit",
        Label = "Disable Team Limit",
        Key = "DisableTeamLimitEnabled"
    }, {
        Name = "FriendlyFire",
        Label = "Friendly Fire",
        Key = "FriendlyFireEnabled"
    }, {
        Name = "PlayerCollisions",
        Label = "Player Collisions",
        Key = "PlayerCollisionsEnabled"
    } };
local u4 = { {
        Name = "Competitive",
        Mode = "COMPETITIVE",
        Description = "Classic round-based rules with economy and no respawns.",
        ServerGamemode = "Competitive"
    }, {
        Name = "Casual",
        Mode = "CASUAL",
        Description = "Relaxed round-based rules with lighter penalties.",
        ServerGamemode = "Casual"
    }, {
        Name = "Deathmatch",
        Mode = "DEATHMATCH",
        Description = "Fast respawn combat focused on eliminations.",
        ServerGamemode = "Deathmatch"
    } };
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = false;
local u9 = nil;
local u10 = {};
local u11 = "KickPlayer";
local u12 = Janitor.new();
local u13 = Janitor.new();
local u14 = Janitor.new();
local u15 = Janitor.new();
local u16 = Janitor.new();
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = "Close";
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;

local function canUseVIPMenu() -- Line: 95
    -- upvalues: u2 (copy), LocalPlayer (copy)
    return u2 and true or LocalPlayer:GetAttribute("CanUseVIPMenu") == true;
end;

local function hasActiveCharacter() -- Line: 105
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v33;

    if Character == nil then
        v33 = false;
    else
        v33 = Character:IsDescendantOf(workspace);
    end;

    return v33;
end;

local function isOnPlayingTeam() -- Line: 112
    -- upvalues: LocalPlayer (copy)
    local v34 = LocalPlayer:GetAttribute("Team");

    return v34 == "Counter-Terrorists" and true or v34 == "Terrorists";
end;

local function isInGameplayContext() -- Line: 119
    -- upvalues: LocalPlayer (copy)
    local v35 = LocalPlayer:GetAttribute("Team");

    return v35 == "Counter-Terrorists" and true or v35 == "Terrorists" or LocalPlayer:GetAttribute("IsSpectating") == true;
end;

local function getMainGuiFromRoot() -- Line: 125
    -- upvalues: u17 (ref)
    local v36 = u17 and u17.Parent;

    if v36 then
        v36 = v36.Parent;
    end;

    if v36 then
        v36 = v36.Parent;
    end;

    if v36 and v36:IsA("ScreenGui") then
        return v36;
    end;

    return nil;
end;

local function isMainMenuVisible() -- Line: 137
    -- upvalues: u17 (ref)
    local v37 = u17 and u17.Parent;

    if v37 then
        v37 = v37.Parent;
    end;

    if v37 then
        v37 = v37.Parent;
    end;

    if not (v37 and v37:IsA("ScreenGui")) then
        v37 = nil;
    end;

    if not v37 then
        return false;
    end;

    local Menu = v37:FindFirstChild("Menu");
    local v38;

    if Menu == nil then
        v38 = false;
    else
        v38 = Menu:IsA("GuiObject") and Menu.Visible;
    end;

    return v38;
end;

local function isTeamSelectionVisible() -- Line: 149
    -- upvalues: u17 (ref)
    local v39 = u17 and u17.Parent;

    if v39 then
        v39 = v39.Parent;
    end;

    if v39 then
        v39 = v39.Parent;
    end;

    if not (v39 and v39:IsA("ScreenGui")) then
        v39 = nil;
    end;

    if not v39 then
        return false;
    end;

    local Gameplay = v39:FindFirstChild("Gameplay");

    if not (Gameplay and Gameplay:IsA("GuiObject")) then
        return false;
    end;

    local Middle = Gameplay:FindFirstChild("Middle");

    if not (Middle and Middle:IsA("GuiObject")) then
        return false;
    end;

    local TeamSelection = Middle:FindFirstChild("TeamSelection");
    local v40;

    if TeamSelection == nil then
        v40 = false;
    else
        v40 = TeamSelection:IsA("GuiObject") and TeamSelection.Visible;
    end;

    return v40;
end;

local function isLocalPlayerSpectating() -- Line: 171
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("IsSpectating") == true;
end;

local function bindPress(p41, p42, u43) -- Line: 177
    if p42:IsA("GuiButton") then
        p41:Add(p42.MouseButton1Click:Connect(u43));

        return;
    end;

    p42.Active = true;
    p41:Add(p42.InputBegan:Connect(function(p44) -- Line: 186
        -- upvalues: u43 (copy)
        local UserInputType = p44.UserInputType;

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        u43();
    end));
end;

local function clearGenerated(p45, p46, p47) -- Line: 196
    for _, child in ipairs(p45:GetChildren()) do
        if child ~= p46 and not (p47 and p47[child.Name]) and child:IsA("GuiObject") then
            child:Destroy();
        end;
    end;

    p46.Visible = false;
end;

local function getGodModePlayers() -- Line: 211
    -- upvalues: u5 (ref)
    local GodModeEnabledPlayers = u5.GodModeEnabledPlayers;

    if typeof(GodModeEnabledPlayers) == "table" then
        return GodModeEnabledPlayers;
    end;

    local v48 = {};
    u5.GodModeEnabledPlayers = v48;

    return v48;
end;

local function setLocalGodModePlayer(p49, p50) -- Line: 222
    -- upvalues: u5 (ref)
    local GodModeEnabledPlayers = u5.GodModeEnabledPlayers;

    if typeof(GodModeEnabledPlayers) ~= "table" then
        GodModeEnabledPlayers = {};
        u5.GodModeEnabledPlayers = GodModeEnabledPlayers;
    end;

    local v51 = tostring(p49);
    GodModeEnabledPlayers[p49] = nil;

    if p50 then
        GodModeEnabledPlayers[v51] = true;

        return GodModeEnabledPlayers;
    end;

    GodModeEnabledPlayers[v51] = nil;

    return GodModeEnabledPlayers;
end;

local function isPlayerGodModeEnabled(p52) -- Line: 236
    -- upvalues: u5 (ref)
    local GodModeEnabledPlayers = u5.GodModeEnabledPlayers;

    if typeof(GodModeEnabledPlayers) == "table" then
        return GodModeEnabledPlayers[tostring(p52)] == true and true or GodModeEnabledPlayers[p52] == true;
    end;

    return false;
end;

local function updateVoteKickHeader() -- Line: 245
    -- upvalues: u24 (ref), u11 (ref)
    if not u24 then
        return;
    end;

    u24.Text = u11 == "GodMode" and "God Mode" or "Players";
end;

local function showPanel(p53) -- Line: 253
    -- upvalues: u24 (ref), u11 (ref), u22 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u17 (ref), u25 (ref), u26 (ref)
    if p53 == "VoteKick" then
        if u24 then
            u24.Text = u11 == "GodMode" and "God Mode" or "Players";
        end;

        u22.Visible = true;
    else
        u18.Visible = p53 == "Home";
        u19.Visible = p53 == "Settings";
        u20.Visible = p53 == "MapSelect";
        u21.Visible = p53 == "ModeSelect";
        u22.Visible = false;
    end;

    local Position = u17.Position;
    u17.Position = UDim2.new(p53 == "VoteKick" and 0.4 or 0.5, Position.X.Offset, Position.Y.Scale, Position.Y.Offset);

    if u25 then
        local v54 = (u19.Visible or (u20.Visible or u21.Visible)) and "Back" or u26;
        local Frame = u25:FindFirstChild("Frame");

        if Frame then
            Frame = Frame:FindFirstChildWhichIsA("TextLabel");
        end;

        if Frame then
            Frame.Text = v54;

            return;
        end;

        local v55 = u25:FindFirstChildWhichIsA("TextLabel");

        if v55 then
            v55.Text = v54;

            return;
        end;

        if u25:IsA("TextButton") then
            u25.Text = v54;
        end;
    end;
end;

local function getButtonLabel(p56) -- Line: 288
    local Frame = p56:FindFirstChild("Frame");

    if Frame then
        Frame = Frame:FindFirstChildWhichIsA("TextLabel");
    end;

    if Frame then
        return Frame.Text;
    end;

    local v57 = p56:FindFirstChildWhichIsA("TextLabel");

    if v57 then
        return v57.Text;
    end;

    return not p56:IsA("TextButton") and "" or p56.Text;
end;

local function setButtonLabel(p58, p59) -- Line: 307
    local Frame = p58:FindFirstChild("Frame");

    if Frame then
        Frame = Frame:FindFirstChildWhichIsA("TextLabel");
    end;

    if Frame then
        Frame.Text = p59;

        return true;
    end;

    local v60 = p58:FindFirstChildWhichIsA("TextLabel");

    if v60 then
        v60.Text = p59;

        return true;
    end;

    if not p58:IsA("TextButton") then
        return false;
    end;

    p58.Text = p59;

    return true;
end;

local function getMapInfo(p61) -- Line: 329
    -- upvalues: u10 (ref), Maps (copy)
    if u10[p61] ~= nil then
        return u10[p61];
    end;

    local v62 = Maps:FindFirstChild(p61);

    if not v62 then
        u10[p61] = nil;

        return nil;
    end;

    if not v62:IsA("ModuleScript") then
        v62 = v62:FindFirstChild("init");
    end;

    if not (v62 and v62:IsA("ModuleScript")) then
        u10[p61] = nil;

        return nil;
    end;

    local success, result = pcall(require, v62);

    if not success or typeof(result) ~= "table" then
        result = nil;
    end;

    u10[p61] = result;

    return result;
end;

local function mapSupportsMode(p63, p64) -- Line: 352
    -- upvalues: getMapInfo (copy)
    if not p64 then
        return true;
    end;

    local v65 = getMapInfo(p63);

    if v65 then
        v65 = v65.Gamemode;
    end;

    if typeof(v65) ~= "table" then
        return false;
    end;

    local v66 = v65[p64];
    local v67;

    if v66 == nil then
        v67 = false;
    else
        v67 = v66 ~= false;
    end;

    return v67;
end;

local function loadAvailableMaps() -- Line: 367
    -- upvalues: u7 (ref), Maps (copy), u10 (ref), u8 (ref)
    u7 = {};

    for _, child in ipairs(Maps:GetChildren()) do
        local Name = child.Name;

        if not child:IsA("ModuleScript") then
            local child = child:FindFirstChild("init");
        end;

        if child and child:IsA("ModuleScript") then
            local success, result = pcall(require, child);

            if success and typeof(result) == "table" then
                u10[Name] = result;
                local v68 = {
                    Name = Name,
                    Icon = typeof(result.Icon) == "string" and (result.Icon or "") or ""
                };
                table.insert(u7, v68);
            end;
        end;
    end;

    table.sort(u7, function(p69, p70) -- Line: 390
        return p69.Name < p70.Name;
    end);
    u8 = true;
end;

local function getGamemodeIcon(p71) -- Line: 397
    -- upvalues: u7 (ref), getMapInfo (copy)
    for _, v in ipairs(u7) do
        local Name = v.Name;
        local v72;

        if p71 then
            local v73 = getMapInfo(Name);

            if v73 then
                v73 = v73.Gamemode;
            end;

            if typeof(v73) == "table" then
                local v74 = v73[p71];

                if v74 == nil then
                    v72 = false;
                else
                    v72 = v74 ~= false;
                end;
            else
                v72 = false;
            end;
        else
            v72 = true;
        end;

        if v72 and v.Icon ~= "" then
            return v.Icon;
        end;
    end;

    return nil;
end;

local function setToggleVisual(p75, p76) -- Line: 409
    local Button = p75:WaitForChild("Button");
    local ImageLabel = Button:WaitForChild("ImageLabel");
    local UIStroke = Button:WaitForChild("Border"):WaitForChild("UIStroke");
    ImageLabel.Visible = p76;
    local v77;

    if p76 then
        v77 = Color3.fromRGB(255, 255, 255);
    else
        v77 = Color3.fromRGB(100, 100, 100);
    end;

    UIStroke.Color = v77;
end;

local function updateToggleIndicators() -- Line: 419
    -- upvalues: u3 (copy), u19 (ref), setToggleVisual (copy), u5 (ref)
    for _, v in ipairs(u3) do
        local v78 = u19:FindFirstChild(v.Name);

        if v78 and v78:IsA("GuiObject") then
            setToggleVisual(v78, u5[v.Key] == true);
        end;
    end;
end;

local function setMapSelectionVisual(p79, p80) -- Line: 430
    local Accept = p79:WaitForChild("Accept");
    local ActiveBorder = Accept:WaitForChild("ActiveBorder");
    local TextLabel = Accept:WaitForChild("TextLabel");

    if Accept:IsA("TextButton") or Accept:IsA("ImageButton") then
        Accept.BackgroundTransparency = 0;
        Accept.BackgroundColor3 = Color3.fromRGB(20, 75, 17);
    end;

    ActiveBorder.Enabled = true;
    TextLabel.Text = p80 and "SELECTED" or "SELECT";
    local ActivateGradient = Accept:FindFirstChild("ActivateGradient");

    for _, descendant in ipairs(Accept:GetDescendants()) do
        if descendant:IsA("UIGradient") then
            if descendant == ActivateGradient then
                descendant.Enabled = true;
            else
                local Name = descendant.Name;

                if Name == "ActivateGradient" then
                    descendant.Enabled = true;
                elseif Name == "InactiveGradient" then
                    descendant.Enabled = false;
                end;
            end;
        end;
    end;
end;

local function renderMaps() -- Line: 471
    -- upvalues: u8 (ref), u14 (copy), clearGenerated (copy), u20 (ref), u30 (ref), u7 (ref), u9 (ref), getMapInfo (copy), setMapSelectionVisual (copy), u5 (ref), bindPress (copy), Remotes (copy), renderMaps (copy), showPanel (copy)
    if not u8 then
        return;
    end;

    u14:Cleanup();
    clearGenerated(u20, u30, {
        Back = true,
        Close = true
    });
    local v81 = 1;

    for _, v in ipairs(u7) do
        local Name = v.Name;
        local v82 = u9;
        local v83;

        if v82 then
            local v84 = getMapInfo(Name);

            if v84 then
                v84 = v84.Gamemode;
            end;

            if typeof(v84) == "table" then
                local v85 = v84[v82];

                if v85 == nil then
                    v83 = false;
                else
                    v83 = v85 ~= false;
                end;
            else
                v83 = false;
            end;
        else
            v83 = true;
        end;

        if v83 then
            local u86 = u30:Clone();
            u86.Name = v.Name;
            u86.LayoutOrder = v81;
            u86.Visible = true;
            v81 = v81 + 1;
            u86:WaitForChild("Header"):WaitForChild("Info").Text = v.Name;
            local Main = u86:WaitForChild("Main");
            local v87 = Main:FindFirstChild("Map") or Main:FindFirstChild("ImageButton");

            if v87 and not (v87:IsA("ImageLabel") or v87:IsA("ImageButton")) then
                v87 = nil;
            end;

            if v87 then
                v87.Image = v.Icon;
            end;

            local Selection = Main:FindFirstChild("Selection");

            if Selection and not Selection:IsA("TextLabel") then
                Selection = nil;
            end;

            if Selection then
                Selection.Text = v.Name;
            end;

            setMapSelectionVisual(u86, u5.NextMap == v.Name);
            bindPress(u14, u86:WaitForChild("Accept"), function() -- Line: 515
                -- upvalues: u5 (ref), v (copy), Remotes (ref), setMapSelectionVisual (ref), u86 (copy), renderMaps (ref), showPanel (ref)
                u5.NextMap = v.Name;
                Remotes.VIP.SetSetting.Send({
                    Key = "NextMap",
                    Value = v.Name
                });
                setMapSelectionVisual(u86, true);
                renderMaps();
                showPanel("Home");
            end);
            u86.Parent = u20;
        end;
    end;
end;

local function renderModeCards() -- Line: 527
    -- upvalues: u15 (copy), clearGenerated (copy), u21 (ref), u31 (ref), u5 (ref), u9 (ref), u4 (copy), getGamemodeIcon (copy), bindPress (copy), Remotes (copy), renderModeCards (copy), showPanel (copy), renderMaps (copy)
    u15:Cleanup();
    clearGenerated(u21, u31, {
        Back = true,
        Close = true
    });
    local v88;

    if typeof(u5.NextGamemode) == "string" then
        v88 = u5.NextGamemode;
    else
        v88 = u9;
    end;

    for i, v in ipairs(u4) do
        local v89 = u31:Clone();
        v89.Name = v.Name;
        v89.LayoutOrder = i;
        v89.Visible = true;
        local Main = v89:WaitForChild("Main");
        local Info = Main:WaitForChild("Info");
        local Mode = Info:WaitForChild("Mode");
        local Description = Info:WaitForChild("Description");
        local Select = Main:WaitForChild("Select");
        local ImageButton = Main:WaitForChild("ImageButton");
        Mode.Text = v.Mode;
        Description.Text = v.Description;
        Select.Visible = v88 == v.ServerGamemode;
        local v90 = getGamemodeIcon(v.ServerGamemode);

        if v90 then
            ImageButton.Image = v90;
        end;

        bindPress(u15, v89:FindFirstChild("Button") or v89, function() -- Line: 555
            -- upvalues: u9 (ref), v (copy), Remotes (ref), renderModeCards (ref), showPanel (ref), renderMaps (ref)
            u9 = v.ServerGamemode;
            Remotes.VIP.SetSetting.Send({
                Key = "NextGamemode",
                Value = v.ServerGamemode
            });
            renderModeCards();
            showPanel("MapSelect");
            renderMaps();
        end);
        v89.Parent = u21;
    end;
end;

local function renderPlayers() -- Line: 567
    -- upvalues: u16 (copy), clearGenerated (copy), u23 (ref), u32 (ref), u6 (ref), u11 (ref), LocalPlayer (copy), u5 (ref), bindPress (copy), Router (copy), Remotes (copy), showPanel (copy)
    u16:Cleanup();
    clearGenerated(u23, u32, nil);
    local v91 = 1;

    for _, v in ipairs(u6) do
        if u11 ~= "KickPlayer" or v.UserId ~= LocalPlayer.UserId then
            local v92 = u32:Clone();
            v92.Name = tostring(v.UserId);
            v92.LayoutOrder = v91;
            v92.Visible = true;
            v91 = v91 + 1;
            local Player = v92:WaitForChild("Player");
            local Player2 = Player:WaitForChild("Player");
            local Name = Player:WaitForChild("Name");
            local Bomb = Player:WaitForChild("Bomb");
            local Selected = v92:WaitForChild("Selected");
            Player2.Image = `rbxthumb://type=AvatarHeadShot&id={v.UserId}&w=420&h=420`;
            local u93 = "@" .. v.DisplayName;
            Bomb.Visible = v.Team == "Terrorists";
            Selected.Visible = false;

            local function setGodModeVisual(p94) -- Line: 594
                -- upvalues: Selected (copy), Name (copy), u93 (copy)
                Selected.Visible = p94;
                Name.Text = `{u93} [{p94 and "ON" or "OFF"}]`;
                local v95;

                if p94 then
                    v95 = Color3.fromRGB(150, 255, 167);
                else
                    v95 = Color3.fromRGB(170, 170, 170);
                end;

                Name.TextColor3 = v95;
            end;

            if u11 == "GodMode" then
                local UserId = v.UserId;
                local GodModeEnabledPlayers = u5.GodModeEnabledPlayers;
                local v96;

                if typeof(GodModeEnabledPlayers) == "table" then
                    v96 = GodModeEnabledPlayers[tostring(UserId)] == true and true or GodModeEnabledPlayers[UserId] == true;
                else
                    v96 = false;
                end;

                Selected.Visible = v96;
                Name.Text = `{u93} [{v96 and "ON" or "OFF"}]`;
                local v97;

                if v96 then
                    v97 = Color3.fromRGB(150, 255, 167);
                else
                    v97 = Color3.fromRGB(170, 170, 170);
                end;

                Name.TextColor3 = v97;
            else
                Name.Text = u93;
                Name.TextColor3 = Color3.fromRGB(190, 190, 190);
                Selected.Visible = false;
            end;

            bindPress(u16, v92, function() -- Line: 608
                -- upvalues: Router (ref), u11 (ref), v (copy), u5 (ref), Selected (copy), Name (copy), u93 (copy), Remotes (ref), showPanel (ref)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if u11 ~= "GodMode" then
                    Selected.Visible = true;
                    Remotes.VIP.ExecuteAction.Send({
                        Action = "KickPlayer",
                        Params = v.UserId
                    });
                    showPanel("Home");

                    return;
                end;

                local UserId = v.UserId;
                local GodModeEnabledPlayers = u5.GodModeEnabledPlayers;
                local v98;

                if typeof(GodModeEnabledPlayers) == "table" then
                    v98 = GodModeEnabledPlayers[tostring(UserId)] == true and true or GodModeEnabledPlayers[UserId] == true;
                else
                    v98 = false;
                end;

                local v99 = not v98;
                local UserId2 = v.UserId;
                local GodModeEnabledPlayers2 = u5.GodModeEnabledPlayers;

                if typeof(GodModeEnabledPlayers2) ~= "table" then
                    GodModeEnabledPlayers2 = {};
                    u5.GodModeEnabledPlayers = GodModeEnabledPlayers2;
                end;

                local v100 = tostring(UserId2);
                GodModeEnabledPlayers2[UserId2] = nil;

                if v99 then
                    GodModeEnabledPlayers2[v100] = true;
                else
                    GodModeEnabledPlayers2[v100] = nil;
                end;

                Selected.Visible = v99;
                Name.Text = `{u93} [{v99 and "ON" or "OFF"}]`;
                local v101;

                if v99 then
                    v101 = Color3.fromRGB(150, 255, 167);
                else
                    v101 = Color3.fromRGB(170, 170, 170);
                end;

                Name.TextColor3 = v101;
                Remotes.VIP.SetSetting.Send({
                    Key = "GodModeEnabledPlayers",
                    Value = GodModeEnabledPlayers2
                });
            end);
            v92.Parent = u23;
        end;
    end;
end;

local function renderSettings() -- Line: 629
    -- upvalues: u13 (copy), clearGenerated (copy), u19 (ref), u27 (ref), u28 (ref), u29 (ref), u3 (copy), u5 (ref), setToggleVisual (copy), Remotes (copy), bindPress (copy), u11 (ref), renderPlayers (copy), showPanel (copy)
    u13:Cleanup();
    clearGenerated(u19, u27, {
        InputTemplate = true,
        ClickTemplate = true
    });
    u28.Visible = false;
    u27.Visible = false;
    u29.Visible = false;
    local v102 = 1;

    for _, v in ipairs(u3) do
        local u103 = u27:Clone();
        u103.Name = v.Name;
        u103.LayoutOrder = v102;
        u103.Visible = true;
        v102 = v102 + 1;
        local TextLabel = u103:WaitForChild("TextLabel");
        local Button = u103:WaitForChild("Button");
        TextLabel.Text = v.Label;
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel.Size = UDim2.new(1, 0, TextLabel.Size.Y.Scale, TextLabel.Size.Y.Offset);
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
        TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
        local u104 = false;

        local function toggleSetting() -- Line: 656
            -- upvalues: u104 (ref), u5 (ref), v (copy), setToggleVisual (ref), u103 (copy), Remotes (ref)
            if u104 then
                return;
            end;

            u104 = true;
            local v105 = u5[v.Key] ~= true;
            u5[v.Key] = v105;
            setToggleVisual(u103, v105);
            Remotes.VIP.SetSetting.Send({
                Key = v.Key,
                Value = v105
            });
            task.defer(function() -- Line: 666
                -- upvalues: u104 (ref)
                u104 = false;
            end);
        end;

        bindPress(u13, u103, toggleSetting);
        bindPress(u13, Button, toggleSetting);
        u103.Parent = u19;
        setToggleVisual(u103, u5[v.Key] == true);
    end;

    local v106 = u28:Clone();
    v106.Name = "SetTimer";
    v106.LayoutOrder = v102;
    v106.Visible = true;
    local v107 = v102 + 1;
    local TextLabel = v106:WaitForChild("TextLabel");
    local u108 = v106:FindFirstChildWhichIsA("TextBox", true);
    TextLabel.Text = "Set Timer";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.new(1, 0, TextLabel.Size.Y.Scale, TextLabel.Size.Y.Offset);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    u108.TextXAlignment = Enum.TextXAlignment.Center;
    u108.TextYAlignment = Enum.TextYAlignment.Center;
    u108.Text = "";
    u108.PlaceholderText = "Seconds";
    u13:Add(u108.FocusLost:Connect(function() -- Line: 698
        -- upvalues: u108 (copy), Remotes (ref)
        local v109 = tonumber(u108.Text);

        if not v109 then
            u108.Text = "";

            return;
        end;

        local Send = Remotes.VIP.ExecuteAction.Send;
        local v110 = {
            Action = "SetTimer"
        };
        local v111 = math.floor(v109);
        v110.Params = math.clamp(v111, 0, 9999);
        Send(v110);
        u108.Text = "";
    end));
    v106.Parent = u19;

    for _, v in ipairs({
        {
            Name = "GodMode",
            Label = "God Mode",

            Callback = function() -- Line: 715, Name: Callback
                -- upvalues: u11 (ref), Remotes (ref), renderPlayers (ref), showPanel (ref)
                u11 = "GodMode";
                Remotes.VIP.RequestData.Send("State");
                Remotes.VIP.RequestData.Send("PlayerList");
                renderPlayers();
                showPanel("VoteKick");
            end
        },
        {
            Name = "KickPlayer",
            Label = "Kick Player",

            Callback = function() -- Line: 726, Name: Callback
                -- upvalues: u11 (ref), Remotes (ref), renderPlayers (ref), showPanel (ref)
                u11 = "KickPlayer";
                Remotes.VIP.RequestData.Send("PlayerList");
                renderPlayers();
                showPanel("VoteKick");
            end
        },
        {
            Name = "EndGame",
            Label = "End Current Game",

            Callback = function() -- Line: 736, Name: Callback
                -- upvalues: Remotes (ref), showPanel (ref)
                Remotes.VIP.ExecuteAction.Send({
                    Action = "EndGame",
                    Params = nil
                });
                showPanel("Home");
            end
        },
        {
            Name = "ResetScore",
            Label = "Reset Score",

            Callback = function() -- Line: 744, Name: Callback
                -- upvalues: Remotes (ref)
                Remotes.VIP.ExecuteAction.Send({
                    Action = "ResetScore",
                    Params = nil
                });
            end
        }
    }) do
        local v112 = u29:Clone();
        v112.Name = v.Name;
        v112.LayoutOrder = v107;
        v112.Visible = true;
        v107 = v107 + 1;
        v112:WaitForChild("TextLabel").Text = v.Label;
        bindPress(u13, v112, v.Callback);
        v112.Parent = u19;
    end;
end;

local function setupHomeButtons() -- Line: 768
    -- upvalues: u18 (ref), bindPress (copy), u12 (copy), u9 (ref), showPanel (copy), renderMaps (copy), renderModeCards (copy), renderSettings (copy)
    for _, child in ipairs(u18:GetChildren()) do
        if child:IsA("GuiButton") then
            local Frame = child:FindFirstChild("Frame");

            if Frame then
                Frame = Frame:FindFirstChildWhichIsA("TextLabel");
            end;

            local u113;

            if Frame then
                u113 = Frame.Text;
            else
                local v114 = child:FindFirstChildWhichIsA("TextLabel");

                if v114 then
                    u113 = v114.Text;
                else
                    u113 = not child:IsA("TextButton") and "" or child.Text;
                end;
            end;

            bindPress(u12, child, function() -- Line: 775
                -- upvalues: u113 (copy), u9 (ref), showPanel (ref), renderMaps (ref), renderModeCards (ref), renderSettings (ref)
                if u113 == "Select Map" then
                    u9 = nil;
                    showPanel("MapSelect");
                    renderMaps();

                    return;
                end;

                if u113 ~= "Select Mode" then
                    if u113 == "Settings" then
                        renderSettings();
                        showPanel("Settings");
                    end;

                    return;
                end;

                renderModeCards();
                showPanel("ModeSelect");
            end);
        end;
    end;
end;

local function setupBackButtons() -- Line: 797
    -- upvalues: u20 (ref), u21 (ref), u22 (ref), bindPress (copy), u12 (copy), showPanel (copy), CloseButtonRegistry (copy)
    for _, v in ipairs({ u20, u21, u22 }) do
        local Back = v:FindFirstChild("Back");

        if Back then
            bindPress(u12, Back, function() -- Line: 802
                -- upvalues: showPanel (ref)
                showPanel("Home");
            end);
        end;

        local Close = v:FindFirstChild("Close");

        if Close and (v == u20 or v == u21) then
            local Frame = Close:FindFirstChild("Frame");

            if Frame then
                Frame = Frame:FindFirstChildWhichIsA("TextLabel");
            end;

            if Frame then
                Frame.Text = "Back";
            else
                local v115 = Close:FindFirstChildWhichIsA("TextLabel");

                if v115 then
                    v115.Text = "Back";
                elseif Close:IsA("TextButton") then
                    Close.Text = "Back";
                end;
            end;
        end;

        if Close and (Close ~= Back and Close:IsA("GuiButton")) then
            CloseButtonRegistry.Add(v, Close, function() -- Line: 813
                -- upvalues: showPanel (ref)
                showPanel("Home");
            end);
        end;
    end;
end;

local function setupCloseButton() -- Line: 820
    -- upvalues: u17 (ref), u25 (ref), u26 (ref), CloseButtonRegistry (copy), u19 (ref), u20 (ref), u21 (ref), showPanel (copy), u1 (copy)
    local Close = u17:WaitForChild("Close");

    if Close and Close:IsA("GuiButton") then
        u25 = Close;
        local Frame = Close:FindFirstChild("Frame");

        if Frame then
            Frame = Frame:FindFirstChildWhichIsA("TextLabel");
        end;

        local v116;

        if Frame then
            v116 = Frame.Text;
        else
            local v117 = Close:FindFirstChildWhichIsA("TextLabel");

            if v117 then
                v116 = v117.Text;
            else
                v116 = not Close:IsA("TextButton") and "" or Close.Text;
            end;
        end;

        if v116 ~= "" then
            u26 = v116;
        end;

        CloseButtonRegistry.Add(u17, Close, function() -- Line: 829
            -- upvalues: u19 (ref), u20 (ref), u21 (ref), showPanel (ref), u1 (ref)
            if u19.Visible or (u20.Visible or u21.Visible) then
                showPanel("Home");

                return;
            end;

            u1.closeFrame();
        end);
    end;
end;

function u1.openFrame() -- Line: 842
    -- upvalues: EndScreenController (copy), MenuState (copy), LocalPlayer (copy), u17 (ref), isTeamSelectionVisible (copy), u2 (copy), CameraController (copy), showPanel (copy), Remotes (copy), renderMaps (copy), renderModeCards (copy)
    local v118 = EndScreenController.IsActive();
    local v119 = MenuState.IsInspectActive();
    local v120 = MenuState.IsCaseSceneActive();
    local v121 = LocalPlayer:GetAttribute("Team");
    local v122 = v121 == "Counter-Terrorists" and true or v121 == "Terrorists" or LocalPlayer:GetAttribute("IsSpectating") == true;
    local v123 = u17 and u17.Parent;

    if v123 then
        v123 = v123.Parent;
    end;

    if v123 then
        v123 = v123.Parent;
    end;

    if not (v123 and v123:IsA("ScreenGui")) then
        v123 = nil;
    end;

    local v124;

    if v123 then
        local Menu = v123:FindFirstChild("Menu");

        if Menu == nil then
            v124 = false;
        else
            v124 = Menu:IsA("GuiObject") and Menu.Visible;
        end;
    else
        v124 = false;
    end;

    local v125 = isTeamSelectionVisible();

    if not u2 and LocalPlayer:GetAttribute("CanUseVIPMenu") ~= true then
        return;
    end;

    if not u17 then
        return;
    end;

    if v118 then
        return;
    end;

    if v119 or v120 then
        return;
    end;

    if not v122 then
        return;
    end;

    if v124 then
        return;
    end;

    if v125 then
        return;
    end;

    if u17.Visible then
        return;
    end;

    CameraController.setForceLockOverride("VIPMenu", true);

    if LocalPlayer:GetAttribute("IsSpectating") ~= true then
        local Character = LocalPlayer.Character;
        local v126;

        if Character == nil then
            v126 = false;
        else
            v126 = Character:IsDescendantOf(workspace);
        end;

        if v126 then
            CameraController.setPerspective(true, true);
        end;
    end;

    u17.Visible = true;
    showPanel("Home");
    Remotes.VIP.RequestData.Send("State");
    Remotes.VIP.RequestData.Send("PlayerList");
    renderMaps();
    renderModeCards();
end;

function u1.closeFrame() -- Line: 888
    -- upvalues: u17 (ref), CameraController (copy), LocalPlayer (copy)
    if not u17 then
        return;
    end;

    CameraController.setForceLockOverride("VIPMenu", false);

    if LocalPlayer:GetAttribute("IsSpectating") ~= true then
        local Character = LocalPlayer.Character;
        local v127;

        if Character == nil then
            v127 = false;
        else
            v127 = Character:IsDescendantOf(workspace);
        end;

        if v127 then
            CameraController.setPerspective(true, false);
        end;
    end;

    u17.Visible = false;
end;

function u1.toggleFrame() -- Line: 900
    -- upvalues: u17 (ref), u1 (copy)
    if not u17 then
        return;
    end;

    if u17.Visible then
        u1.closeFrame();

        return;
    end;

    u1.openFrame();
end;

function u1.Initialize(p128, p129) -- Line: 915
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u25 (ref), u26 (ref), loadAvailableMaps (copy), showPanel (copy), renderSettings (copy), renderModeCards (copy), u12 (copy), CameraController (copy), Remotes (copy), updateToggleIndicators (copy), renderMaps (copy), renderPlayers (copy)
    u17 = p129;
    u18 = p129:WaitForChild("Frame");
    u19 = p129:WaitForChild("ScrollingFrame");
    u20 = p129:WaitForChild("SelectMap");
    u21 = p129:WaitForChild("SelectMode");
    u22 = p129:WaitForChild("VoteKick");
    u23 = u22:WaitForChild("Container");
    u24 = u22:WaitForChild("Header"):WaitForChild("Title");
    u27 = u19:WaitForChild("ToggleTemplate");
    u28 = u19:WaitForChild("InputTemplate");
    u29 = u19:WaitForChild("ClickTemplate");
    u30 = u20:WaitForChild("Template");
    u31 = u21:WaitForChild("Template");
    u32 = u23:WaitForChild("Template");
    u5 = {};
    u6 = {};
    u7 = {};
    u8 = false;
    u9 = nil;
    u10 = {};
    u11 = "KickPlayer";
    u25 = nil;
    u26 = "Close";
    loadAvailableMaps();
    u17.Visible = false;
    showPanel("Home");
    renderSettings();
    renderModeCards();
    u12:Add(u17:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 948
        -- upvalues: u17 (ref), CameraController (ref)
        if u17.Visible then
            return;
        end;

        CameraController.setForceLockOverride("VIPMenu", false);
    end));
    u12:Add(Remotes.VIP.SyncState.Listen(function(p130) -- Line: 958
        -- upvalues: u5 (ref), updateToggleIndicators (ref), renderMaps (ref), u22 (ref), renderPlayers (ref)
        u5 = p130;
        updateToggleIndicators();
        renderMaps();

        if u22.Visible then
            renderPlayers();
        end;
    end));
    u12:Add(Remotes.VIP.DataResponse.Listen(function(p131) -- Line: 967
        -- upvalues: u5 (ref), updateToggleIndicators (ref), renderMaps (ref), u22 (ref), renderPlayers (ref), u6 (ref)
        if p131.Type == "State" then
            u5 = p131.Data;
            updateToggleIndicators();
            renderMaps();

            if u22.Visible then
                renderPlayers();
            end;
        elseif p131.Type == "PlayerList" then
            u6 = p131.Data;
            renderPlayers();
        end;
    end));
end;

function u1.Start() -- Line: 982
    -- upvalues: setupHomeButtons (copy), setupBackButtons (copy), setupCloseButton (copy), updateToggleIndicators (copy)
    setupHomeButtons();
    setupBackButtons();
    setupCloseButton();
    updateToggleIndicators();
end;

return u1;