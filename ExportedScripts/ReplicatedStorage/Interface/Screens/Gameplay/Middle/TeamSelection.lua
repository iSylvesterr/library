-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local LocalPlayer = Players.LocalPlayer;
local u2 = false;
local u3 = 0;
local u4 = nil;
local u5 = nil;

local function retrieveTeamCount(p6, p7) -- Line: 49
    -- upvalues: Players (copy)
    local v8 = 0;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= p7 and v:GetAttribute("Team") == p6 then
            v8 = v8 + 1;
        end;
    end;

    return v8;
end;

local function chooseBalancedTeam(p9) -- Line: 63
    -- upvalues: retrieveTeamCount (copy)
    local v10 = retrieveTeamCount("Counter-Terrorists", p9);
    local v11 = retrieveTeamCount("Terrorists", p9);

    if v10 ~= v11 then
        return v10 < v11 and "Counter-Terrorists" or "Terrorists";
    end;

    local v12 = p9:GetAttribute("Team");

    return v12 == "Counter-Terrorists" and "Terrorists" or (v12 == "Terrorists" and "Counter-Terrorists" or "Terrorists");
end;

local function isTeamAvailable(p13, p14) -- Line: 87
    -- upvalues: retrieveTeamCount (copy)
    if workspace:GetAttribute("VIPDisableTeamLimitEnabled") == true then
        return (p14 == "Counter-Terrorists" or p14 == "Terrorists") and true or p14 == "Spectators";
    end;

    if workspace:GetAttribute("ServerGamemode") == "Deathmatch" or workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return (p14 == "Counter-Terrorists" or p14 == "Terrorists") and true or p14 == "Spectators";
    end;

    local v15 = retrieveTeamCount("Counter-Terrorists", p13);
    local v16 = retrieveTeamCount("Terrorists", p13);

    if p14 == "Terrorists" then
        if v16 < v15 then
            return true;
        end;
    elseif p14 == "Counter-Terrorists" and v15 < v16 then
        return true;
    end;

    return p14 == "Spectators" and true or v15 == v16;
end;

local u17 = ColorSequence.new(Color3.fromRGB(32, 32, 32));
local u18 = {};
local u19 = {};

local function setPlayerTemplateUnhovered(p20, p21) -- Line: 120
    if not (p20 and p20:IsA("Frame")) then
        return;
    end;

    p20.BackgroundColor3 = p21 == "Counter-Terrorists" and Color3.fromRGB(109, 121, 140) or Color3.fromRGB(131, 111, 66);
    p20.Player.UIStroke.Color = p21 == "Counter-Terrorists" and Color3.fromRGB(50, 56, 65) or Color3.fromRGB(94, 85, 54);
    p20.Player.Avatar.ImageColor3 = Color3.fromRGB(138, 138, 138);
end;

local function updateTeamAvailabilityStyles() -- Line: 127
    -- upvalues: retrieveTeamCount (copy), u4 (ref), u18 (copy), u19 (copy), u17 (copy), setPlayerTemplateUnhovered (copy)
    local v22 = workspace:GetAttribute("VIPDisableTeamLimitEnabled") == true;
    local v23 = workspace:GetAttribute("ServerGamemode") == "Deathmatch" and true or workspace:GetAttribute("Gamemode") == "Deathmatch";
    local v24 = retrieveTeamCount("Counter-Terrorists");
    local v25 = retrieveTeamCount("Terrorists");

    for _, v in ipairs({ "Counter-Terrorists", "Terrorists" }) do
        local v26 = u4:FindFirstChild(v);

        if v26 then
            if not u18[v] then
                u18[v] = {
                    TeamTransparency = v26.Team.TextTransparency,
                    PlayersTransparency = v26.Players.TextTransparency,
                    UIGradient = v26.UIGradient.Color,
                    IconOutline = v26.Icon.Outline.ImageTransparency,
                    IconTeam = v26.Icon.Team.ImageTransparency,
                    IconTeamIcon = v26.Icon.Team.Icon.ImageTransparency
                };
            end;

            local v27 = not (v22 or v23);

            if v27 then
                if v == "Counter-Terrorists" and v25 < v24 then
                    v27 = true;
                elseif v == "Terrorists" then
                    v27 = v24 < v25;
                else
                    v27 = false;
                end;
            end;

            u19[v] = v27;
            local v28 = u18[v];
            v26.Team.TextTransparency = v27 and 0.5 or v28.TeamTransparency;
            v26.Players.TextTransparency = v27 and 0.5 or v28.PlayersTransparency;
            v26.UIGradient.Color = v27 and u17 or v28.UIGradient;
            v26.Icon.Outline.ImageTransparency = v27 and 0.4 or v28.IconOutline;
            v26.Icon.Team.ImageTransparency = v27 and 0.4 or v28.IconTeam;
            v26.Icon.Team.Icon.ImageTransparency = v27 and 0.4 or v28.IconTeamIcon;

            for _, child in ipairs(v26.Container:GetChildren()) do
                if v27 then
                    setPlayerTemplateUnhovered(child, v);
                end;
            end;
        end;
    end;
end;

local function createButtonAnimation(u29) -- Line: 166
    -- upvalues: TweenService (copy)
    u29.MouseEnter:Connect(function() -- Line: 168
        -- upvalues: TweenService (ref), u29 (copy)
        TweenService:Create(u29, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.85
        }):Play();
    end);
    u29.MouseLeave:Connect(function() -- Line: 172
        -- upvalues: TweenService (ref), u29 (copy)
        TweenService:Create(u29, TweenInfo.new(0.1), {
            BackgroundTransparency = 1
        }):Play();
    end);
end;

local function isCharacterAlive() -- Line: 179
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character:IsDescendantOf(workspace)) then
        return false;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");
    local v30;

    if Humanoid == nil then
        v30 = false;
    else
        v30 = Humanoid.Health > 0;
    end;

    return v30;
end;

local function createTeamListeners(p31, u32) -- Line: 190
    -- upvalues: u1 (copy), createButtonAnimation (copy)
    p31.MouseButton1Click:Connect(function() -- Line: 192
        -- upvalues: u1 (ref), u32 (copy)
        u1.chooseTeam(u32);
    end);

    if u32 == "Spectators" then
        createButtonAnimation(p31);

        return;
    end;

    u1.createTeamButtonAnimation(p31, u32);
end;

function u1.isVisible() -- Line: 207
    -- upvalues: u4 (ref), u5 (ref)
    if not (u4 and u4.Visible) then
        return false;
    end;

    if not u5 then
        return false;
    end;

    local Gameplay = u5:FindFirstChild("Gameplay");

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Bottom");
    end;

    local v33;

    if Gameplay == nil then
        v33 = false;
    else
        v33 = Gameplay:IsA("GuiObject") and not Gameplay.Visible;
    end;

    return v33;
end;

function u1.ToggleTeamSelection() -- Line: 222
    -- upvalues: EndScreenController (copy), u4 (ref), u1 (copy)
    if EndScreenController.IsActive() then
        return;
    end;

    if u4.Visible then
        u1.closeFrame();

        return;
    end;

    u1.openFrame();
end;

function u1.openFrame() -- Line: 239
    -- upvalues: EndScreenController (copy), MenuState (copy), u4 (ref), u5 (ref), ReplicatedStorage (copy), CameraController (copy), u2 (ref), LocalPlayer (copy), GetUserPlatform (copy), updateTeamAvailabilityStyles (copy)
    if EndScreenController.IsActive() then
        return;
    end;

    if MenuState.IsCaseSceneActive() or MenuState.IsInspectActive() then
        return;
    end;

    if u4.Visible then
        return;
    end;

    local v34 = u5.Menu.Visible and MenuState.GetCurrentScreen();

    if v34 and (v34 == "Loadout" or (v34 == "Inventory" or (v34 == "Modes" or v34 == "Settings")) or v34 == "Store") then
        local v35 = u5.Menu:FindFirstChild(v34);

        if v35 and v35.Visible then
            return;
        end;
    end;

    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

    if MenuSceneController.IsActive() then
        MenuSceneController.HideMenuScene(true, false);
    end;

    if u5.Menu.Visible then
        CameraController.setForceLockOverride("Menu", false);
        MenuState.SetBlurEnabled(false);
    end;

    local BuyMenu = u5.Gameplay.Middle:FindFirstChild("BuyMenu");
    u2 = BuyMenu and BuyMenu.Visible or false;

    if u2 then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu).closeFrame();
    end;

    CameraController.setForceLockOverride("TeamSelection", true);

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, true);
    end;

    u5.Gameplay.Bottom.Visible = false;
    u5.Gameplay.Top.Visible = true;
    u5.Gameplay.Visible = true;
    MenuState.HideMenu();

    for _, child in ipairs(u5.Gameplay.Middle:GetChildren()) do
        local v36 = table.find(GetUserPlatform(), "Mobile");

        if child.Name == "Chat" then
            child.Visible = not v36;
        elseif child.Name == "MobileButtons" then
            local Character = LocalPlayer.Character;

            if Character and Character:IsDescendantOf(workspace) then
                child.Visible = v36;
            else
                child.Visible = false;
            end;
        else
            child.Visible = child.Name == "Notification" and true or child.Name == "TeamSelection";
        end;
    end;

    updateTeamAvailabilityStyles();
end;

function u1.closeFrame() -- Line: 333
    -- upvalues: u4 (ref), CameraController (copy), LocalPlayer (copy), u5 (ref), MenuState (copy), u2 (ref), GetUserPlatform (copy), ReplicatedStorage (copy)
    local Visible = u4.Visible;
    CameraController.setForceLockOverride("TeamSelection", false);

    if LocalPlayer.Character then
        CameraController.setForceLockOverride("Menu", false);
    end;

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, false);
    end;

    u4.Visible = false;

    if Visible or not u5.Menu.Visible then
        MenuState.SetScreen(nil);
    end;

    if u5.Menu.Visible then
        u5.Gameplay.Bottom.Visible = false;
        u5.Gameplay.Visible = false;
        u2 = false;

        return;
    end;

    u5.Gameplay.Middle.Crosshair.Visible = true;
    u5.Gameplay.Top.Visible = true;
    u5.Gameplay.Bottom.Visible = true;
    local v37 = table.find(GetUserPlatform(), "Mobile");
    local Character = LocalPlayer.Character;
    local v38 = LocalPlayer:GetAttribute("IsSpectating") == true;

    for _, child in ipairs(u5.Gameplay.Middle:GetChildren()) do
        local v39;

        if Character then
            v39 = Character:IsDescendantOf(workspace);
        else
            v39 = Character;
        end;

        local Name = child.Name;

        if Name == "Chat" then
            child.Visible = not v37;
        elseif Name == "MobileButtons" then
            local v40;

            if v37 then
                v40 = v39 or (v38 or false);
            else
                v40 = false;
            end;

            child.Visible = v40;
        elseif Name == "Votekick" then
            child.Visible = child:GetAttribute("IsVoteKickActive") == true;
        elseif Name == "Notification" then
            child.Visible = true;
        elseif Name == "SessionStats" then
            child.Visible = not v37;
        elseif Name == "Radar" or Name == "Crosshair" then
            child.Visible = v39;
        else
            child.Visible = false;
        end;
    end;

    if u2 then
        local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu);
        u2 = false;
        BuyMenu.openFrame();
    end;
end;

function u1.chooseTeam(p41) -- Line: 410
    -- upvalues: MenuState (copy), LocalPlayer (copy), Remotes (copy), u1 (copy), isTeamAvailable (copy), u3 (ref)
    MenuState.SetWantsMainMenu(false);

    if LocalPlayer:GetAttribute("Team") ~= p41 then
        if isTeamAvailable(LocalPlayer, p41) and tick() - u3 >= 1 then
            if p41 == "Spectators" then
                LocalPlayer:SetAttribute("PendingSpectateRequestAt", os.clock());
            end;

            Remotes.TeamSelection.SelectTeam.Send(p41);
            u3 = tick();
        end;

        return;
    end;

    if p41 == "Spectators" and not LocalPlayer:GetAttribute("IsSpectating") then
        Remotes.Spectate.StartSpectating.Send();
    end;

    u1.closeFrame();
end;

function u1.createTeamButtonAnimation(p42, u43) -- Line: 441
    -- upvalues: u4 (ref), u19 (copy)
    local u44 = u4:FindFirstChild(u43);

    if u44 then
        p42.MouseEnter:Connect(function() -- Line: 445
            -- upvalues: u19 (ref), u43 (copy), u44 (copy)
            if u19[u43] then
                return;
            end;

            local Outline = u44.Icon.Outline;
            local v45 = u43 == "Counter-Terrorists" and Color3.fromRGB(165, 183, 212);

            if not v45 then
                if u43 == "Terrorists" then
                    v45 = Color3.fromRGB(219, 199, 126);
                else
                    v45 = false;
                end;
            end;

            Outline.ImageColor3 = v45;
            local Icon = u44.Icon.Team.Icon;
            local v46 = u43 == "Counter-Terrorists" and Color3.fromRGB(255, 255, 255);

            if not v46 then
                if u43 == "Terrorists" then
                    v46 = Color3.fromRGB(255, 255, 255);
                else
                    v46 = false;
                end;
            end;

            Icon.ImageColor3 = v46;
            local Team = u44.Icon.Team;
            local v47 = u43 == "Counter-Terrorists" and Color3.fromRGB(36, 41, 47);

            if not v47 then
                if u43 == "Terrorists" then
                    v47 = Color3.fromRGB(89, 79, 50);
                else
                    v47 = false;
                end;
            end;

            Team.ImageColor3 = v47;
            u44.UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.14375), NumberSequenceKeypoint.new(0.318, 1), NumberSequenceKeypoint.new(1, 1) });

            for _, child in ipairs(u44.Container:GetChildren()) do
                if child:IsA("Frame") then
                    local v48 = u43 == "Counter-Terrorists" and Color3.fromRGB(126, 140, 187);

                    if not v48 then
                        if u43 == "Terrorists" then
                            v48 = Color3.fromRGB(219, 188, 110);
                        else
                            v48 = false;
                        end;
                    end;

                    child.BackgroundColor3 = v48;
                    local UIStroke = child.Player.UIStroke;
                    local v49 = u43 == "Counter-Terrorists" and Color3.fromRGB(165, 183, 212);

                    if not v49 then
                        if u43 == "Terrorists" then
                            v49 = Color3.fromRGB(219, 199, 126);
                        else
                            v49 = false;
                        end;
                    end;

                    UIStroke.Color = v49;
                    child.Player.Avatar.ImageColor3 = Color3.fromRGB(255, 255, 255);
                end;
            end;
        end);
        p42.MouseLeave:Connect(function() -- Line: 465
            -- upvalues: u19 (ref), u43 (copy), u44 (copy)
            if u19[u43] then
                return;
            end;

            local Outline = u44.Icon.Outline;
            local v50 = u43 == "Counter-Terrorists" and Color3.fromRGB(107, 119, 138);

            if not v50 then
                if u43 == "Terrorists" then
                    v50 = Color3.fromRGB(127, 115, 73);
                else
                    v50 = false;
                end;
            end;

            Outline.ImageColor3 = v50;
            local Icon = u44.Icon.Team.Icon;
            local v51 = u43 == "Counter-Terrorists" and Color3.fromRGB(131, 131, 131);

            if not v51 then
                if u43 == "Terrorists" then
                    v51 = Color3.fromRGB(182, 182, 182);
                else
                    v51 = false;
                end;
            end;

            Icon.ImageColor3 = v51;
            local Team = u44.Icon.Team;
            local v52 = u43 == "Counter-Terrorists" and Color3.fromRGB(20, 24, 27);

            if not v52 then
                if u43 == "Terrorists" then
                    v52 = Color3.fromRGB(58, 51, 33);
                else
                    v52 = false;
                end;
            end;

            Team.ImageColor3 = v52;
            u44.UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.14375), NumberSequenceKeypoint.new(0.183193, 1), NumberSequenceKeypoint.new(1, 1) });

            for _, child in ipairs(u44.Container:GetChildren()) do
                if child:IsA("Frame") then
                    local v53 = u43 == "Counter-Terrorists" and Color3.fromRGB(109, 121, 140);

                    if not v53 then
                        if u43 == "Terrorists" then
                            v53 = Color3.fromRGB(131, 111, 66);
                        else
                            v53 = false;
                        end;
                    end;

                    child.BackgroundColor3 = v53;
                    local UIStroke = child.Player.UIStroke;
                    local v54 = u43 == "Counter-Terrorists" and Color3.fromRGB(50, 56, 65);

                    if not v54 then
                        if u43 == "Terrorists" then
                            v54 = Color3.fromRGB(94, 85, 54);
                        else
                            v54 = false;
                        end;
                    end;

                    UIStroke.Color = v54;
                    child.Player.Avatar.ImageColor3 = Color3.fromRGB(138, 138, 138);
                end;
            end;
        end);
    end;
end;

function u1.updatePlayerList(u55, p56) -- Line: 490
    -- upvalues: u4 (ref), ReplicatedStorage (copy), Players (copy), u19 (copy), setPlayerTemplateUnhovered (copy), retrieveTeamCount (copy), updateTeamAvailabilityStyles (copy)
    local v57 = u55:GetAttribute("Team");

    if v57 == "Counter-Terrorists" or v57 == "Terrorists" then
        local v58 = u4:FindFirstChild(tostring(u55.UserId), true);

        if v58 then
            v58:Destroy();
        end;

        local v59 = ReplicatedStorage.Assets.UI.TeamSelection:FindFirstChild(v57);

        if v59 and not p56 then
            local v60 = u4:WaitForChild(v57);
            local _, result = pcall(function() -- Line: 504
                -- upvalues: Players (ref), u55 (copy)
                return Players:GetUserThumbnailAsync(u55.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
            end);
            local v61 = v59:Clone();
            v61.Parent = v60.Container;
            v61.Team.Text = u55.DisplayName;
            v61.Player.Avatar.Image = result;
            v61.Name = tostring(u55.UserId);
            v61.Visible = true;

            if u19[v57] then
                setPlayerTemplateUnhovered(v61, v57);
            end;
        end;
    else
        local v62 = u4:FindFirstChild(tostring(u55.UserId), true);

        if v62 then
            v62:Destroy();
        end;
    end;

    u4["Counter-Terrorists"].Players.Text = `{retrieveTeamCount("Counter-Terrorists")} Player(s)`;
    u4.Terrorists.Players.Text = `{retrieveTeamCount("Terrorists")} Player(s)`;
    updateTeamAvailabilityStyles();
end;

function u1.Initialize(p63, p64) -- Line: 533
    -- upvalues: u4 (ref), u5 (ref), Observers (copy), u1 (copy), LocalPlayer (copy), MenuState (copy), EndScreenController (copy), GameState (copy), GetTimerFormat (copy), updateTeamAvailabilityStyles (copy)
    u4 = p64;
    u5 = p63;
    Observers.observePlayer(function(u65) -- Line: 537
        -- upvalues: u1 (ref), Observers (ref), LocalPlayer (ref), u4 (ref)
        u1.updatePlayerList(u65);
        local u68 = Observers.observeAttribute(u65, "Team", function(p66) -- Line: 540
            -- upvalues: u1 (ref), u65 (copy), LocalPlayer (ref), u4 (ref)
            u1.updatePlayerList(u65);

            if LocalPlayer == u65 then
                u1.closeFrame();
            end;

            return function() -- Line: 547
                -- upvalues: u4 (ref), u65 (ref)
                local v67 = u4:FindFirstChild(tostring(u65.UserId), true);

                if v67 then
                    v67:Destroy();
                end;
            end;
        end);

        return function() -- Line: 556
            -- upvalues: u1 (ref), u65 (copy), u68 (copy)
            u1.updatePlayerList(u65, true);
            u68();
        end;
    end);

    local function ensureInputGateNotStuck() -- Line: 562
        -- upvalues: u5 (ref), MenuState (ref), EndScreenController (ref), LocalPlayer (ref), u4 (ref), u1 (ref)
        if not u5 then
            return;
        end;

        if u5.Menu and u5.Menu.Visible then
            return;
        end;

        if MenuState.IsCaseSceneActive() or MenuState.IsInspectActive() then
            return;
        end;

        if EndScreenController.IsActive() then
            return;
        end;

        local v69 = LocalPlayer:GetAttribute("Team");
        local v70 = v69 == "Counter-Terrorists" and true or v69 == "Terrorists";
        local v71 = LocalPlayer.Character ~= nil;

        if u4 and u4.Visible then
            if v70 and v71 then
                u1.closeFrame();
            end;

            return;
        end;

        local Gameplay = u5:FindFirstChild("Gameplay");

        if Gameplay then
            Gameplay = Gameplay:FindFirstChild("Bottom");
        end;

        if Gameplay and (Gameplay:IsA("GuiObject") and not Gameplay.Visible) then
            Gameplay.Visible = true;
        end;
    end;

    Observers.observeAttribute(LocalPlayer, "Team", function(p72) -- Line: 599
        -- upvalues: GameState (ref), u1 (ref), ensureInputGateNotStuck (copy)
        if GameState.GetState() == "Round In Progress" then
            u1.closeFrame();
        end;

        ensureInputGateNotStuck();
    end);
    Observers.observeAttribute(workspace, "Timer", function(p73) -- Line: 607
        -- upvalues: u4 (ref), GetTimerFormat (ref)
        u4.ProgressBar.Timer.Text = GetTimerFormat(p73);
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 612
        -- upvalues: ensureInputGateNotStuck (copy)
        ensureInputGateNotStuck();
    end);
    GameState.ListenToState(function(p74, p75) -- Line: 616
        -- upvalues: ensureInputGateNotStuck (copy)
        if p75 == "Buy Period" or p75 == "Round In Progress" then
            ensureInputGateNotStuck();
        end;
    end);
    Observers.observeAttribute(workspace, "VIPDisableTeamLimitEnabled", function() -- Line: 623
        -- upvalues: updateTeamAvailabilityStyles (ref)
        updateTeamAvailabilityStyles();
    end);
end;

function u1.Start() -- Line: 628
    -- upvalues: u4 (ref), u1 (copy), createButtonAnimation (copy), LocalPlayer (copy), retrieveTeamCount (copy), Remotes (copy), SpectateController (copy), MenuState (copy), ReplicatedStorage (copy), CameraController (copy), u5 (ref)
    local Button = u4["Counter-Terrorists"].Button;
    local u76 = "Counter-Terrorists";
    Button.MouseButton1Click:Connect(function() -- Line: 192
        -- upvalues: u1 (ref), u76 (copy)
        u1.chooseTeam(u76);
    end);
    u1.createTeamButtonAnimation(Button, "Counter-Terrorists");
    local Spectate = u4.Bottom.Buttons.Spectate;
    local u77 = "Spectators";
    Spectate.MouseButton1Click:Connect(function() -- Line: 192
        -- upvalues: u1 (ref), u77 (copy)
        u1.chooseTeam(u77);
    end);
    createButtonAnimation(Spectate);
    local Button2 = u4.Terrorists.Button;
    local u78 = "Terrorists";
    Button2.MouseButton1Click:Connect(function() -- Line: 192
        -- upvalues: u1 (ref), u78 (copy)
        u1.chooseTeam(u78);
    end);
    u1.createTeamButtonAnimation(Button2, "Terrorists");
    createButtonAnimation(u4.Bottom.Buttons.AutoSelect);
    u4.Bottom.Buttons.AutoSelect.MouseButton1Click:Connect(function() -- Line: 635
        -- upvalues: u1 (ref), LocalPlayer (ref), retrieveTeamCount (ref)
        local chooseTeam = u1.chooseTeam;
        local v79 = LocalPlayer;
        local v80 = retrieveTeamCount("Counter-Terrorists", v79);
        local v81 = retrieveTeamCount("Terrorists", v79);
        local v82;

        if v80 == v81 then
            local v83 = v79:GetAttribute("Team");
            v82 = v83 == "Counter-Terrorists" and "Terrorists" or (v83 == "Terrorists" and "Counter-Terrorists" or "Terrorists");
        else
            v82 = v80 < v81 and "Counter-Terrorists" or "Terrorists";
        end;

        chooseTeam(v82);
    end);
    createButtonAnimation(u4.Bottom.Buttons.BackHome);
    u4.Bottom.Buttons.BackHome.MouseButton1Click:Connect(function() -- Line: 640
        -- upvalues: LocalPlayer (ref), u1 (ref), Remotes (ref), SpectateController (ref), MenuState (ref), ReplicatedStorage (ref), CameraController (ref), u5 (ref)
        if LocalPlayer:GetAttribute("IsSpectating") ~= true then
            local Character = LocalPlayer.Character;
            local v84;

            if Character and Character:IsDescendantOf(workspace) then
                local Humanoid = Character:FindFirstChild("Humanoid");

                if Humanoid == nil then
                    v84 = false;
                else
                    v84 = Humanoid.Health > 0;
                end;
            else
                v84 = false;
            end;

            if v84 then
                u1.closeFrame();

                return;
            end;
        end;

        local v85 = LocalPlayer:GetAttribute("Team");

        if v85 and v85 ~= "Spectators" then
            Remotes.TeamSelection.SelectTeam.Send("Spectators");
        end;

        SpectateController.Stop(true, true);
        MenuState.SetWantsMainMenu(true);
        u1.closeFrame();
        local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
        local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
        CameraController.setForceLockOverride("Menu", true);
        CameraController.setPerspective(true, true);
        u5.Gameplay.Visible = false;
        u5.Gameplay.Bottom.Visible = false;
        u5.Menu.Visible = true;
        Top.ResetToMainMenu();
        MenuSceneController.ShowMenuScene();
    end);
end;

return u1;