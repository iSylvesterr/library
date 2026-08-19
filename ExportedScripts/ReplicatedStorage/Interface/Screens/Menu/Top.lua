-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local ConfigController = require(ReplicatedStorage.Controllers.ConfigController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection);
local CurrentCamera = workspace.CurrentCamera;
local BlurEffect = Instance.new("BlurEffect", Lighting);
BlurEffect.Enabled = false;
BlurEffect.Name = "Menu";
BlurEffect.Size = 20;
local u2 = false;
local u3 = false;
local u4 = false;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = Color3.fromRGB(255, 255, 255);
local u9 = Color3.fromRGB(150, 220, 239);
local u10 = Color3.fromRGB(175, 175, 175);
local u11 = nil;
local u12 = nil;

local function tweenButton(p13, p14) -- Line: 74
    -- upvalues: TweenService (copy), u9 (copy), u10 (copy)
    if p13:IsA("ImageButton") then
        TweenService:Create(p13, TweenInfo.new(0.15), {
            ImageColor3 = p14
        }):Play();

        return;
    end;

    if p13:IsA("TextButton") then
        local v15 = p13:GetAttribute("DefaultSize") or p13.Size;
        local v16 = p14 == u9 and 1.12 or (p14 == u10 and 1.06 or 1);
        TweenService:Create(p13, TweenInfo.new(0.15), {
            Size = UDim2.new(v15.X.Scale * v16, v15.X.Offset * v16, v15.Y.Scale * v16, v15.Y.Offset * v16)
        }):Play();
    end;
end;

local function setupButton(u17) -- Line: 98
    -- upvalues: u8 (copy), u7 (ref), tweenButton (copy), Router (copy), u10 (copy), u9 (copy)
    for _, descendant in ipairs(u17:GetDescendants()) do
        if descendant:IsA("GuiObject") and (not descendant:IsA("GuiButton") and descendant.Active) then
            descendant.Active = false;
        end;
    end;

    if u17:IsA("ImageButton") then
        u17.ImageColor3 = u8;
    elseif u17:IsA("TextButton") then
        u17.TextLabel.TextColor3 = u8;
        u17:SetAttribute("DefaultSize", u17.Size);
    end;

    u17.MouseLeave:Connect(function() -- Line: 114
        -- upvalues: u7 (ref), u17 (copy), tweenButton (ref), u8 (ref)
        if u7 == u17 then
            return;
        end;

        tweenButton(u17, u8);
    end);
    u17.MouseEnter:Connect(function() -- Line: 121
        -- upvalues: Router (ref), u7 (ref), u17 (copy), tweenButton (ref), u10 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");

        if u7 == u17 then
            return;
        end;

        tweenButton(u17, u10);
    end);
    u17.MouseButton1Click:Connect(function() -- Line: 130
        -- upvalues: u7 (ref), u17 (copy), tweenButton (ref), u9 (ref), u8 (ref)
        local v18 = u7;
        u7 = u17;

        if v18 ~= u17 then
            tweenButton(u17, u9);

            if v18 then
                local Alert = v18:FindFirstChild("Alert");
                tweenButton(v18, u8);

                if Alert then
                    Alert.Visible = false;
                end;
            end;
        end;
    end);
end;

local function toMenuScreen(p19) -- Line: 151
    if p19 == "Dashboard" or (p19 == "Inventory" or (p19 == "Loadout" or (p19 == "Modes" or (p19 == "Settings" or (p19 == "Store" or p19 == "GameDashboard"))))) then
        return p19;
    end;

    return nil;
end;

local function syncControlLockWithMenuVisibility() -- Line: 166
    -- upvalues: u12 (ref), TeamSelection (copy), u3 (ref), InputController (copy)
    local v20 = u12 and u12.Menu and u12.Menu.Visible;
    local v21 = TeamSelection.isVisible();
    local v22 = v20 == true and true or v21 == true;

    if not v22 or u3 then
        if not v22 and u3 then
            InputController.enableGroup("Gameplay");
            u3 = false;
        end;

        return;
    end;

    InputController.disableGroup("Gameplay");
    u3 = true;
end;

function u1.UpdateBackground(p23) -- Line: 183
    -- upvalues: Profiler (copy), ReplicatedStorage (copy), MenuState (copy), LocalPlayer (copy), u12 (ref), CurrentCamera (copy), CameraController (copy)
    Profiler.mark("UI.Top.UpdateBackground");

    if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive() then
        return;
    end;

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    if LocalPlayer:GetAttribute("IsSpectating") then
        return;
    end;

    local v24 = u12.Menu.Visible and (not LocalPlayer.Character and p23:FindFirstChild("Cameras"));

    if v24 then
        local v25 = v24:GetChildren();
        assert(v25[1], "Current map doesnt contain any cameras.");
        CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        CurrentCamera.CameraSubject = nil;
        local v26 = v25[math.random(1, #v25)];
        LocalPlayer.ReplicationFocus = v26;
        CurrentCamera.CFrame = v26.CFrame;
        CameraController.updateCameraFOV(80);
    end;
end;

function u1.ToggleMenu() -- Line: 223
    -- upvalues: Profiler (copy), MenuState (copy), u1 (copy), GameState (copy), u12 (ref), CameraController (copy), LocalPlayer (copy), GetUserPlatform (copy), TeamSelection (copy), u6 (ref)
    Profiler.mark("UI.Top.ToggleMenu");

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    if workspace:FindFirstChild("Map") then
        u1.UpdateBackground(workspace:FindFirstChild("Map"));
    end;

    local v27 = GameState.GetState();

    if not v27 or (v27 == "Map Voting" or v27 == "Game Ending") then
        return;
    end;

    if not u12.Menu.Visible then
        if u12.Gameplay.Middle.TeamSelection.Visible then
            TeamSelection.closeFrame();
        end;

        CameraController.setForceLockOverride("Menu", true);

        if not LocalPlayer:GetAttribute("IsSpectating") then
            CameraController.setPerspective(true, true);
        end;

        u12.Gameplay.Visible = false;
        u12.Menu.Visible = true;

        if LocalPlayer.Character then
            u1.openFrame("GameDashboard");
        end;

        if u6 and u6.Name ~= "Dashboard" then
            MenuState.SetBlurEnabled(true);
        end;

        return;
    end;

    MenuState.SetWantsMainMenu(false);
    CameraController.setForceLockOverride("Menu", false);

    if not LocalPlayer:GetAttribute("IsSpectating") then
        CameraController.setPerspective(true, false);
    end;

    MenuState.SetBlurEnabled(false);
    u12.Gameplay.Visible = true;
    u12.Gameplay.Top.Visible = true;
    local v28 = table.find(GetUserPlatform(), "Mobile") == nil;
    u12.Gameplay.Middle.SessionStats.Visible = v28;
    u12.Gameplay.Middle.Chat.Visible = v28;
    MenuState.HideMenu();
end;

function u1.openFrame(p29, p30) -- Line: 286
    -- upvalues: Profiler (copy), MenuState (copy), Router (copy), u12 (ref), GameState (copy), ReplicatedStorage (copy), u1 (copy), CameraController (copy), u6 (ref), LocalPlayer (copy), GetUserPlatform (copy), u2 (ref)
    Profiler.mark((`UI.Top.OpenFrame.{p29}`));

    if MenuState.IsInspectActive() then
        return;
    end;

    if MenuState.IsCaseSceneActive() then
        return;
    end;

    if p29 == "Store" and not MenuState.IsStoreEnabled() then
        Router.broadcastRouter("RunInterfaceSound", "UI Store Click");

        return;
    end;

    local v31;

    if p29 == "Dashboard" then
        v31 = false;
    else
        v31 = p29 ~= "Play";
    end;

    MenuState.SetBlurEnabled(v31);
    local Pattern = u12.Menu:FindFirstChild("Pattern");
    u12.Menu.BackgroundTransparency = v31 and 0.15 or 1;

    if Pattern then
        Pattern.Visible = not v31;
    end;

    if p29 == "Play" then
        local v32 = GameState.GetState();
        local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);

        if v32 and (v32 ~= "Game Ending" or not EndScreenController.IsActive()) then
            local v33 = nil;
            Router.broadcastRouter("RunInterfaceSound", "UI Play Click");

            if p30 then
                u1.reportPressedPlay();
                MenuState.SetWantsMainMenu(false);
            end;

            CameraController.resetForceLockOverride();
            CameraController.setPerspective(true, false);

            if u6 and u6.Name ~= "Dashboard" then
                u6.Visible = false;
                local Dashboard = u12.Menu:FindFirstChild("Dashboard");

                if Dashboard then
                    Dashboard.Visible = true;
                    u6 = Dashboard;
                end;
            end;

            u12.Gameplay.Bottom.Visible = false;
            u12.Gameplay.Top.Visible = true;
            u12.Gameplay.Visible = true;
            MenuState.HideMenu();
            local v34;

            if v32 == "Map Voting" then
                v34 = "EndScreen";
            else
                local v35 = LocalPlayer:GetAttribute("Team");
                v34 = (not LocalPlayer.Character or (not v35 or v35 == "Spectators")) and "TeamSelection" or v33;
            end;

            if v34 then
                CameraController.setForceLockOverride(v34, true);
                CameraController.setPerspective(true, true);

                for _, child in ipairs(u12.Gameplay.Middle:GetChildren()) do
                    if child.Name == "Chat" then
                        child.Visible = not table.find(GetUserPlatform(), "Mobile");
                    else
                        child.Visible = (child.Name == "Notification" or child.Name == "Votekick" and child:GetAttribute("IsVoteKickActive") == true) and true or child.Name == v34;
                    end;
                end;

                return;
            end;

            local v36 = table.find(GetUserPlatform(), "Mobile") == nil;
            u12.Gameplay.Middle.SessionStats.Visible = v36;
            u12.Gameplay.Middle.Chat.Visible = v36;
            u12.Gameplay.Middle.TeamSelection.Visible = false;
            u12.Gameplay.Middle.Crosshair.Visible = true;
            u12.Gameplay.Top.Visible = true;
            u12.Gameplay.Bottom.Visible = true;

            if LocalPlayer.Character then
                CameraController.setPerspective(true, false);

                return;
            end;
        end;

        return;
    end;

    if p29 == "Inventory" then
        Router.broadcastRouter("ResetInventoryToGrid");
    end;

    local v37 = u12.Menu:FindFirstChild(p29);

    if v37 and v37 ~= u6 then
        v37.Visible = true;

        if p29 ~= "Updates" then
            if u6 then
                u6.Visible = false;
            end;

            u6 = v37;
        end;

        local v38;

        if p29 == "Dashboard" or (p29 == "Inventory" or (p29 == "Loadout" or (p29 == "Modes" or (p29 == "Settings" or (p29 == "Store" or p29 == "GameDashboard"))))) then
            v38 = p29;
        else
            v38 = nil;
        end;

        MenuState.SetScreen(v38);
    end;

    if u2 then
        Router.broadcastRouter("RunInterfaceSound", (`UI {p29} Click`));

        return;
    end;

    u2 = p29 == "Dashboard";
end;

function u1.reportPressedPlay() -- Line: 420
    -- upvalues: u5 (ref), Remotes (copy)
    if u5 then
        return;
    end;

    u5 = true;
    Remotes.Player.PressedPlay.Send();
end;

function u1.CloseTeamSelection() -- Line: 431
    -- upvalues: u12 (ref), BlurEffect (copy), u1 (copy)
    u12.Gameplay.Middle.TeamSelection.Visible = false;
    u12.Gameplay.Middle.Crosshair.Visible = true;
    u12.Gameplay.Top.Visible = true;
    u12.Gameplay.Bottom.Visible = true;

    if BlurEffect.Enabled then
        u1.UpdateBackground(workspace:FindFirstChild("Map"));
    end;
end;

local u39 = { "Inventory", "Loadout", "Play", "Store", "Modes" };

local function getControllerCurrentTab() -- Line: 448
    -- upvalues: u7 (ref), u39 (copy)
    local v40 = u7 and u7.Name or nil;

    for _, v in ipairs(u39) do
        if v == v40 then
            return v;
        end;
    end;

    return "Play";
end;

local function getTabForBumper(p41, p42) -- Line: 459
    -- upvalues: u39 (copy)
    local v43 = table.find(u39, p41);

    if not v43 then
        return nil;
    end;

    local v44 = #u39;

    if p42 then
        return u39[(v43 - 2 + v44) % v44 + 1];
    end;

    return u39[v43 % v44 + 1];
end;

local function getTopButton(p45) -- Line: 472
    -- upvalues: u11 (ref)
    if not u11 then
        return nil;
    end;

    for _, v in ipairs({ "Top", "Bottom" }) do
        local v46 = u11:FindFirstChild(v);

        if v46 then
            v46 = v46:FindFirstChild("Buttons");
        end;

        if v46 then
            v46 = v46:FindFirstChild(p45);
        end;

        if v46 and v46:IsA("GuiButton") then
            return v46;
        end;
    end;

    return nil;
end;

local function selectTabOnly(p47) -- Line: 488
    -- upvalues: getTopButton (copy), u7 (ref), tweenButton (copy), u9 (copy), u8 (copy), GuiService (copy), Router (copy)
    local v48 = getTopButton(p47);

    if not v48 then
        return;
    end;

    local v49 = u7;
    u7 = v48;
    tweenButton(u7, u9);

    if v49 and v49 ~= u7 then
        tweenButton(v49, u8);
    end;

    GuiService.SelectedObject = v48;
    Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
end;

local function goToTab(p50) -- Line: 503
    -- upvalues: getTopButton (copy), u1 (copy), u7 (ref), tweenButton (copy), u9 (copy), u8 (copy), GuiService (copy), Router (copy)
    local v51 = getTopButton(p50);

    if not v51 then
        return;
    end;

    u1.openFrame(p50);
    local v52 = u7;
    u7 = v51;
    tweenButton(u7, u9);

    if v52 and v52 ~= u7 then
        tweenButton(v52, u8);
    end;

    GuiService.SelectedObject = v51;
    Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
end;

local function autoPressPlayForNewUser() -- Line: 519
    -- upvalues: u4 (ref), u5 (ref), MenuState (copy), GameState (copy), DataController (copy), LocalPlayer (copy), ConfigController (copy), u1 (copy)
    if u4 or u5 then
        return;
    end;

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    local v53 = GameState.GetState();

    if not v53 or v53 == "Game Ending" then
        return;
    end;

    local v54 = DataController.Get(LocalPlayer, "Statistics.Joins");

    if typeof(v54) ~= "number" or v54 > 1 then
        return;
    end;

    if not ConfigController.Get("IsNewOnboarding") then
        return;
    end;

    u4 = true;
    u1.openFrame("Play", true);
end;

local function shouldPreserveMenuFrame() -- Line: 543
    -- upvalues: u12 (ref), MenuState (copy)
    if not u12 then
        return false;
    end;

    local v55 = MenuState.GetCurrentScreen();

    if not (u12.Menu.Visible and v55) then
        return false;
    end;

    if v55 ~= "Loadout" and (v55 ~= "Inventory" and (v55 ~= "Modes" and v55 ~= "Settings")) and v55 ~= "Store" then
        return false;
    end;

    local v56 = u12.Menu:FindFirstChild(v55);
    local v57;

    if v56 == nil then
        v57 = false;
    else
        v57 = v56.Visible;
    end;

    return v57;
end;

function u1.ResetToMainMenu() -- Line: 567
    -- upvalues: Profiler (copy), MenuState (copy), shouldPreserveMenuFrame (copy), u12 (ref), u6 (ref), u7 (ref), tweenButton (copy), u8 (copy), u11 (ref), u9 (copy)
    Profiler.mark("UI.Top.ResetToMainMenu");

    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return;
    end;

    if shouldPreserveMenuFrame() then
        return;
    end;

    for _, child in ipairs(u12.Menu:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "Top" and child.Name ~= "Dashboard") then
            child.Visible = false;
        end;
    end;

    local Dashboard = u12.Menu:FindFirstChild("Dashboard");

    if Dashboard then
        Dashboard.Visible = true;
        u6 = Dashboard;
    end;

    local Top = u12.Menu:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    MenuState.SetBlurEnabled(false);
    u12.Menu.BackgroundTransparency = 1;
    local Pattern = u12.Menu:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = true;
    end;

    MenuState.SetScreen("Dashboard");

    if u7 then
        tweenButton(u7, u8);
    end;

    u7 = u11.Top.Buttons.Dashboard;
    tweenButton(u7, u9);
end;

function u1.Initialize(p58, p59) -- Line: 623
    -- upvalues: Profiler (copy), u12 (ref), u11 (ref), setupButton (copy), ActivateButton (copy), u1 (copy)
    Profiler.mark("UI.Top.Initialize");
    u12 = p58;
    u11 = p59;

    for _, child in ipairs(u11.Top.Buttons:GetChildren()) do
        if child:IsA("ImageButton") then
            setupButton(child);
            ActivateButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 632
                -- upvalues: u1 (ref), child (copy)
                u1.openFrame(child.Name, child.Name == "Play");
            end);
        end;
    end;

    for _, child in ipairs(u11.Bottom.Buttons:GetChildren()) do
        if child:IsA("ImageButton") then
            setupButton(child);
            ActivateButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 643
                -- upvalues: u1 (ref), child (copy)
                u1.openFrame(child.Name, child.Name == "Play");
            end);
        end;
    end;

    if workspace:FindFirstChild("Map") then
        u1.UpdateBackground(workspace:FindFirstChild("Map"));
    end;

    workspace.ChildAdded:Connect(function(p60) -- Line: 653
        -- upvalues: u1 (ref)
        if p60.Name == "Map" then
            task.delay(0.25, u1.UpdateBackground, p60);
        end;
    end);
end;

function u1.Start() -- Line: 662
    -- upvalues: Profiler (copy), u7 (ref), u11 (ref), tweenButton (copy), u9 (copy), u12 (ref), CameraController (copy), syncControlLockWithMenuVisibility (copy), LocalPlayer (copy), UserInputService (copy), MenuState (copy), u39 (copy), getTopButton (copy), u8 (copy), GuiService (copy), Router (copy), goToTab (copy), u1 (copy), u6 (ref), Observers (copy), GameState (copy), ReplicatedStorage (copy), shouldPreserveMenuFrame (copy), DataController (copy), autoPressPlayForNewUser (copy), ConfigController (copy)
    debug.setmemorycategory("UI.Top.Start");
    Profiler.mark("UI.Top.Start");
    u7 = u11.Top.Buttons.Dashboard;
    tweenButton(u7, u9);
    local Pattern = u12.Menu:FindFirstChild("Pattern");
    u12.Menu.BackgroundTransparency = 1;

    if Pattern then
        Pattern.Visible = false;
    end;

    if u12.Menu.Visible then
        CameraController.setForceLockOverride("Menu", true);
    end;

    u12.Menu:GetPropertyChangedSignal("Visible"):Connect(syncControlLockWithMenuVisibility);
    local Gameplay = u12:FindFirstChild("Gameplay");
    local v61;

    if Gameplay then
        v61 = Gameplay:FindFirstChild("Middle");
    else
        v61 = Gameplay;
    end;

    if v61 then
        v61 = v61:FindFirstChild("TeamSelection");
    end;

    if Gameplay then
        Gameplay = Gameplay:FindFirstChild("Bottom");
    end;

    if v61 and v61:IsA("GuiObject") then
        v61:GetPropertyChangedSignal("Visible"):Connect(syncControlLockWithMenuVisibility);
    end;

    if Gameplay and Gameplay:IsA("GuiObject") then
        Gameplay:GetPropertyChangedSignal("Visible"):Connect(syncControlLockWithMenuVisibility);
    end;

    syncControlLockWithMenuVisibility();
    local v62 = LocalPlayer:GetAttribute("Team");

    if not LocalPlayer.Character and (v62 ~= "Counter-Terrorists" and v62 ~= "Terrorists") then
        if not CameraController.isForceLockOverrideActive() then
            CameraController.setForceLockOverride("Menu", true);
        end;

        if not u12.Menu.Visible then
            u12.Menu.Visible = true;
        end;

        u12.Gameplay.Visible = false;
        u12.Gameplay.Bottom.Visible = false;
    end;

    UserInputService.InputBegan:Connect(function(p63, p64) -- Line: 713
        -- upvalues: u12 (ref), MenuState (ref), LocalPlayer (ref), u7 (ref), u39 (ref), getTopButton (ref), tweenButton (ref), u9 (ref), u8 (ref), GuiService (ref), Router (ref), goToTab (ref)
        if not (u12 and u12.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        local v65;

        if p63.UserInputType == Enum.UserInputType.Gamepad1 then
            v65 = p63.KeyCode == Enum.KeyCode.ButtonL1;
        else
            v65 = false;
        end;

        local v66;

        if p63.UserInputType == Enum.UserInputType.Gamepad1 then
            v66 = p63.KeyCode == Enum.KeyCode.ButtonR1;
        else
            v66 = false;
        end;

        if not (v65 or v66) then
            return;
        end;

        local v67 = u7 and u7.Name or nil;

        for _, v in ipairs(u39) do
            if v == v67 then
                break;
            end;
        end;

        local v68;

        if v65 then
            local v69 = table.find(u39, v);

            if v69 then
                local v70 = #u39;
                v68 = u39[(v69 - 2 + v70) % v70 + 1];
            else
                v68 = nil;
            end;
        else
            local v71 = table.find(u39, v);

            if v71 then
                v68 = u39[v71 % #u39 + 1];
            else
                v68 = nil;
            end;
        end;

        if v68 then
            if v68 == "Play" then
                local v72 = getTopButton("Play");

                if not v72 then
                    return;
                end;

                local v73 = u7;
                u7 = v72;
                tweenButton(u7, u9);

                if v73 and v73 ~= u7 then
                    tweenButton(v73, u8);
                end;

                GuiService.SelectedObject = v72;
                Router.broadcastRouter("RunInterfaceSound", "UI Highlight");

                return;
            end;

            goToTab(v68);
        end;
    end);
    UserInputService.InputBegan:Connect(function(p74, p75) -- Line: 742
        -- upvalues: u12 (ref), MenuState (ref), LocalPlayer (ref), getTopButton (ref), GuiService (ref), u1 (ref)
        if not (u12 and u12.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p74.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        if p74.KeyCode ~= Enum.KeyCode.ButtonA then
            return;
        end;

        local v76 = getTopButton("Play");

        if not v76 then
            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject ~= v76 and not (SelectedObject and SelectedObject:IsDescendantOf(v76)) then
            return;
        end;

        u1.openFrame("Play", true);
    end);
    u1.openFrame("Dashboard");
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 774
        -- upvalues: u12 (ref), MenuState (ref), u11 (ref), GuiService (ref), u39 (ref), getTopButton (ref), u7 (ref), tweenButton (ref), u9 (ref), u8 (ref), Router (ref)
        if not (u12 and u12.Menu.Visible) then
            return;
        end;

        if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
            return;
        end;

        if not u11 then
            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if not SelectedObject then
            return;
        end;

        local v77 = nil;

        for _, v in ipairs(u39) do
            local v78 = getTopButton(v);

            if v78 and (SelectedObject == v78 or SelectedObject:IsDescendantOf(v78)) then
                v77 = v78;
                break;
            end;
        end;

        local v79;

        if v77 then
            v79 = v77;
        else
            v79 = getTopButton("Dashboard");

            if not v79 or SelectedObject ~= v79 and not SelectedObject:IsDescendantOf(v79) then
                v79 = v77;
            end;
        end;

        if v79 and u7 ~= v79 then
            local v80 = u7;
            u7 = v79;
            tweenButton(v79, u9);

            if v80 then
                tweenButton(v80, u8);
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        end;
    end);
    MenuState.OnScreenChanged:Connect(function(p81, p82) -- Line: 816
        -- upvalues: u12 (ref), u6 (ref), u11 (ref), u7 (ref), tweenButton (ref), u9 (ref), u8 (ref)
        if not p82 then
            return;
        end;

        local v83 = u12.Menu:FindFirstChild(p82);

        if v83 and v83:IsA("Frame") then
            u6 = v83;
        end;

        local v84 = u11.Bottom.Buttons:FindFirstChild(p82) or u11.Top.Buttons:FindFirstChild(p82);

        if v84 and (v84:IsA("GuiButton") and u7 ~= v84) then
            local v85 = u7;
            u7 = v84;
            tweenButton(v84, u9);

            if v85 then
                tweenButton(v85, u8);
            end;
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function(p86) -- Line: 847
        -- upvalues: Profiler (ref), u12 (ref), MenuState (ref), CameraController (ref)
        Profiler.defer("UI.Top.CharacterAddedDeferred", function() -- Line: 850
            -- upvalues: u12 (ref), MenuState (ref), CameraController (ref)
            if not (u12.Menu.Visible or (u12.Gameplay.Middle.TeamSelection.Visible or (MenuState.IsCaseSceneActive() or MenuState.IsInspectActive()))) then
                CameraController.resetForceLockOverride();
                CameraController.setPerspective(true, false);
            end;
        end);
    end);
    Observers.observeAttribute(LocalPlayer, "Team", function(p87) -- Line: 864
        -- upvalues: u1 (ref)
        if p87 == "Spectators" then
            u1.CloseTeamSelection();
        end;
    end);
    GameState.ListenToState(function(p88, p89) -- Line: 870
        -- upvalues: MenuState (ref), u12 (ref), CameraController (ref), ReplicatedStorage (ref), Router (ref), shouldPreserveMenuFrame (ref), u1 (ref), LocalPlayer (ref), Profiler (ref)
        if MenuState.IsCaseSceneActive() then
            if p89 == "Game Ending" or p89 == "Map Voting" then
                u12.Gameplay.Bottom.Visible = false;
                u12.Gameplay.Visible = false;
            end;

            return;
        end;

        if MenuState.IsInspectActive() then
            return;
        end;

        if MenuState.IsTradeUpActive() then
            if p89 == "Game Ending" or p89 == "Map Voting" then
                u12.Gameplay.Bottom.Visible = false;
                u12.Gameplay.Visible = false;

                if not u12.Menu.Visible then
                    CameraController.setForceLockOverride("Menu", true);
                    u12.Menu.Visible = true;
                end;
            end;

            return;
        end;

        if p89 == "Game Ending" or p89 == "Map Voting" then
            if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
                if MenuState.IsInspectActive() then
                    Router.broadcastRouter("WeaponInspectCloseForGameEnd");
                end;

                return;
            end;

            u12.Gameplay.Visible = false;
            u12.Gameplay.Bottom.Visible = false;

            if MenuState.IsInspectActive() then
                Router.broadcastRouter("WeaponInspectCloseForGameEnd");
            end;

            if not shouldPreserveMenuFrame() then
                u1.ResetToMainMenu();
            end;

            if not u12.Menu.Visible then
                CameraController.setForceLockOverride("Menu", true);
                u12.Menu.Visible = true;
            end;
        end;

        if p89 == "Map Voting" then
            if LocalPlayer:GetAttribute("FollowGamemode") or LocalPlayer:GetAttribute("IsSpectating") then
                if u12.Menu.Visible and (MenuState.WantsMainMenu() or shouldPreserveMenuFrame()) then
                    return;
                end;

                u1.openFrame("Play");

                return;
            end;

            if not (u12.Menu.Visible or shouldPreserveMenuFrame()) then
                u1.openFrame("Dashboard");
                u1.ToggleMenu();
            end;
        end;

        if (p88 == "Game Ending" or p88 == "Map Voting") and (p89 ~= "Game Ending" and p89 ~= "Map Voting") then
            if p88 == "Map Voting" then
                if u12.Menu.Visible then
                    return;
                end;

                if MenuState.WantsMainMenu() then
                    u1.ResetToMainMenu();
                    CameraController.setForceLockOverride("Menu", true);
                    u12.Gameplay.Visible = false;
                    u12.Gameplay.Bottom.Visible = false;
                    u12.Menu.Visible = true;

                    return;
                end;

                local v90 = LocalPlayer:GetAttribute("Team");

                if not LocalPlayer.Character or (not v90 or v90 == "Spectators") then
                    MenuState.HideMenu();
                    u12.Gameplay.Visible = true;
                    u12.Gameplay.Top.Visible = true;
                    require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection).openFrame();

                    return;
                end;
            elseif u12.Menu.Visible and shouldPreserveMenuFrame() then
                return;
            end;

            Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 997
                -- upvalues: MenuState (ref), ReplicatedStorage (ref), u12 (ref), shouldPreserveMenuFrame (ref), u1 (ref), CameraController (ref)
                if MenuState.IsInspectActive() then
                    return;
                end;

                if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive() and not u12.Menu.Visible then
                    if not shouldPreserveMenuFrame() then
                        u1.ResetToMainMenu();
                    end;

                    CameraController.setForceLockOverride("Menu", true);
                    u12.Gameplay.Visible = false;
                    u12.Menu.Visible = true;
                end;
            end);
        end;

        if p89 == "Game Ending" or (p89 == "Map Voting" or not (u12.Menu.Visible and shouldPreserveMenuFrame())) then
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Statistics.Joins", autoPressPlayForNewUser);
    ConfigController.OnChanged("IsNewOnboarding", autoPressPlayForNewUser);
    GameState.ListenToState(function() -- Line: 1031
        -- upvalues: Profiler (ref), autoPressPlayForNewUser (ref)
        Profiler.defer("UI.Top.AutoPressPlayDeferred", autoPressPlayForNewUser);
    end);
    Profiler.defer("UI.Top.AutoPressPlayDeferred", autoPressPlayForNewUser);
end;

return u1;