-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local HintController = require(ReplicatedStorage.Controllers.HintController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Promise = require(ReplicatedStorage.Shared.Promise);
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection);
local BuyMenu = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu);
local Leaderboard = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard);
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Buttons = require(script.Buttons);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local CameraInput = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("CameraInput"));
local u2 = RaycastParams.new();
u2.FilterType = Enum.RaycastFilterType.Exclude;
u2.IgnoreWater = false;
local v3 = GetUserPlatform();
local u4 = table.find(v3, "Mobile") and #v3 <= 1;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = 0;
local u11 = {};
local u12 = {};
local u13 = TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
local BUTTONS_WITH_EXPLICIT_INPUT_ENDED = Buttons.BUTTONS_WITH_EXPLICIT_INPUT_ENDED;
local BUTTONS_WITH_EXPLICIT_HANDLERS = Buttons.BUTTONS_WITH_EXPLICIT_HANDLERS;
local BUTTONS_EXCLUDED_FROM_CLEARING = Buttons.BUTTONS_EXCLUDED_FROM_CLEARING;
local SPECTATE_MOBILE_BUTTONS = Buttons.SPECTATE_MOBILE_BUTTONS;
local GAMEPLAY_MOBILE_BUTTONS = Buttons.GAMEPLAY_MOBILE_BUTTONS;
local u14 = nil;

local function IsCharacterAlive(p15) -- Line: 102
    local Character = p15.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local v16 = Character:FindFirstChildOfClass("Humanoid");

        if v16 and v16.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

local function GetWeaponDataFromInstance(p17) -- Line: 115
    -- upvalues: CollectionService (copy)
    while p17 do
        if CollectionService:HasTag(p17, "WeaponDropped") then
            local v18 = p17:GetAttribute("Weapon");
            local v19 = p17:GetAttribute("Skin");

            if v18 and v19 then
                return v18, v19, p17.Name;
            end;

            break;
        end;

        p17 = p17.Parent;
    end;

    return nil, nil, nil;
end;

local function GetPingRaycastResult(...) -- Line: 138
    -- upvalues: CurrentCamera (copy), u2 (copy)
    local v20 = { CurrentCamera, ... };
    u2.FilterDescendantsInstances = v20;
    local v21 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * 1000, u2);

    while v21 and v21.Instance do
        local Instance = v21.Instance;

        if not Instance:IsA("BasePart") or Instance.Transparency <= 0.98 then
            break;
        end;

        table.insert(v20, Instance);
        u2.FilterDescendantsInstances = v20;
        v21 = workspace:Raycast(v21.Position, CurrentCamera.CFrame.LookVector.Unit * (1000 - v21.Distance), u2);
    end;

    return v21 or nil;
end;

local function ValidateButtonTouch(p22, p23) -- Line: 182
    -- upvalues: u11 (copy)
    local v24 = u11[p22];

    if v24 then
        return (not p23 or p23 == v24) and true or false;
    end;

    return false;
end;

local function IsNewTouch(p25) -- Line: 198
    return p25.UserInputState == Enum.UserInputState.Begin;
end;

local function TrackButtonTouchStart(p26, p27) -- Line: 204
    -- upvalues: u11 (copy)
    if not u11[p26] and p27.UserInputState == Enum.UserInputState.Begin then
        u11[p26] = p27;
    end;
end;

local function TrackButtonTouchEnd(p28, p29) -- Line: 214
    -- upvalues: u11 (copy)
    if u11[p28] == p29 then
        u11[p28] = nil;
    end;
end;

local function IsInputInsideButton(p30, p31) -- Line: 223
    local Position = p31.Position;
    local AbsolutePosition = p30.AbsolutePosition;
    local AbsoluteSize = p30.AbsoluteSize;
    local v32;

    if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
        v32 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v32 = false;
    end;

    return v32;
end;

local function UpdateButtonVisibilityForSpectate(p33) -- Line: 237
    -- upvalues: u14 (ref), GAMEPLAY_MOBILE_BUTTONS (copy), SPECTATE_MOBILE_BUTTONS (copy)
    if not u14 then
        return;
    end;

    for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
        local v34 = u14:FindFirstChild(v);

        if v34 then
            v34.Visible = p33 and table.find(SPECTATE_MOBILE_BUTTONS, v) ~= nil and true or not p33;
        end;
    end;
end;

local function GetHoveredHostage() -- Line: 254
    -- upvalues: CenterScreenRaycast (copy)
    return CenterScreenRaycast.GetHoveredHostage();
end;

local function GetHoveredBreakableDoor() -- Line: 260
    -- upvalues: CenterScreenRaycast (copy), CollectionService (copy)
    local v35 = {};
    local v36 = CenterScreenRaycast.FindTaggedAncestor("BreakableDoor", 8);

    if v36 and (v36:IsA("Model") and v36:GetAttribute("Destroyed") ~= true) then
        table.insert(v35, v36);

        for _, v in CollectionService:GetTagged("BreakableDoor") do
            if v ~= v36 and v:GetAttribute("Destroyed") ~= true then
                local BreakableDoorHingePivot = v36:FindFirstChild("BreakableDoorHingePivot");
                local BreakableDoorHingePivot2 = v:FindFirstChild("BreakableDoorHingePivot");

                if BreakableDoorHingePivot and (BreakableDoorHingePivot2 and (BreakableDoorHingePivot.Position - BreakableDoorHingePivot2.Position).Magnitude <= 20) then
                    table.insert(v35, v);
                end;
            end;
        end;
    end;

    return v35;
end;

local function MultiplyUdim2(p37, p38) -- Line: 285
    return UDim2.fromScale(p37.X.Scale * p38, p37.Y.Scale * p38);
end;

local function GetButtonRestingSize(p39) -- Line: 291
    -- upvalues: u12 (copy)
    return u12[p39] or p39.Size;
end;

local function SetButtonRestingSize(p40, p41) -- Line: 297
    -- upvalues: u12 (copy)
    u12[p40] = p41 or p40.Size;
end;

local function TweenButtonToRestingScale(p42, p43) -- Line: 303
    -- upvalues: TweenService (copy), u13 (copy), u12 (copy)
    local v44 = {};
    local v45 = u12[p42] or p42.Size;
    v44.Size = UDim2.fromScale(v45.X.Scale * p43, v45.Y.Scale * p43);
    TweenService:Create(p42, u13, v44):Play();
end;

local function GetCurrentEquipped() -- Line: 311
    -- upvalues: Promise (copy), InventoryController (copy)
    return Promise.new(function(p46, p47) -- Line: 312
        -- upvalues: InventoryController (ref)
        local v48 = InventoryController.getCurrentEquipped();

        if v48 then
            p46(v48);

            return;
        end;

        p47("Failed to fetch current equipped");
    end):catch(warn);
end;

local function UpdateInteractButton() -- Line: 327
    -- upvalues: u14 (ref), CollectionService (copy), u9 (ref), LocalPlayer (copy), CenterScreenRaycast (copy), GetHoveredBreakableDoor (copy)
    if not u14 then
        return;
    end;

    local v49 = CollectionService:GetTagged("Bomb")[1];
    local v50;

    if v49 then
        v50 = v49:GetAttribute("Defused") or (v49:GetAttribute("Exploding") or v49:GetAttribute("Exploded"));
    else
        v50 = v49;
    end;

    local v51 = u9 or LocalPlayer:GetAttribute("IsDefusingBomb") == true;
    local v52 = v49 and not v50;

    if v52 then
        if not v51 then
            v51 = v49:GetAttribute("CanDefuse") and not v49:GetAttribute("IsGettingDefused");
        end;
    else
        v51 = v52;
    end;

    local v53 = #CollectionService:GetTagged("IsHoveringInteractable") > 0;
    local v54 = CenterScreenRaycast.GetHoveredHostage() ~= nil;
    local v55 = GetHoveredBreakableDoor() ~= nil;

    if v51 then
        u14.Interact.Defuse.Visible = true;
        u14.Interact.Use.Visible = false;
        u14.Interact.Visible = true;

        return;
    end;

    if v53 or (v54 or v55) then
        u14.Interact.Defuse.Visible = false;
        u14.Interact.Use.Visible = true;
        u14.Interact.Visible = true;

        return;
    end;

    u14.Interact.Defuse.Visible = false;
    u14.Interact.Use.Visible = false;
    u14.Interact.Visible = false;
end;

local function UpdateAimButton() -- Line: 380
    -- upvalues: InventoryController (copy), u14 (ref)
    local v56 = InventoryController.getCurrentEquipped();

    if v56 then
        u14.Aim.Visible = v56.Properties.HasScope == true or (v56.Properties.HasSuppressor == true or (v56.Properties.ShootingOptions == "Burst" or v56.Properties.ShootingOptions == "Revolver"));

        return;
    end;

    u14.Aim.Visible = false;
end;

local function UpdateDropButton() -- Line: 398
    -- upvalues: SpectateController (copy), u14 (ref), InventoryController (copy), GameState (copy)
    if SpectateController.IsLocalPlayerDead() then
        u14.Drop.Visible = false;

        return;
    end;

    local v57 = InventoryController.getCurrentEquipped();

    if not v57 then
        u14.Drop.Visible = false;

        return;
    end;

    local v58;

    if v57.Properties.Class == "Melee" then
        v58 = workspace:GetAttribute("VIPKnifeDropEnabled") == true;
    else
        v58 = false;
    end;

    if not (v57.Properties.Droppable or v58) then
        u14.Drop.Visible = false;

        return;
    end;

    if GameState.GetState() == "Warmup" then
        u14.Drop.Visible = false;

        return;
    end;

    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        u14.Drop.Visible = false;

        return;
    end;

    if v57.Properties.Class == "C4" and v57.IsPlanting then
        u14.Drop.Visible = false;

        return;
    end;

    u14.Drop.Visible = true;
end;

local function UpdateReloadButton() -- Line: 445
    -- upvalues: SpectateController (copy), u14 (ref), InventoryController (copy)
    if SpectateController.IsLocalPlayerDead() then
        u14.Reload.Visible = false;

        return;
    end;

    local v59 = InventoryController.getCurrentEquipped();

    if not v59 then
        u14.Reload.Visible = false;

        return;
    end;

    if v59.Properties.Class == "Weapon" then
        u14.Reload.Visible = true;

        return;
    end;

    u14.Reload.Visible = false;
end;

local function UpdatePingButton() -- Line: 471
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u14 (ref)
    if LocalPlayer:GetAttribute("IsSpectating") == true or SpectateController.IsLocalPlayerDead() then
        u14.Ping.Visible = false;

        return;
    end;

    u14.Ping.Visible = workspace:GetAttribute("Gamemode") ~= "Deathmatch";
end;

local function UpdateInspectButton() -- Line: 483
    -- upvalues: u14 (ref), SpectateController (copy), InventoryController (copy)
    if not u14:FindFirstChild("Inspect") then
        return;
    end;

    if SpectateController.IsLocalPlayerDead() then
        u14.Inspect.Visible = false;

        return;
    end;

    local v60 = InventoryController.getCurrentEquipped();
    u14.Inspect.Visible = v60 ~= nil;
end;

function u1.setupButton(u61) -- Line: 498
    -- upvalues: Profiler (copy), u12 (copy), BUTTONS_WITH_EXPLICIT_HANDLERS (copy), u11 (copy), TweenButtonToRestingScale (copy), BUTTONS_EXCLUDED_FROM_CLEARING (copy), BUTTONS_WITH_EXPLICIT_INPUT_ENDED (copy)
    Profiler.mark("UI.MobileButtons.SetupButton");
    u12[u61] = u61.Size;
    u61.InputBegan:Connect(function(p62) -- Line: 503
        -- upvalues: BUTTONS_WITH_EXPLICIT_HANDLERS (ref), u61 (copy), u11 (ref), TweenButtonToRestingScale (ref)
        if p62.UserInputType ~= Enum.UserInputType.Touch and p62.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p62.UserInputState == Enum.UserInputState.Begin then
            if not BUTTONS_WITH_EXPLICIT_HANDLERS[u61.Name] then
                local v63 = u61;

                if not u11[v63] and p62.UserInputState == Enum.UserInputState.Begin then
                    u11[v63] = p62;
                end;
            end;

            if u11[u61] == p62 then
                TweenButtonToRestingScale(u61, 0.9);
            end;
        end;
    end);

    if not BUTTONS_EXCLUDED_FROM_CLEARING[u61.Name] then
        u61.InputChanged:Connect(function(p64) -- Line: 526
            -- upvalues: u11 (ref), u61 (copy), TweenButtonToRestingScale (ref)
            if p64.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if u11[u61] == p64 then
                local v65 = u61;
                local Position = p64.Position;
                local AbsolutePosition = v65.AbsolutePosition;
                local AbsoluteSize = v65.AbsoluteSize;
                local v66;

                if Position.X >= AbsolutePosition.X and (Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y) then
                    v66 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                else
                    v66 = false;
                end;

                if not v66 then
                    local v67 = u61;

                    if u11[v67] == p64 then
                        u11[v67] = nil;
                    end;

                    TweenButtonToRestingScale(u61, 1);
                end;
            end;
        end);
    end;

    u61.InputEnded:Connect(function(p68) -- Line: 544
        -- upvalues: TweenButtonToRestingScale (ref), u61 (copy), BUTTONS_WITH_EXPLICIT_INPUT_ENDED (ref), u11 (ref)
        if p68.UserInputType ~= Enum.UserInputType.Touch and p68.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u61, 1);

        if not BUTTONS_WITH_EXPLICIT_INPUT_ENDED[u61.Name] then
            local v69 = u61;

            if u11[v69] == p68 then
                u11[v69] = nil;
            end;
        end;
    end);
end;

function u1.Initialize(p70, p71) -- Line: 563
    -- upvalues: Profiler (copy), u14 (ref), u8 (ref), u9 (ref), u12 (copy), u4 (copy), u11 (copy), CharacterController (copy), TweenButtonToRestingScale (copy), LocalPlayer (copy), Promise (copy), InventoryController (copy), Skins (copy), Rarities (copy), Router (copy), u5 (ref), SpectateController (copy), GameState (copy), CameraInput (copy), u6 (ref), CollectionService (copy), CenterScreenRaycast (copy), GetHoveredBreakableDoor (copy), Remotes (copy), BuyMenu (copy), u7 (ref), Leaderboard (copy), Top (copy), CaseSceneController (copy), InspectController (copy), HintController (copy), TeamSelection (copy), DataController (copy), GetPingRaycastResult (copy), GetWeaponDataFromInstance (copy), u10 (ref), u1 (copy), RunServiceController (copy), IsInBuyArea (copy), UpdateInteractButton (copy), UpdateDropButton (copy), UserInputService (copy)
    Profiler.mark("UI.MobileButtons.Initialize");
    u14 = p71;
    u8 = nil;
    u9 = false;

    for _, child in ipairs(u14:GetChildren()) do
        if child:IsA("TextButton") then
            u12[child] = child.Size;
        end;
    end;

    if not u4 then
        u14.Visible = false;

        return;
    end;

    local Top2 = u14.Parent.Parent:FindFirstChild("Top");
    local v72 = Top2 and Top2:FindFirstChild("Bomb Defusal");

    if v72 then
        v72.Size = UDim2.new(0.6, 0, 0.75, 0);
    end;

    u14.Jump.InputBegan:Connect(function(p73) -- Line: 589
        -- upvalues: u14 (ref), u11 (ref), CharacterController (ref)
        if p73.UserInputType ~= Enum.UserInputType.Touch and p73.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p73.UserInputState == Enum.UserInputState.Begin then
            local Jump = u14.Jump;

            if not u11[Jump] and p73.UserInputState == Enum.UserInputState.Begin then
                u11[Jump] = p73;
            end;
        end;

        local v74 = u11[u14.Jump];
        local v75;

        if v74 then
            v75 = (not p73 or p73 == v74) and true or false;
        else
            v75 = false;
        end;

        if v75 then
            CharacterController.jump();
        end;
    end);
    u14.Crouch.InputBegan:Connect(function(p76) -- Line: 608
        -- upvalues: u14 (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p76.UserInputType ~= Enum.UserInputType.Touch and p76.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p76.UserInputState == Enum.UserInputState.Begin then
            local Crouch = u14.Crouch;

            if not u11[Crouch] and p76.UserInputState == Enum.UserInputState.Begin then
                u11[Crouch] = p76;
            end;

            if u11[u14.Crouch] == p76 then
                TweenButtonToRestingScale(u14.Crouch, 0.9);
            end;
        end;
    end);
    u14.Crouch.InputEnded:Connect(function(p77) -- Line: 624
        -- upvalues: TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), CharacterController (ref)
        if p77.UserInputType ~= Enum.UserInputType.Touch and p77.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u14.Crouch, 1);
        local v78 = u11[u14.Crouch];
        local v79;

        if v78 then
            v79 = (not p77 or p77 == v78) and true or false;
        else
            v79 = false;
        end;

        if v79 then
            CharacterController.crouch(not CharacterController.GetCrouchState());
        end;

        local Crouch = u14.Crouch;

        if u11[Crouch] == p77 then
            u11[Crouch] = nil;
        end;
    end);
    u14.Walk.InputBegan:Connect(function(p80) -- Line: 643
        -- upvalues: u14 (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p80.UserInputType ~= Enum.UserInputType.Touch and p80.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p80.UserInputState == Enum.UserInputState.Begin then
            local Walk = u14.Walk;

            if not u11[Walk] and p80.UserInputState == Enum.UserInputState.Begin then
                u11[Walk] = p80;
            end;

            if u11[u14.Walk] == p80 then
                TweenButtonToRestingScale(u14.Walk, 0.9);
            end;
        end;
    end);
    u14.Walk.InputEnded:Connect(function(p81) -- Line: 658
        -- upvalues: TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), LocalPlayer (ref), CharacterController (ref)
        if p81.UserInputType ~= Enum.UserInputType.Touch and p81.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u14.Walk, 1);
        local v82 = u11[u14.Walk];
        local v83;

        if v82 then
            v83 = (not p81 or p81 == v82) and true or false;
        else
            v83 = false;
        end;

        if v83 and not LocalPlayer:GetAttribute("IsPlayerChatting") then
            CharacterController.walk(not CharacterController.GetWalkState());
        end;

        local Walk = u14.Walk;

        if u11[Walk] == p81 then
            u11[Walk] = nil;
        end;
    end);
    u14.Drop.InputEnded:Connect(function(p84) -- Line: 673
        -- upvalues: u14 (ref), u11 (ref), Promise (ref), InventoryController (ref), Skins (ref), Rarities (ref), Router (ref)
        if p84.UserInputType ~= Enum.UserInputType.Touch and p84.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        local v85 = u11[u14.Drop];
        local v86;

        if v85 then
            v86 = (not p84 or p84 == v85) and true or false;
        else
            v86 = false;
        end;

        if not v86 then
            local Drop = u14.Drop;

            if u11[Drop] == p84 then
                u11[Drop] = nil;
            end;

            return;
        end;

        local Drop = u14.Drop;

        if u11[Drop] == p84 then
            u11[Drop] = nil;
        end;

        Promise.new(function(p87, p88) -- Line: 312
            -- upvalues: InventoryController (ref)
            local v89 = InventoryController.getCurrentEquipped();

            if v89 then
                p87(v89);

                return;
            end;

            p88("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p90) -- Line: 688
            -- upvalues: Skins (ref), Rarities (ref), Router (ref)
            if p90 then
                local v91 = Skins.GetSkinInformation(p90.Name, p90.Skin);
                assert(v91, "Skin data not found for weapon: " .. p90.Name .. " and skin: " .. p90.Skin);
                local v92 = Rarities[v91.rarity];
                local v93 = math.floor(v92.Color.R * 255);
                local v94 = math.floor(v92.Color.G * 255);
                local v95 = math.floor(v92.Color.B * 255);

                if p90:drop() then
                    Router.broadcastRouter("CreateNotification", "Item Dropped", `You dropped your <font color = "rgb({v93}, {v94}, {v95})"><b>{p90.Name} | {p90.Skin}</b></font>`, 2);
                end;
            end;
        end);
    end);
    u14.Reload.InputBegan:Connect(function(p96) -- Line: 717
        -- upvalues: u14 (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p96.UserInputType ~= Enum.UserInputType.Touch and p96.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p96.UserInputState == Enum.UserInputState.Begin then
            local Reload = u14.Reload;

            if not u11[Reload] and p96.UserInputState == Enum.UserInputState.Begin then
                u11[Reload] = p96;
            end;

            if u11[u14.Reload] == p96 then
                TweenButtonToRestingScale(u14.Reload, 0.9);
            end;
        end;
    end);
    u14.Reload.InputEnded:Connect(function(p97) -- Line: 733
        -- upvalues: TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), Promise (ref), InventoryController (ref)
        if p97.UserInputType ~= Enum.UserInputType.Touch and p97.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u14.Reload, 1);
        local v98 = u11[u14.Reload];
        local v99;

        if v98 then
            v99 = (not p97 or p97 == v98) and true or false;
        else
            v99 = false;
        end;

        if not v99 then
            local Reload = u14.Reload;

            if u11[Reload] == p97 then
                u11[Reload] = nil;
            end;

            return;
        end;

        local Reload = u14.Reload;

        if u11[Reload] == p97 then
            u11[Reload] = nil;
        end;

        Promise.new(function(p100, p101) -- Line: 312
            -- upvalues: InventoryController (ref)
            local v102 = InventoryController.getCurrentEquipped();

            if v102 then
                p100(v102);

                return;
            end;

            p101("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p103) -- Line: 750
            if not p103 then
                return;
            end;

            p103:reload();
        end);
    end);
    u14.Shoot.Active = true;
    local u104 = false;

    local function ProcessEndShoot(p105, p106) -- Line: 763
        -- upvalues: u5 (ref), u104 (ref), TweenButtonToRestingScale (ref), u14 (ref), Promise (ref), InventoryController (ref)
        if p105 ~= u5 then
            return;
        end;

        if not p106 and p105.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u5 = nil;

        if not u104 then
            return;
        end;

        u104 = false;
        TweenButtonToRestingScale(u14.Shoot, 1);
        Promise.new(function(p107, p108) -- Line: 312
            -- upvalues: InventoryController (ref)
            local v109 = InventoryController.getCurrentEquipped();

            if v109 then
                p107(v109);

                return;
            end;

            p108("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p110) -- Line: 784
            if not p110 then
                return;
            end;

            if p110.Properties.Class ~= "Weapon" then
                if p110.Properties.Class == "Melee" then
                    p110.IsFireHeld = false;

                    return;
                end;

                if p110.Properties.Class == "C4" then
                    p110:cancel();

                    return;
                end;

                if p110.Properties.Slot ~= "Grenade" then
                    return;
                end;

                p110:Throw("Far");

                return;
            end;

            if p110.Properties.ShootingOptions ~= "Revolver" then
                p110.IsFireHeld = false;

                return;
            end;

            local v111 = p110.Properties.FireModes and p110.Properties.FireModes.Primary;

            if not v111 or v111.CancelOnRelease ~= false then
                p110:cancelRevolverCharge(false);

                return;
            end;

            p110.IsFireHeld = false;
            p110.FireInputBinding = nil;
        end);
    end;

    u14.Shoot.InputBegan:Connect(function(p112) -- Line: 824
        -- upvalues: u5 (ref), LocalPlayer (ref), SpectateController (ref), GameState (ref), Router (ref), u104 (ref), TweenButtonToRestingScale (ref), u14 (ref), Promise (ref), InventoryController (ref)
        if p112.UserInputType ~= Enum.UserInputType.Touch and p112.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if u5 then
            return;
        end;

        if p112.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u5 = p112;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if SpectateController.IsLocalPlayerDead() then
            return;
        end;

        if not LocalPlayer.Character then
            return;
        end;

        if GameState.GetState() == "Buy Period" then
            return;
        end;

        Router.broadcastRouter("Cancel Defuse Bomb");
        u104 = true;
        TweenButtonToRestingScale(u14.Shoot, 0.9);
        Promise.new(function(p113, p114) -- Line: 312
            -- upvalues: InventoryController (ref)
            local v115 = InventoryController.getCurrentEquipped();

            if v115 then
                p113(v115);

                return;
            end;

            p114("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p116) -- Line: 871
            if not p116 then
                return;
            end;

            if p116.Properties.Class == "Weapon" then
                if p116.Properties.ShootingOptions == "Revolver" then
                    p116:startRevolverCharge(nil);

                    return;
                end;

                p116.IsFireHeld = true;
                p116:shoot();

                return;
            end;

            if p116.Properties.Class == "Melee" then
                p116.IsFireHeld = true;
                p116:shoot();

                return;
            end;

            if p116.Properties.Class == "C4" then
                p116:shoot();

                return;
            end;

            if p116.Properties.Slot ~= "Grenade" then
                return;
            end;

            p116:StartThrow();
        end);
    end);
    u14.Shoot.InputEnded:Connect(ProcessEndShoot);
    u14.Shoot.InputChanged:Connect(function(p117) -- Line: 912
        -- upvalues: u5 (ref), CameraInput (ref)
        if p117 == u5 and p117.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p117.Delta.X, p117.Delta.Y));
        end;
    end);
    u14.Aim.Active = true;

    local function ProcessEndAim(p118, p119) -- Line: 921
        -- upvalues: u6 (ref), TweenButtonToRestingScale (ref), u14 (ref), Promise (ref), InventoryController (ref)
        if p118 ~= u6 then
            return;
        end;

        if not p119 and p118.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u6 = nil;
        TweenButtonToRestingScale(u14.Aim, 1);
        Promise.new(function(p120, p121) -- Line: 312
            -- upvalues: InventoryController (ref)
            local v122 = InventoryController.getCurrentEquipped();

            if v122 then
                p120(v122);

                return;
            end;

            p121("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p123) -- Line: 937
            if not p123 then
                return;
            end;

            if p123.Properties.ShootingOptions ~= "Revolver" then
                return;
            end;

            p123:stopRevolverSecondaryFire();
        end);
    end;

    u14.Aim.InputBegan:Connect(function(p124) -- Line: 949
        -- upvalues: u6 (ref), TweenButtonToRestingScale (ref), u14 (ref), Promise (ref), InventoryController (ref)
        if p124.UserInputType ~= Enum.UserInputType.Touch and p124.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if u6 then
            return;
        end;

        if p124.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u6 = p124;
        TweenButtonToRestingScale(u14.Aim, 0.9);
        Promise.new(function(p125, p126) -- Line: 312
            -- upvalues: InventoryController (ref)
            local v127 = InventoryController.getCurrentEquipped();

            if v127 then
                p125(v127);

                return;
            end;

            p126("Failed to fetch current equipped");
        end):catch(warn):andThen(function(p128) -- Line: 972
            if not p128 then
                return;
            end;

            if p128.Properties.HasScope then
                p128:scope(true);

                return;
            end;

            if p128.Properties.ShootingOptions == "Revolver" then
                p128:startRevolverSecondaryFire(nil);

                return;
            end;

            if p128.Properties.HasSuppressor then
                if p128.IsSuppressed then
                    p128:removeSuppressor();

                    return;
                end;

                p128:addSuppressor();

                return;
            end;

            if p128.Properties.ShootingOptions ~= "Burst" then
                return;
            end;

            p128:updateFireMode();
        end);
    end);
    u14.Aim.InputEnded:Connect(ProcessEndAim);
    u14.Aim.InputChanged:Connect(function(p129) -- Line: 1001
        -- upvalues: u6 (ref), CameraInput (ref)
        if p129 == u6 and p129.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p129.Delta.X, p129.Delta.Y));
        end;
    end);
    u14.Interact.Active = true;
    u14.Interact.InputBegan:Connect(function(p130) -- Line: 1010
        -- upvalues: u8 (ref), u14 (ref), u11 (ref), CollectionService (ref), u9 (ref), Router (ref), CenterScreenRaycast (ref), LocalPlayer (ref), GetHoveredBreakableDoor (ref), Remotes (ref), Skins (ref), Rarities (ref)
        if p130.UserInputType ~= Enum.UserInputType.Touch and p130.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if u8 then
            return;
        end;

        if p130.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u8 = p130;
        local Interact = u14.Interact;

        if not u11[Interact] and p130.UserInputState == Enum.UserInputState.Begin then
            u11[Interact] = p130;
        end;

        local v131 = CollectionService:GetTagged("Bomb")[1];

        if v131 and (v131:GetAttribute("CanDefuse") and not (v131:GetAttribute("IsGettingDefused") or v131:GetAttribute("Defused"))) then
            u9 = true;
            Router.broadcastRouter("Start Defuse Bomb");

            return;
        end;

        local v132 = CenterScreenRaycast.GetHoveredHostage();

        if v132 then
            local v133 = LocalPlayer:GetAttribute("Team");

            if not LocalPlayer:GetAttribute("IsCarryingHostage") and (not LocalPlayer:GetAttribute("IsRescuingHostage") and v133 == "Counter-Terrorists") then
                local v134 = v132:GetAttribute("RescuingPlayer");
                local v135 = v132:GetAttribute("CarryingPlayer");

                if (not v134 or v134 == LocalPlayer.Name) and not v135 then
                    Router.broadcastRouter("Start Rescue Hostage");

                    return;
                end;
            end;
        end;

        local v136 = GetHoveredBreakableDoor();

        if #v136 > 0 then
            for _, v in v136 do
                Remotes.BreakableDoor.Use.Send(v);
            end;

            return;
        end;

        local v137 = CollectionService:GetTagged("IsHoveringInteractable");

        if #v137 == 0 then
            return;
        end;

        local v138 = v137[1];
        local v139 = v138:GetAttribute("Weapon");
        local v140 = v138:GetAttribute("Skin");

        if v139 == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
            return;
        end;

        if v138:GetAttribute("CanPickup") then
            local v141 = Skins.GetSkinInformation(v139, v140);

            if v141 then
                local v142 = Rarities[v141.rarity];
                local v143 = math.floor(v142.Color.R * 255);
                local v144 = math.floor(v142.Color.G * 255);
                local v145 = math.floor(v142.Color.B * 255);
                Router.broadcastRouter("CreateNotification", "Item Picked Up", `You picked up a <font color = "rgb({v143}, {v144}, {v145})"><b>{v139:find("Zeus") and "Taser" or v139} | {v140}</b></font>`, 2);
            end;

            Remotes.Inventory.PickupWeapon.Send({
                AllowAutoEquip = true,
                Identity = v138.Name
            });
        end;
    end);

    local function ProcessEndInteract(p146) -- Line: 1116
        -- upvalues: u8 (ref), u9 (ref), LocalPlayer (ref), u14 (ref), u11 (ref), CollectionService (ref), Router (ref)
        if p146 ~= u8 then
            return;
        end;

        local v147 = u9 or LocalPlayer:GetAttribute("IsDefusingBomb") == true;
        u8 = nil;
        u9 = false;
        local Interact = u14.Interact;

        if u11[Interact] == p146 then
            u11[Interact] = nil;
        end;

        if CollectionService:GetTagged("Bomb")[1] and v147 then
            Router.broadcastRouter("Cancel Defuse Bomb");

            return;
        end;

        if not LocalPlayer:GetAttribute("IsRescuingHostage") then
            return;
        end;

        Router.broadcastRouter("Cancel Rescue Hostage");
    end;

    u14.Interact.InputEnded:Connect(ProcessEndInteract);
    u14.Interact.InputChanged:Connect(function(p148) -- Line: 1143
        -- upvalues: u8 (ref), CameraInput (ref)
        if p148 == u8 and p148.UserInputType == Enum.UserInputType.Touch then
            CameraInput.addTouchMove(Vector2.new(p148.Delta.X, p148.Delta.Y));
        end;
    end);
    u14.Shop.InputBegan:Connect(function(p149) -- Line: 1150
        -- upvalues: u14 (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p149.UserInputType ~= Enum.UserInputType.Touch and p149.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p149.UserInputState == Enum.UserInputState.Begin then
            local Shop = u14.Shop;

            if not u11[Shop] and p149.UserInputState == Enum.UserInputState.Begin then
                u11[Shop] = p149;
            end;

            if u11[u14.Shop] == p149 then
                TweenButtonToRestingScale(u14.Shop, 0.9);
            end;
        end;
    end);
    u14.Shop.InputEnded:Connect(function(p150) -- Line: 1166
        -- upvalues: TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), BuyMenu (ref)
        if p150.UserInputType ~= Enum.UserInputType.Touch and p150.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u14.Shop, 1);
        local v151 = u11[u14.Shop];
        local v152;

        if v151 then
            v152 = (not p150 or p150 == v151) and true or false;
        else
            v152 = false;
        end;

        if not v152 then
            local Shop = u14.Shop;

            if u11[Shop] == p150 then
                u11[Shop] = nil;
            end;

            return;
        end;

        local Shop = u14.Shop;

        if u11[Shop] == p150 then
            u11[Shop] = nil;
        end;

        BuyMenu.toggleFrame();
    end);

    local function ProcessEndScoreboard(p153, p154) -- Line: 1183
        -- upvalues: u7 (ref), TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), Leaderboard (ref)
        if p153 ~= u7 then
            return;
        end;

        if not p154 and p153.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        u7 = nil;
        TweenButtonToRestingScale(u14.Scoreboard, 1);
        local Scoreboard = u14.Scoreboard;

        if u11[Scoreboard] == p153 then
            u11[Scoreboard] = nil;
        end;

        Leaderboard.closeFrame();
    end;

    u14.Scoreboard.InputBegan:Connect(function(p155) -- Line: 1199
        -- upvalues: u7 (ref), LocalPlayer (ref), u14 (ref), u11 (ref), TweenButtonToRestingScale (ref), Leaderboard (ref)
        if p155.UserInputType ~= Enum.UserInputType.Touch and p155.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if u7 or LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p155.UserInputState ~= Enum.UserInputState.Begin then
            return;
        end;

        u7 = p155;
        local Scoreboard = u14.Scoreboard;

        if not u11[Scoreboard] and p155.UserInputState == Enum.UserInputState.Begin then
            u11[Scoreboard] = p155;
        end;

        TweenButtonToRestingScale(u14.Scoreboard, 0.9);
        Leaderboard.openFrame();
    end);
    u14.Scoreboard.InputEnded:Connect(ProcessEndScoreboard);
    u14.Menu.InputBegan:Connect(function(p156) -- Line: 1222
        -- upvalues: u14 (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p156.UserInputType ~= Enum.UserInputType.Touch and p156.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p156.UserInputState == Enum.UserInputState.Begin then
            local Menu = u14.Menu;

            if not u11[Menu] and p156.UserInputState == Enum.UserInputState.Begin then
                u11[Menu] = p156;
            end;

            if u11[u14.Menu] == p156 then
                TweenButtonToRestingScale(u14.Menu, 0.9);
            end;
        end;
    end);
    u14.Menu.InputEnded:Connect(function(p157) -- Line: 1239
        -- upvalues: TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), Top (ref)
        if p157.UserInputType ~= Enum.UserInputType.Touch and p157.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u14.Menu, 1);
        local v158 = u11[u14.Menu];
        local v159;

        if v158 then
            v159 = (not p157 or p157 == v158) and true or false;
        else
            v159 = false;
        end;

        if not v159 then
            local Menu = u14.Menu;

            if u11[Menu] == p157 then
                u11[Menu] = nil;
            end;

            return;
        end;

        local Menu = u14.Menu;

        if u11[Menu] == p157 then
            u11[Menu] = nil;
        end;

        Top.ToggleMenu();
    end);
    u14.Inspect.InputBegan:Connect(function(p160) -- Line: 1257
        -- upvalues: u14 (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p160.UserInputType ~= Enum.UserInputType.Touch and p160.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p160.UserInputState == Enum.UserInputState.Begin then
            local Inspect = u14.Inspect;

            if not u11[Inspect] and p160.UserInputState == Enum.UserInputState.Begin then
                u11[Inspect] = p160;
            end;

            if u11[u14.Inspect] == p160 then
                TweenButtonToRestingScale(u14.Inspect, 0.9);
            end;
        end;
    end);
    u14.Inspect.InputEnded:Connect(function(p161) -- Line: 1273
        -- upvalues: TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), LocalPlayer (ref), CaseSceneController (ref), InspectController (ref), InventoryController (ref), HintController (ref)
        if p161.UserInputType ~= Enum.UserInputType.Touch and p161.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u14.Inspect, 1);
        local v162 = u11[u14.Inspect];
        local v163;

        if v162 then
            v163 = (not p161 or p161 == v162) and true or false;
        else
            v163 = false;
        end;

        if not v163 then
            local Inspect = u14.Inspect;

            if u11[Inspect] == p161 then
                u11[Inspect] = nil;
            end;

            return;
        end;

        local Inspect = u14.Inspect;

        if u11[Inspect] == p161 then
            u11[Inspect] = nil;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if CaseSceneController.IsActive() or InspectController.IsActive() then
            return;
        end;

        local v164 = InventoryController.getCurrentEquipped();

        if v164 then
            v164:inspect();
            HintController:clearHint("Inspect");
        end;
    end);
    u14.SwapTeam.InputBegan:Connect(function(p165) -- Line: 1305
        -- upvalues: u14 (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p165.UserInputType ~= Enum.UserInputType.Touch and p165.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p165.UserInputState == Enum.UserInputState.Begin then
            local SwapTeam = u14.SwapTeam;

            if not u11[SwapTeam] and p165.UserInputState == Enum.UserInputState.Begin then
                u11[SwapTeam] = p165;
            end;

            if u11[u14.SwapTeam] == p165 then
                TweenButtonToRestingScale(u14.SwapTeam, 0.9);
            end;
        end;
    end);
    u14.SwapTeam.InputEnded:Connect(function(p166) -- Line: 1322
        -- upvalues: TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), LocalPlayer (ref), TeamSelection (ref)
        if p166.UserInputType ~= Enum.UserInputType.Touch and p166.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u14.SwapTeam, 1);
        local v167 = u11[u14.SwapTeam];
        local v168;

        if v167 then
            v168 = (not p166 or p166 == v167) and true or false;
        else
            v168 = false;
        end;

        if not v168 then
            local SwapTeam = u14.SwapTeam;

            if u11[SwapTeam] == p166 then
                u11[SwapTeam] = nil;
            end;

            return;
        end;

        local SwapTeam = u14.SwapTeam;

        if u11[SwapTeam] == p166 then
            u11[SwapTeam] = nil;
        end;

        if LocalPlayer:GetAttribute("IsSpectating") then
            TeamSelection.openFrame();

            return;
        end;

        if not LocalPlayer.Character then
            return;
        end;

        TeamSelection.ToggleTeamSelection();
    end);
    u14.Ping.InputBegan:Connect(function(p169) -- Line: 1349
        -- upvalues: u14 (ref), u11 (ref), TweenButtonToRestingScale (ref)
        if p169.UserInputType ~= Enum.UserInputType.Touch and p169.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        if p169.UserInputState == Enum.UserInputState.Begin then
            local Ping = u14.Ping;

            if not u11[Ping] and p169.UserInputState == Enum.UserInputState.Begin then
                u11[Ping] = p169;
            end;

            if u11[u14.Ping] == p169 then
                TweenButtonToRestingScale(u14.Ping, 0.9);
            end;
        end;
    end);
    u14.Ping.InputEnded:Connect(function(p170) -- Line: 1368
        -- upvalues: TweenButtonToRestingScale (ref), u14 (ref), u11 (ref), DataController (ref), LocalPlayer (ref), GetPingRaycastResult (ref), GetWeaponDataFromInstance (ref), Remotes (ref), u10 (ref)
        if p170.UserInputType ~= Enum.UserInputType.Touch and p170.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return;
        end;

        TweenButtonToRestingScale(u14.Ping, 1);
        local v171 = u11[u14.Ping];
        local v172;

        if v171 then
            v172 = (not p170 or p170 == v171) and true or false;
        else
            v172 = false;
        end;

        if not v172 then
            local Ping = u14.Ping;

            if u11[Ping] == p170 then
                u11[Ping] = nil;
            end;

            return;
        end;

        local Ping = u14.Ping;

        if u11[Ping] == p170 then
            u11[Ping] = nil;
        end;

        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            return;
        end;

        if DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v173;

        if Character and Character:IsDescendantOf(workspace) then
            local v174 = Character:FindFirstChildOfClass("Humanoid");
            v173 = v174 and v174.Health > 0 and true or false;
        else
            v173 = false;
        end;

        if not v173 then
            return;
        end;

        local v175 = GetPingRaycastResult(LocalPlayer.Character);

        if not v175 then
            return;
        end;

        local v176, v177, v178 = GetWeaponDataFromInstance(v175.Instance);
        local v179;

        if v176 then
            if v177 then
                v179 = v178;
            else
                v179 = v177;
            end;
        else
            v179 = v176;
        end;

        if v179 then
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = false,
                Position = v175.Position,
                WeaponIdentity = v178,
                WeaponName = v176,
                WeaponSkin = v177
            });
        else
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = tick() - u10 < 0.5,
                Position = v175.Position
            });
        end;

        u10 = tick();
    end);

    for _, child in ipairs(u14:GetChildren()) do
        if child:IsA("TextButton") and (child.Name ~= "Shoot" and child.Name ~= "Aim") then
            u1.setupButton(child);
        end;
    end;

    RunServiceController.BindToHeartbeat("UI.MobileButtons.UpdateVisibility", function() -- Line: 1433
        -- upvalues: Profiler (ref), LocalPlayer (ref), u14 (ref), IsInBuyArea (ref), UpdateInteractButton (ref), SpectateController (ref), InventoryController (ref), UpdateDropButton (ref)
        Profiler.mark("UI.MobileButtons.Heartbeat");
        local _ = LocalPlayer:GetAttribute("IsSpectating") == true;
        local Shop = u14.Shop;
        local v180 = LocalPlayer:GetAttribute("BuyMenu") and IsInBuyArea(LocalPlayer);
        Shop.Visible = v180;
        UpdateInteractButton();

        if u14:FindFirstChild("Inspect") then
            if SpectateController.IsLocalPlayerDead() then
                u14.Inspect.Visible = false;
            else
                local v181 = InventoryController.getCurrentEquipped();
                u14.Inspect.Visible = v181 ~= nil;
            end;
        end;

        if SpectateController.IsLocalPlayerDead() then
            u14.Reload.Visible = false;
        else
            local v182 = InventoryController.getCurrentEquipped();

            if v182 then
                if v182.Properties.Class == "Weapon" then
                    u14.Reload.Visible = true;
                else
                    u14.Reload.Visible = false;
                end;
            else
                u14.Reload.Visible = false;
            end;
        end;

        UpdateDropButton();

        if LocalPlayer:GetAttribute("IsSpectating") == true or SpectateController.IsLocalPlayerDead() then
            u14.Ping.Visible = false;
        else
            u14.Ping.Visible = workspace:GetAttribute("Gamemode") ~= "Deathmatch";
        end;

        local v183 = InventoryController.getCurrentEquipped();

        if v183 then
            u14.Aim.Visible = v183.Properties.HasScope == true or (v183.Properties.HasSuppressor == true or (v183.Properties.ShootingOptions == "Burst" or v183.Properties.ShootingOptions == "Revolver"));

            return;
        end;

        u14.Aim.Visible = false;
    end);
    UserInputService.InputChanged:Connect(function(p184) -- Line: 1448
        -- upvalues: u5 (ref), u6 (ref), u8 (ref), CameraInput (ref)
        if p184 ~= u5 and (p184 ~= u6 and p184 ~= u8) then
            return;
        end;

        CameraInput.addTouchMove(Vector2.new(p184.Delta.X, p184.Delta.Y));
    end);
    UserInputService.InputEnded:Connect(function(p185) -- Line: 1456
        -- upvalues: u5 (ref), u104 (ref), TweenButtonToRestingScale (ref), u14 (ref), Promise (ref), InventoryController (ref), u6 (ref), u7 (ref), u11 (ref), Leaderboard (ref), ProcessEndInteract (copy)
        if p185.UserInputType == Enum.UserInputType.Touch or p185.UserInputType == Enum.UserInputType.MouseButton1 then
            if p185 == u5 then
                u5 = nil;

                if u104 then
                    u104 = false;
                    TweenButtonToRestingScale(u14.Shoot, 1);
                    Promise.new(function(p186, p187) -- Line: 312
                        -- upvalues: InventoryController (ref)
                        local v188 = InventoryController.getCurrentEquipped();

                        if v188 then
                            p186(v188);

                            return;
                        end;

                        p187("Failed to fetch current equipped");
                    end):catch(warn):andThen(function(p189) -- Line: 784
                        if not p189 then
                            return;
                        end;

                        if p189.Properties.Class ~= "Weapon" then
                            if p189.Properties.Class == "Melee" then
                                p189.IsFireHeld = false;

                                return;
                            end;

                            if p189.Properties.Class == "C4" then
                                p189:cancel();

                                return;
                            end;

                            if p189.Properties.Slot ~= "Grenade" then
                                return;
                            end;

                            p189:Throw("Far");

                            return;
                        end;

                        if p189.Properties.ShootingOptions ~= "Revolver" then
                            p189.IsFireHeld = false;

                            return;
                        end;

                        local v190 = p189.Properties.FireModes and p189.Properties.FireModes.Primary;

                        if not v190 or v190.CancelOnRelease ~= false then
                            p189:cancelRevolverCharge(false);

                            return;
                        end;

                        p189.IsFireHeld = false;
                        p189.FireInputBinding = nil;
                    end);
                end;
            end;

            if p185 == u6 then
                u6 = nil;
                TweenButtonToRestingScale(u14.Aim, 1);
                Promise.new(function(p191, p192) -- Line: 312
                    -- upvalues: InventoryController (ref)
                    local v193 = InventoryController.getCurrentEquipped();

                    if v193 then
                        p191(v193);

                        return;
                    end;

                    p192("Failed to fetch current equipped");
                end):catch(warn):andThen(function(p194) -- Line: 937
                    if not p194 then
                        return;
                    end;

                    if p194.Properties.ShootingOptions ~= "Revolver" then
                        return;
                    end;

                    p194:stopRevolverSecondaryFire();
                end);
            end;

            if p185 == u7 then
                u7 = nil;
                TweenButtonToRestingScale(u14.Scoreboard, 1);
                local Scoreboard = u14.Scoreboard;

                if u11[Scoreboard] == p185 then
                    u11[Scoreboard] = nil;
                end;

                Leaderboard.closeFrame();
            end;

            ProcessEndInteract(p185);

            for i, v in pairs(u11) do
                if v == p185 then
                    u11[i] = nil;
                end;
            end;
        end;
    end);
end;

function u1.Start() -- Line: 1482
    -- upvalues: Profiler (copy), u14 (ref), u4 (copy), LocalPlayer (copy), GAMEPLAY_MOBILE_BUTTONS (copy), SPECTATE_MOBILE_BUTTONS (copy), u6 (ref), u7 (ref), Leaderboard (copy), DataController (copy), u12 (copy)
    debug.setmemorycategory("UI.MobileButtons.Start");
    Profiler.mark("UI.MobileButtons.Start");
    u14.Visible = false;

    if u4 then
        if LocalPlayer:GetAttribute("IsSpectating") == true then
            if u14 then
                for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
                    local v195 = u14:FindFirstChild(v);

                    if v195 then
                        v195.Visible = table.find(SPECTATE_MOBILE_BUTTONS, v) ~= nil;
                    end;
                end;
            end;

            u14.Visible = true;
        elseif LocalPlayer.Character then
            if u14 then
                for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
                    local v196 = u14:FindFirstChild(v);

                    if v196 then
                        v196.Visible = true;
                    end;
                end;
            end;

            u14.Visible = true;
        end;
    end;

    LocalPlayer.CharacterAdded:Connect(function() -- Line: 1501
        -- upvalues: u14 (ref), u4 (ref), GAMEPLAY_MOBILE_BUTTONS (ref)
        u14.Visible = u4;

        if not u14 then
            return;
        end;

        for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
            local v197 = u14:FindFirstChild(v);

            if v197 then
                v197.Visible = true;
            end;
        end;
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 1508
        -- upvalues: LocalPlayer (ref), u6 (ref), u7 (ref), Leaderboard (ref), u4 (ref), u14 (ref), GAMEPLAY_MOBILE_BUTTONS (ref), SPECTATE_MOBILE_BUTTONS (ref)
        local v198 = LocalPlayer:GetAttribute("IsSpectating") == true;
        u6 = nil;
        u7 = nil;
        Leaderboard.closeFrame();

        if not (v198 and u4) then
            u14.Visible = false;

            return;
        end;

        if u14 then
            for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
                local v199 = u14:FindFirstChild(v);

                if v199 then
                    v199.Visible = table.find(SPECTATE_MOBILE_BUTTONS, v) ~= nil;
                end;
            end;
        end;

        u14.Visible = true;
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 1526
        -- upvalues: LocalPlayer (ref), u4 (ref), u14 (ref), GAMEPLAY_MOBILE_BUTTONS (ref), SPECTATE_MOBILE_BUTTONS (ref)
        local v200 = LocalPlayer:GetAttribute("IsSpectating") == true;

        if not u4 then
            if v200 then
                return;
            end;

            u14.Visible = false;

            return;
        end;

        if v200 then
            if u14 then
                for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
                    local v201 = u14:FindFirstChild(v);

                    if v201 then
                        v201.Visible = table.find(SPECTATE_MOBILE_BUTTONS, v) ~= nil;
                    end;
                end;
            end;

            u14.Visible = true;

            return;
        end;

        if not LocalPlayer.Character then
            u14.Visible = false;

            return;
        end;

        if u14 then
            for _, v in ipairs(GAMEPLAY_MOBILE_BUTTONS) do
                local v202 = u14:FindFirstChild(v);

                if v202 then
                    v202.Visible = true;
                end;
            end;
        end;

        u14.Visible = true;
    end);
    DataController.CreateListener(LocalPlayer, "MobileButtons", function(p203) -- Line: 1555
        -- upvalues: u14 (ref), u12 (ref)
        if typeof(p203) ~= "table" then
            return;
        end;

        for i, v in pairs(p203) do
            local v204 = u14:FindFirstChild(i);

            if v204 then
                v204.Position = UDim2.fromScale(v.Position.X, v.Position.Y);
                v204.Size = UDim2.fromScale(v.Size.X, v.Size.Y);
                u12[v204] = v204.Size;
            end;
        end;
    end);
end;

return u1;