-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Viewmodel = require(ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v2 = GetUserPlatform();
local u3 = table.find(v2, "Mobile") and #v2 <= 1;
local CurrentCamera = workspace.CurrentCamera;
local u4 = nil;
local Lighting2 = ReplicatedStorage.Assets.Lighting;
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = false;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = {};
local u18 = Janitor.new();
local u19 = "Weapon";
local u20 = false;
local DEFAULT_CAMERA_FOV = Constants.DEFAULT_CAMERA_FOV;
local u21 = false;
local zero = Vector2.zero;
local u22 = 40;
local u23 = 40;
local u24 = 0;
local u25 = 0;
local u26 = 0;
local u27 = 0;
local u28 = {
    WEAPON_NAME_NO_COLLECTION_POSITION = UDim2.fromScale(0.5, 0.075),
    WEAPON_NAME_NO_COLLECTION_SIZE = UDim2.fromScale(0.317, 0.054),
    WEAPON_NAME_COLLECTION_POSITION = UDim2.fromScale(0.5, 0.075),
    WEAPON_NAME_COLLECTION_SIZE = UDim2.fromScale(0.243, 0.054),
    RARITY_FRAME_NO_COLLECTION_POSITION = UDim2.fromScale(0.5, 0.143),
    RARITY_FRAME_COLLECTION_POSITION = UDim2.fromScale(0.5, 0.143)
};
local u29 = {};
local u30 = nil;
local u31 = nil;
local u32 = 1;

local function commaNumber(p33) -- Line: 142
    return tostring(p33):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function applyGlobalShadowsSetting() -- Line: 148
    -- upvalues: DataController (copy), LocalPlayer (copy), Lighting (copy), u11 (ref)
    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u11 ~= nil then
            Lighting.GlobalShadows = u11;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end;

local function applyMapLighting() -- Line: 162
    -- upvalues: Maps (copy), u11 (ref), Lighting (copy), DataController (copy), LocalPlayer (copy)
    local Map = workspace:FindFirstChild("Map");

    if not Map then
        return;
    end;

    local v34 = Map:GetAttribute("MapName");

    if not v34 or typeof(v34) ~= "string" then
        return;
    end;

    local v35 = Maps:FindFirstChild(v34);

    if not (v35 and v35:IsA("ModuleScript")) then
        return;
    end;

    local v36 = require(v35);

    if not v36.Lighting then
        return;
    end;

    local Properties = v36.Lighting.Properties;

    if Properties then
        u11 = Properties.GlobalShadows;
        Lighting.Ambient = Properties.Ambient;
        Lighting.Brightness = Properties.Brightness;
        Lighting.ColorShift_Bottom = Properties.ColorShift_Bottom;
        Lighting.ColorShift_Top = Properties.ColorShift_Top;
        Lighting.EnvironmentDiffuseScale = Properties.EnvironmentDiffuseScale;
        Lighting.EnvironmentSpecularScale = Properties.EnvironmentSpecularScale;
        Lighting.GlobalShadows = Properties.GlobalShadows;
        Lighting.OutdoorAmbient = Properties.OutdoorAmbient;
        Lighting.ShadowSoftness = Properties.ShadowSoftness;
        Lighting.ClockTime = Properties.ClockTime;
        Lighting.GeographicLatitude = Properties.GeographicLatitude;
        Lighting.ExposureCompensation = Properties.ExposureCompensation;
    end;

    for _, child in ipairs(Lighting:GetChildren()) do
        if child.Name ~= "Menu" then
            child:Destroy();
        end;
    end;

    local Assets = v36.Lighting.Assets;

    if Assets then
        for _, child in ipairs(Assets:GetChildren()) do
            child:Clone().Parent = Lighting;
        end;
    end;

    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u11 ~= nil then
            Lighting.GlobalShadows = u11;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end;

local function applySceneLighting(p37) -- Line: 227
    -- upvalues: Lighting2 (copy), Maps (copy), u11 (ref), Lighting (copy), DataController (copy), LocalPlayer (copy)
    local v38 = Lighting2:FindFirstChild(p37) or Lighting2:FindFirstChild("Menu");

    if not v38 then
        return;
    end;

    local v39 = Maps:FindFirstChild(p37);

    if v39 and v39:IsA("ModuleScript") then
        local v40 = require(v39);

        if v40.Lighting and v40.Lighting.Properties then
            local Properties = v40.Lighting.Properties;
            u11 = Properties.GlobalShadows;
            Lighting.Ambient = Properties.Ambient;
            Lighting.Brightness = Properties.Brightness;
            Lighting.ColorShift_Bottom = Properties.ColorShift_Bottom;
            Lighting.ColorShift_Top = Properties.ColorShift_Top;
            Lighting.EnvironmentDiffuseScale = Properties.EnvironmentDiffuseScale;
            Lighting.EnvironmentSpecularScale = Properties.EnvironmentSpecularScale;
            Lighting.GlobalShadows = Properties.GlobalShadows;
            Lighting.OutdoorAmbient = Properties.OutdoorAmbient;
            Lighting.ShadowSoftness = Properties.ShadowSoftness;
            Lighting.ClockTime = Properties.ClockTime;
            Lighting.GeographicLatitude = Properties.GeographicLatitude;
            Lighting.ExposureCompensation = Properties.ExposureCompensation;
        end;
    end;

    for _, child in ipairs(Lighting:GetChildren()) do
        if child.Name ~= "Menu" then
            child:Destroy();
        end;
    end;

    for _, child in ipairs(v38:GetChildren()) do
        child:Clone().Parent = Lighting;
    end;

    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u11 ~= nil then
            Lighting.GlobalShadows = u11;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end;

local function getInspectScenesFolder() -- Line: 281
    -- upvalues: u4 (ref), ReplicatedStorage (copy)
    if u4 then
        return u4;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        u4 = Assets:WaitForChild("InspectScenes", 10);
    end;

    return u4;
end;

local function getRandomInspectScene() -- Line: 295
    -- upvalues: u4 (ref), ReplicatedStorage (copy)
    local v41;

    if u4 then
        v41 = u4;
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            u4 = Assets:WaitForChild("InspectScenes", 10);
        end;

        v41 = u4;
    end;

    if not v41 then
        return nil;
    end;

    local v42 = {};

    for _, child in ipairs(v41:GetChildren()) do
        if child:IsA("Model") then
            table.insert(v42, child);
        end;
    end;

    if #v42 > 0 then
        return v42[math.random(1, #v42)];
    end;

    return nil;
end;

local function activateInspectSceneFlags(p43) -- Line: 316
    for _, descendant in ipairs(p43:GetDescendants()) do
        if descendant:IsA("Model") then
            local csFlag = descendant:FindFirstChild("csFlag");

            if csFlag and (csFlag:IsA("Model") and not descendant:HasTag("Flag")) then
                descendant:AddTag("Flag");
            end;
        end;
    end;
end;

local function updateWeaponTransform() -- Line: 335
    -- upvalues: u14 (ref), u16 (ref), u25 (ref), u24 (ref), u8 (ref)
    if not (u14 and u16) then
        return;
    end;

    local WeaponPart = u16:FindFirstChild("WeaponPart");

    if not WeaponPart then
        return;
    end;

    local v44 = CFrame.Angles(0, -1.5707963267948966, 0);
    local v45 = CFrame.Angles(0, math.rad(u25), (math.rad(u24)));

    if not u8 then
        u14:PivotTo(WeaponPart.CFrame * v45 * v44);

        return;
    end;

    local v46 = u14:GetPivot():ToObjectSpace(u8.WorldCFrame);
    u14:PivotTo(WeaponPart.CFrame * v45 * v44 * v46:Inverse());
end;

local function handleDragInput(p47) -- Line: 371
    -- upvalues: u27 (ref), u26 (ref)
    u27 = u27 + p47.X * 0.5;
    u26 = u26 + p47.Y * 0.5;
    u26 = math.clamp(u26, -80, 80);
end;

local function handleFOVInput(p48) -- Line: 382
    -- upvalues: u19 (ref), u23 (ref)
    if u19 == "Viewmodel" then
        return;
    end;

    u23 = math.clamp(u23 - p48 * 2, 20, 70);
end;

local function getTouchCount() -- Line: 394
    -- upvalues: u29 (ref)
    local v49 = 0;

    for _ in pairs(u29) do
        v49 = v49 + 1;
    end;

    return v49;
end;

local function getPinchDistance() -- Line: 404
    -- upvalues: u29 (ref)
    local v50 = {};

    for _, v in pairs(u29) do
        table.insert(v50, v);
    end;

    if #v50 >= 2 then
        return (v50[1] - v50[2]).Magnitude;
    end;

    return nil;
end;

local function hideMenuFrames() -- Line: 417
    -- upvalues: MenuState (copy), u13 (ref), MenuSceneController (copy)
    MenuState.EnterInspect();
    local v51 = MenuState.GetMenuFrame();

    if not v51 then
        return;
    end;

    u13 = MenuSceneController.IsActive();

    if u13 then
        MenuSceneController.HideMenuScene(true);
        MenuSceneController.SetMusicVolumeMultiplier(0.5, 0.5);
    end;

    MenuState.SetBlurEnabled(false);
    v51.BackgroundTransparency = 1;
    local Pattern = v51:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = false;
    end;

    local Top = v51:FindFirstChild("Top");

    if Top then
        Top.Visible = false;
    end;

    for _, child in ipairs(v51:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Top" then
            if child.Name == "Inspect" or child.Name == "InspectFrame" then
                child.Visible = true;
            else
                child.Visible = false;
            end;
        end;
    end;
end;

local function initializeInspectButtons() -- Line: 468
    -- upvalues: MenuState (copy), ActivateButton (copy), CloseButtonRegistry (copy), u1 (copy), DataController (copy), LocalPlayer (copy), Router (copy)
    local v52 = MenuState.GetMenuFrame();

    if not v52 then
        return;
    end;

    local v53 = v52:FindFirstChild("Inspect") or v52:FindFirstChild("InspectFrame");

    if not v53 then
        return;
    end;

    local Bottom = v53:FindFirstChild("Bottom");

    if not Bottom then
        return;
    end;

    local Close = Bottom.Container.Buttons:FindFirstChild("Close");

    if Close and Close:IsA("GuiButton") then
        ActivateButton(Close);
        CloseButtonRegistry.Add(v53, Close, function() -- Line: 488
            -- upvalues: u1 (ref)
            u1.HideInspect();
        end);
    end;

    local MobileButtons = v53:FindFirstChild("MobileButtons");

    if MobileButtons then
        local Inspect = MobileButtons:FindFirstChild("Inspect");

        if Inspect and Inspect:IsA("TextButton") then
            ActivateButton(Inspect);
            Inspect.MouseButton1Click:Connect(function() -- Line: 501
                -- upvalues: u1 (ref)
                u1.PlayInspectAnimation();
            end);
            local v54 = DataController.Get(LocalPlayer, "MobileButtons");

            if v54 and v54.Inspect then
                local Inspect2 = v54.Inspect;

                if Inspect2.Position and Inspect2.Size then
                    Inspect.Position = UDim2.fromScale(Inspect2.Position.X, Inspect2.Position.Y);
                    Inspect.Size = UDim2.fromScale(Inspect2.Size.X, Inspect2.Size.Y);
                end;
            end;
        end;

        MobileButtons.Visible = false;
    end;

    local Charm = Bottom.Middle:FindFirstChild("Charm");

    if Charm then
        local Next = Charm:FindFirstChild("Next");

        if Next and Next:IsA("GuiButton") then
            ActivateButton(Next);
            Next.MouseButton1Click:Connect(function() -- Line: 524
                -- upvalues: u1 (ref)
                u1.CycleCharmPosition();
            end);
        end;

        local Confirm = Charm:FindFirstChild("Confirm");

        if Confirm and Confirm:IsA("GuiButton") then
            ActivateButton(Confirm);
            Confirm.MouseButton1Click:Connect(function() -- Line: 532
                -- upvalues: Router (ref)
                Router.broadcastRouter("ConfirmCharmAttachment");
            end);
        end;
    end;
end;

local function updateInspectMobileButtonsVisibility() -- Line: 541
    -- upvalues: MenuState (copy), u20 (ref), u19 (ref), u3 (copy)
    local v55 = MenuState.GetMenuFrame();

    if not v55 then
        return;
    end;

    local v56 = v55:FindFirstChild("Inspect") or v55:FindFirstChild("InspectFrame");

    if not v56 then
        return;
    end;

    local MobileButtons = v56:FindFirstChild("MobileButtons");

    if not MobileButtons then
        return;
    end;

    local Inspect = MobileButtons:FindFirstChild("Inspect");

    if not Inspect then
        return;
    end;

    local v57 = u20;

    if v57 then
        if u19 == "Viewmodel" then
            v57 = u3;
        else
            v57 = false;
        end;
    end;

    MobileButtons.Visible = v57;
    Inspect.Visible = v57;
end;

local function updateCharmFrameVisibility() -- Line: 569
    -- upvalues: MenuState (copy), Router (copy)
    local v58 = MenuState.GetMenuFrame();

    if not v58 then
        return;
    end;

    local v59 = v58:FindFirstChild("Inspect") or v58:FindFirstChild("InspectFrame");

    if not v59 then
        return;
    end;

    local Bottom = v59:FindFirstChild("Bottom");

    if not Bottom then
        return;
    end;

    local Charm = Bottom.Middle:FindFirstChild("Charm");
    local Buttons = Bottom.Middle:FindFirstChild("Buttons");

    if Charm then
        Charm.Visible = Router.broadcastRouter("HasPendingCharmAttachment") or false;
        Buttons.Visible = not Charm.Visible;
    end;
end;

local function isGloveInventoryItem(p60) -- Line: 596
    -- upvalues: GetWeaponProperties (copy)
    if not p60 then
        return false;
    end;

    if p60.Type == "Glove" then
        return true;
    end;

    if p60.Name then
        local success, result = pcall(GetWeaponProperties, p60.Name);

        if success and (result and result.Class) then
            return result.Class == "Glove";
        end;
    end;

    return false;
end;

local function supportsViewmodelInspect(p61) -- Line: 617
    -- upvalues: GetWeaponProperties (copy)
    if p61.Type == "Weapon" or (p61.Type == "Melee" or p61.Type == "Glove") then
        return true;
    end;

    if p61.Name then
        local success, result = pcall(GetWeaponProperties, p61.Name);

        if success and (result and result.Class) then
            return (result.Class == "Weapon" or result.Class == "Melee") and true or result.Class == "Glove";
        end;
    end;

    return false;
end;

local function cleanupGloveViewmodelInspectAnimation() -- Line: 634
    -- upvalues: u5 (ref), u6 (ref)
    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;
end;

local function playGloveViewmodelInspectAnimation() -- Line: 651
    -- upvalues: u5 (ref), u7 (ref)
    if not u5 then
        return;
    end;

    if u7 and u7.Animation then
        u7.Animation:stopAnimations();
    end;

    if u5.IsPlaying then
        u5:Stop(0);
    end;

    u5.TimePosition = 0;
    u5:Play(0, 1, 1);
end;

local function setupGloveViewmodelInspectAnimation() -- Line: 670
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if not (u7 and u7.Animation) then
        return;
    end;

    local Animator = u7.Animation.Animator;

    if not Animator then
        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://135926544677482";
    local success, result = pcall(function() -- Line: 685
        -- upvalues: Animator (copy), Animation (copy)
        return Animator:LoadAnimation(Animation);
    end);

    if not (success and result) then
        Animation:Destroy();

        return;
    end;

    u6 = Animation;
    u5 = result;

    if not u5 then
        return;
    end;

    if u7 and u7.Animation then
        u7.Animation:stopAnimations();
    end;

    if u5.IsPlaying then
        u5:Stop(0);
    end;

    u5.TimePosition = 0;
    u5:Play(0, 1, 1);
end;

local function resolveInspectViewmodelSkin(p62, p63) -- Line: 702
    -- upvalues: Skins (copy)
    local v64 = (not p63 or (p63 == "" or not p63)) and "Vanilla" or p63;

    if Skins.GetSkinInformation(p62, v64) then
        return v64;
    end;

    if Skins.GetSkinInformation(p62, "Vanilla") then
        return "Vanilla";
    end;

    if Skins.GetSkinInformation(p62, "Default") then
        return "Default";
    end;

    local v65 = Skins.GetAllSkinsForWeapon(p62);

    if v65 and (v65[1] and v65[1].skin) then
        return v65[1].skin;
    end;

    return v64;
end;

local function resolveGloveProxyWeapon() -- Line: 726
    -- upvalues: Skins (copy)
    for _, v in ipairs({ "FAMAS", "AK-47", "M4A1-S", "Glock-18", "USP-S" }) do
        local v66 = Skins.GetBaseWeaponModel(v, "Camera");

        if v66 then
            v66:Destroy();

            return v;
        end;
    end;

    return "FAMAS";
end;

local function clearViewmodelHorizontalOffset(p67) -- Line: 742
    if not (p67 and p67.Model) then
        return;
    end;

    local Stats = p67.Model:FindFirstChild("Stats");

    if not Stats then
        return;
    end;

    local Default = Stats:FindFirstChild("Default");

    if Default then
        local Value = Default.Value;

        if typeof(Value) == "Vector3" then
            Default.Value = Vector3.new(0.05, Value.Y, Value.Z);
        end;
    end;
end;

local function cleanupWeaponInspect() -- Line: 764
    -- upvalues: u14 (ref), u8 (ref)
    if u14 then
        u14:Destroy();
        u14 = nil;
    end;

    u8 = nil;
end;

local function cleanupViewmodelInspect() -- Line: 772
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy)
    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if u7 then
        u7:destroy();
        u7 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    InputController.enableGroup("Gameplay");
end;

local function setupWeaponInspect(p68) -- Line: 790
    -- upvalues: u16 (ref), Skins (copy), u14 (ref), u8 (ref)
    if not u16 then
        return;
    end;

    local WeaponPart = u16:FindFirstChild("WeaponPart");

    if not WeaponPart then
        warn("[InspectController]: Inspect scene missing WeaponPart");

        return;
    end;

    local v69 = nil;
    local v70 = p68.Type == "Glove";
    local v71 = p68.Type == "Charm";
    local v72 = p68.Type == "Badge";

    if v70 then
        local v73 = Skins.GetGloves(p68.Name, p68.Skin, p68.Float);

        if v73 then
            if v73:IsA("BasePart") then
                v69 = Instance.new("Model");
                v69.Name = p68.Name;
                v73.Parent = v69;
                v69.PrimaryPart = v73;
            else
                v69 = v73;
            end;
        end;
    elseif v71 then
        v69 = Skins.GetCharmModel(p68.Skin, p68.Pattern or 1) or v69;
    elseif v72 then
        v69 = Skins.GetBadgeModel(p68.Skin) or v69;
    else
        v69 = Skins.GetCharacterModel(p68.Name, p68.Skin, p68.Float, p68.StatTrack, p68.NameTag, p68.Charm, p68.Stickers);
    end;

    if not v69 then
        warn(`[InspectController]: Failed to get model for "{p68.Name}"`, p68);

        return;
    end;

    v69.Name = "InspectWeapon";
    u14 = v69;
    u8 = v69:FindFirstChild("InspectPivot", true);

    if u8 then
        warn((`[InspectController]: Found InspectPivot at {u8:GetFullName()}`));
    else
        warn((`[InspectController]: No InspectPivot found for {p68.Name}`));
    end;

    local CharmBase = v69:FindFirstChild("CharmBase", true);

    for _, descendant in ipairs(v69:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local v74;

            if CharmBase then
                v74 = descendant:IsDescendantOf(CharmBase);
            else
                v74 = CharmBase;
            end;

            descendant.CastShadow = false;

            if v71 then
                if v69.PrimaryPart == descendant then
                    descendant.CanCollide = false;
                    descendant.CanQuery = false;
                    descendant.CanTouch = false;
                    descendant.Anchored = true;
                else
                    descendant.CanCollide = false;
                    descendant.CanQuery = false;
                    descendant.CanTouch = false;
                    descendant.Anchored = false;
                end;
            elseif v74 then
                descendant.Anchored = false;
            else
                descendant.CanCollide = descendant:IsA("MeshPart") and true or false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Anchored = true;
            end;
        end;
    end;

    if v70 and (p68.Name == "T Glove" or p68.Name == "CT Glove") then
        local v75 = {};

        for _, child in ipairs(v69:GetChildren()) do
            if child:IsA("BasePart") then
                table.insert(v75, child);
            end;
        end;

        if #v75 >= 2 then
            local v76 = v69:FindFirstChild("RightGlove") or v75[1];

            for _, v in ipairs(v75) do
                if v ~= v76 then
                    v:Destroy();
                end;
            end;
        end;
    end;

    v69.Parent = u16;
    local v77 = CFrame.Angles(0, -1.5707963267948966, 0);

    if not u8 then
        v69:PivotTo(WeaponPart.CFrame * v77);

        return;
    end;

    local v78 = v69:GetPivot():ToObjectSpace(u8.WorldCFrame);
    v69:PivotTo(WeaponPart.CFrame * v77 * v78:Inverse());
end;

local function setupViewmodelInspect(u79) -- Line: 941
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), LocalPlayer (copy), GetWeaponProperties (copy), MenuSceneController (copy), HttpService (copy), Router (copy), u32 (ref), resolveGloveProxyWeapon (copy), resolveInspectViewmodelSkin (copy), Viewmodel (copy), CurrentCamera (copy), clearViewmodelHorizontalOffset (copy), setupGloveViewmodelInspectAnimation (copy)
    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if u7 then
        u7:destroy();
        u7 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    InputController.enableGroup("Gameplay");
    local v80 = LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" and "CT" or "T";
    local v81;

    if u79 then
        if u79.Type == "Glove" then
            v81 = true;
        elseif u79.Name then
            local success, result = pcall(GetWeaponProperties, u79.Name);

            if success and (result and result.Class) then
                v81 = result.Class == "Glove";
            else
                v81 = false;
            end;
        else
            v81 = false;
        end;
    else
        v81 = false;
    end;

    local v82 = MenuSceneController.CreateStandaloneCharacter(v80);

    if not v82 then
        warn("[InspectController]: Failed to create standalone character for viewmodel");

        return;
    end;

    if v81 then
        local v83 = {
            Name = u79.Name,
            Skin = u79.Skin,
            Float = u79.Float
        };

        if u79._id and u79._id ~= "" then
            v83.SkinIdentifier = u79._id;
        end;

        v82:SetAttribute("EquippedGloves", HttpService:JSONEncode(v83));
    end;

    u10 = v82;
    local Charm = u79.Charm;
    local v84 = Router.broadcastRouter("HasPendingCharmAttachment") and type(Charm) == "table" and {
        _id = Charm._id,
        Position = tostring(u32)
    } or Charm;
    local u85 = {
        Player = LocalPlayer,
        Character = v82,
        StatTrack = u79.StatTrack,
        Stickers = u79.Stickers,
        NameTag = u79.NameTag,
        Float = u79.Float,
        Charm = v84
    };
    local Name = u79.Name;
    local Skin = u79.Skin;
    local u86 = false;
    local u87;

    if v81 then
        Name = resolveGloveProxyWeapon();
        u86 = true;
        u87 = "Stock";
    else
        u87 = resolveInspectViewmodelSkin(Name, Skin);
    end;

    local function createViewmodelFor(p88, u89) -- Line: 1009
        -- upvalues: u85 (copy), u86 (ref), Viewmodel (ref), u79 (copy)
        u85.ViewmodelCameraWeapon = p88;
        u85.ViewmodelHideWeaponGeometry = u86;
        local success, result = pcall(function() -- Line: 1012
            -- upvalues: Viewmodel (ref), u85 (ref), u79 (ref), u89 (copy)
            return Viewmodel.new(u85, u79.Name, u89);
        end);

        if success and result then
            return result, nil;
        end;

        return nil, result;
    end;

    u85.ViewmodelCameraWeapon = Name;
    u85.ViewmodelHideWeaponGeometry = u86;
    local success, result = pcall(function() -- Line: 1012
        -- upvalues: Viewmodel (ref), u85 (copy), u79 (copy), u87 (copy)
        return Viewmodel.new(u85, u79.Name, u87);
    end);
    local v90;

    if success and result then
        v90 = nil;
    else
        v90 = result;
        result = nil;
    end;

    if result then
        u7 = result;

        if u7 then
            u7:equip(v81);

            if u7.Model then
                if u7.Model.Parent ~= CurrentCamera then
                    u7.Model.Parent = CurrentCamera;
                end;

                if u7.Hidden then
                    u7:unhide();
                end;

                if v81 then
                    clearViewmodelHorizontalOffset(u7);
                end;

                if v81 then
                    setupGloveViewmodelInspectAnimation();
                end;

                task.defer(function() -- Line: 1060
                    -- upvalues: u7 (ref)
                    if not (u7 and u7.Model) then
                        return;
                    end;

                    for _, descendant in ipairs(u7.Model:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            descendant.CastShadow = false;

                            if descendant.Name ~= "HumanoidRootPart" and (descendant.Name ~= "ViewmodelLight" and (descendant.Name ~= "MuzzlePart" and descendant.Name ~= "MuzzlePartL")) and descendant.Name ~= "MuzzlePartR" then
                                local v91 = descendant:GetAttribute("HiddenTransparency");

                                if v91 == nil then
                                    v91 = nil;
                                else
                                    descendant:SetAttribute("HiddenTransparency", nil);
                                end;

                                local v92;

                                if v91 == nil then
                                    v92 = descendant:GetAttribute("_CaseScenePrevTransparency");

                                    if v92 == nil then
                                        v92 = v91;
                                    else
                                        descendant:SetAttribute("_CaseScenePrevTransparency", nil);
                                    end;
                                else
                                    v92 = v91;
                                end;

                                local v93;

                                if v92 == nil then
                                    v93 = descendant:GetAttribute("_InspectPrevTransparency");

                                    if v93 == nil then
                                        v93 = v92;
                                    else
                                        descendant:SetAttribute("_InspectPrevTransparency", nil);
                                    end;
                                else
                                    v93 = v92;
                                end;

                                if v93 == nil then
                                    if descendant.Transparency >= 1 and (descendant.Name == "Right Arm" or descendant.Name == "Left Arm") then
                                        descendant.Transparency = 0;
                                    end;
                                else
                                    descendant.Transparency = v93;
                                end;
                            end;
                        elseif descendant:IsA("SurfaceGui") then
                            if descendant:GetAttribute("_InspectPrevSurfaceGuiEnabled") then
                                descendant.Enabled = true;
                                descendant:SetAttribute("_InspectPrevSurfaceGuiEnabled", nil);
                            end;

                            if descendant:GetAttribute("_CaseScenePrevSurfaceGuiEnabled") then
                                descendant.Enabled = true;
                                descendant:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", nil);
                            end;

                            if not descendant.Enabled then
                                descendant.Enabled = true;
                            end;
                        end;
                    end;
                end);
            end;
        end;

        return;
    end;

    warn(`[InspectController]: Failed to create viewmodel ({Name} | {u87})`, v90);

    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if u7 then
        u7:destroy();
        u7 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    InputController.enableGroup("Gameplay");
end;

local function setInspectMode(p94) -- Line: 1127
    -- upvalues: u9 (ref), GetWeaponProperties (copy), u19 (ref), u14 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), updateInspectMobileButtonsVisibility (copy), setupWeaponInspect (copy), u23 (ref), setupViewmodelInspect (copy), DEFAULT_CAMERA_FOV (copy)
    local v95 = u9;

    if not v95 then
        return;
    end;

    local v96;

    if v95 then
        if v95.Type == "Glove" then
            v96 = true;
        elseif v95.Name then
            local success, result = pcall(GetWeaponProperties, v95.Name);

            if success and (result and result.Class) then
                v96 = result.Class == "Glove";
            else
                v96 = false;
            end;
        else
            v96 = false;
        end;
    else
        v96 = false;
    end;

    local v97 = v96 and p94 == "Weapon" and "Viewmodel" or p94;

    if u19 == v97 then
        return;
    end;

    if u19 == "Weapon" then
        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        u8 = nil;
    elseif u19 == "Viewmodel" then
        if u5 then
            if u5.IsPlaying then
                u5:Stop(0);
            end;

            u5:Destroy();
            u5 = nil;
        end;

        if u6 then
            u6:Destroy();
            u6 = nil;
        end;

        if u7 then
            u7:destroy();
            u7 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        InputController.enableGroup("Gameplay");
    end;

    u19 = v97;
    updateInspectMobileButtonsVisibility();

    if v97 ~= "Weapon" then
        if v97 == "Viewmodel" then
            InputController.disableGroup("Gameplay");
            setupViewmodelInspect(v95);
            u23 = DEFAULT_CAMERA_FOV;
        end;

        return;
    end;

    setupWeaponInspect(v95);
    u23 = 40;
    InputController.enableGroup("Gameplay");
end;

local function tween(p98, p99) -- Line: 1170
    -- upvalues: TweenService (copy)
    if p98 then
        TweenService:Create(p98, TweenInfo.new(0.2), p99):Play();
    end;
end;

local function updateButtonVisuals(p100, p101, p102) -- Line: 1176
    -- upvalues: u19 (ref), TweenService (copy)
    local HoverFrame = p101:FindFirstChild("HoverFrame");
    local SelectFrame = p101:FindFirstChild("SelectFrame");
    local ImageLabel = p101:FindFirstChild("ImageLabel");
    local v103;

    if u19 == p100 then
        v103 = p100 ~= "Info";
    else
        v103 = false;
    end;

    if v103 then
        local v104 = {
            BackgroundTransparency = 1
        };

        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v104):Play();
        end;

        local v105 = {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(95, 95, 95)
        };

        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), v105):Play();
        end;

        if ImageLabel then
            local v106 = {
                ImageColor3 = Color3.fromRGB(210, 210, 210)
            };

            if ImageLabel then
                TweenService:Create(ImageLabel, TweenInfo.new(0.2), v106):Play();
            end;
        end;
    else
        local v107 = {
            BackgroundTransparency = 1
        };

        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), v107):Play();
        end;

        if ImageLabel then
            local v108 = {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            };

            if ImageLabel then
                TweenService:Create(ImageLabel, TweenInfo.new(0.2), v108):Play();
            end;
        end;

        local v109 = {
            BackgroundTransparency = p102 and 0 or 1
        };

        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v109):Play();
        end;
    end;
end;

local function refreshAllButtons(p110, p111) -- Line: 1198
    -- upvalues: updateButtonVisuals (copy)
    for i, v in pairs(p110) do
        if v and v:IsA("GuiButton") then
            updateButtonVisuals(i, v, i == p111);
        end;
    end;
end;

local function formatInfoText(p112, p113) -- Line: 1206
    return `<b><font color="rgb(175,175,175)">{p112}</font></b>: <font color="rgb(255,255,255)">{p113}</font>`;
end;

local function stripRichText(p114) -- Line: 1210
    return p114:gsub("<[^>]*>", "");
end;

local function scaleInfoFrameToFit(p115, p116) -- Line: 1215
    -- upvalues: CurrentCamera (copy), TextService (copy)
    local v117 = math.floor(CurrentCamera.ViewportSize.Y * 0.025);
    local v118 = math.min(v117, 32);
    local v119 = math.max(8, v118);
    local Gotham = Enum.Font.Gotham;
    local v120 = 0;

    for _, v in ipairs(p116) do
        if v and (v:IsA("TextLabel") and v.Text ~= "") then
            v.TextScaled = false;
            local v121 = TextService:GetTextSize(v.Text:gsub("<[^>]*>", ""), v119, Gotham, Vector2.new((1 / 0), (1 / 0)));

            if v120 < v121.X then
                v120 = v121.X;
            end;

            v.TextSize = v119;
            v.TextWrapped = false;
        end;
    end;

    if v120 > 0 then
        p115.Size = UDim2.new(0.05, v120, p115.Size.Y.Scale, p115.Size.Y.Offset);
    end;
end;

local function showInfoFrame(p122, p123, p124) -- Line: 1258
    -- upvalues: Skins (copy), scaleInfoFrameToFit (copy)
    local Information = p122:FindFirstChild("Information");

    if not Information then
        return;
    end;

    if p124 then
        Information.Position = UDim2.new(0, p124.AbsolutePosition.X + p124.AbsoluteSize.X / 2 - Information.Parent.AbsolutePosition.X + Information.AbsoluteSize.X / 2, Information.Position.Y.Scale, Information.Position.Y.Offset);
    end;

    Information.Visible = true;
    local v125 = Skins.GetSkinInformation(p123.Name, p123.Skin);
    local v126;

    if v125 then
        local _, v127 = Skins.GetWearNameForFloat(v125, p123.Float or 0);
        v126 = v127 or "Mint Condition";
    else
        v126 = "Mint Condition";
    end;

    local v128 = p123.Type == "Charm";
    local Exterior = Information:FindFirstChild("Exterior");

    if Exterior then
        if v128 then
            Exterior.Visible = false;
        else
            Exterior.Visible = true;
            Exterior.RichText = true;
            Exterior.Text = `<b><font color="rgb(175,175,175)">Exterior</font></b>: <font color="rgb(255,255,255)">{v126}</font>`;
        end;
    end;

    local Tradeable = Information:FindFirstChild("Tradeable");

    if Tradeable then
        Tradeable.RichText = true;
        Tradeable.Text = `<b><font color="rgb(175,175,175)">Tradeable</font></b>: <font color="rgb(255,255,255)">{p123.IsTradeable and "Yes" or "No"}</font>`;
    end;

    local Serial = Information:FindFirstChild("Serial");

    if Serial then
        Serial.RichText = true;
        local Serial2 = p123.Serial;
        Serial.Text = `<b><font color="rgb(175,175,175)">Serial</font></b>: <font color="rgb(255,255,255)">{typeof(Serial2) ~= "number" and "N/A" or `#{tostring(Serial2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`}</font>`;
    end;

    local Pattern = Information:FindFirstChild("Pattern");

    if Pattern then
        if p123.Type == "Charm" then
            Pattern.Visible = true;
            Pattern.RichText = true;
            Pattern.Text = `<b><font color="rgb(175,175,175)">Pattern</font></b>: <font color="rgb(255,255,255)">{tostring(p123.Pattern or 0)}</font>`;
        elseif p123.Skin:find("PATTERN") then
            local _, v129 = table.unpack(p123.Skin:split("_PATTERN_"));
            Pattern.Text = `<b><font color="rgb(175,175,175)">Pattern</font></b>: <font color="rgb(255,255,255)">{v129}</font>`;
            Pattern.Visible = true;
        else
            Pattern.Visible = false;
        end;
    end;

    local Float = Information:FindFirstChild("Float");

    if Float then
        if v128 then
            Float.Visible = false;
        else
            Float.Visible = true;
            Float.RichText = true;
            Float.Text = `<b><font color="rgb(175,175,175)">Float</font></b>: <font color="rgb(255,255,255)">{string.format("%.14f", p123.Float or 0)}</font>`;
        end;
    end;

    task.defer(function() -- Line: 1353
        -- upvalues: Exterior (copy), Tradeable (copy), Serial (copy), Pattern (copy), Float (copy), scaleInfoFrameToFit (ref), Information (copy)
        local v130 = {};

        if Exterior and Exterior.Visible then
            table.insert(v130, Exterior);
        end;

        if Tradeable then
            table.insert(v130, Tradeable);
        end;

        if Serial then
            table.insert(v130, Serial);
        end;

        if Pattern and Pattern.Visible then
            table.insert(v130, Pattern);
        end;

        if Float and Float.Visible then
            table.insert(v130, Float);
        end;

        scaleInfoFrameToFit(Information, v130);
    end);
end;

local function hideInfoFrame(p131) -- Line: 1375
    local Information = p131:FindFirstChild("Information");

    if Information then
        Information.Visible = false;
    end;
end;

local function shouldHideInfoButton() -- Line: 1383
    -- upvalues: MenuState (copy), PlayerGui (copy)
    if MenuState.IsCaseSceneActive() then
        return true;
    end;

    if MenuState.GetScreenBeforeCaseScene() == "Store" then
        return true;
    end;

    if MenuState.GetCurrentScreen() == "Store" then
        return true;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        local Menu = MainGui:FindFirstChild("Menu");
        local v132 = Menu and Menu:FindFirstChild("Store");

        if v132 then
            local CaseContent = v132:FindFirstChild("CaseContent");

            if CaseContent and CaseContent:GetAttribute("WasVisibleBeforeInspect") == true then
                return true;
            end;
        end;
    end;

    return false;
end;

local function setupButtonEvents(u133, u134, u135, u136) -- Line: 1414
    -- upvalues: u18 (copy), updateButtonVisuals (copy), u9 (ref), shouldHideInfoButton (copy), showInfoFrame (copy), u19 (ref), setInspectMode (copy), refreshAllButtons (copy)
    u18:Add(u133.MouseEnter:Connect(function() -- Line: 1421
        -- upvalues: updateButtonVisuals (ref), u134 (copy), u133 (copy), u136 (copy), u9 (ref), shouldHideInfoButton (ref), showInfoFrame (ref)
        updateButtonVisuals(u134, u133, true);

        if u134 == "Info" and (u136 and u9) and (not shouldHideInfoButton() and u9.Type ~= "Badge") then
            showInfoFrame(u136, u9, u133);
        end;
    end), "Disconnect", "InspectButton_Enter_" .. u134);
    u18:Add(u133.MouseLeave:Connect(function() -- Line: 1435
        -- upvalues: updateButtonVisuals (ref), u134 (copy), u133 (copy), u136 (copy)
        updateButtonVisuals(u134, u133, false);
        local v137 = u134 == "Info" and (u136 and u136:FindFirstChild("Information"));

        if v137 then
            v137.Visible = false;
        end;
    end), "Disconnect", "InspectButton_Leave_" .. u134);

    if u134 == "Info" then
        u18:Add(u133.Activated:Connect(function() -- Line: 1447
            -- upvalues: u136 (copy), u9 (ref), shouldHideInfoButton (ref), showInfoFrame (ref), u133 (copy)
            if u136 and (u9 and (not shouldHideInfoButton() and u9.Type ~= "Badge")) then
                showInfoFrame(u136, u9, u133);
            end;
        end), "Disconnect", "InspectButton_Activated_Info");

        return;
    end;

    u18:Add(u133.MouseButton1Click:Connect(function() -- Line: 1462
        -- upvalues: u19 (ref), u134 (copy), setInspectMode (ref), refreshAllButtons (ref), u135 (copy)
        if u19 ~= u134 then
            setInspectMode(u134);
            refreshAllButtons(u135, u134);
        end;
    end), "Disconnect", "InspectButton_Click_" .. u134);
end;

local function setupInspectButtons(p138, p139) -- Line: 1476
    -- upvalues: supportsViewmodelInspect (copy), GetWeaponProperties (copy), shouldHideInfoButton (copy), updateButtonVisuals (copy), setupButtonEvents (copy)
    local Middle = p138:FindFirstChild("Bottom").Middle;

    if Middle then
        Middle = Middle:FindFirstChild("Buttons");
    end;

    if not Middle then
        return;
    end;

    local v140 = supportsViewmodelInspect(p139);
    local v141;

    if p139 then
        if p139.Type == "Glove" then
            v141 = true;
        elseif p139.Name then
            local success, result = pcall(GetWeaponProperties, p139.Name);

            if success and (result and result.Class) then
                v141 = result.Class == "Glove";
            else
                v141 = false;
            end;
        else
            v141 = false;
        end;
    else
        v141 = false;
    end;

    local v142 = {
        Info = Middle:FindFirstChild("Info"),
        Viewmodel = Middle:FindFirstChild("Viewmodel"),
        Weapon = Middle:FindFirstChild("Weapon")
    };
    local v143 = shouldHideInfoButton();
    local v144 = p139.Type == "Badge";

    for i, v in pairs(v142) do
        if v and v:IsA("GuiButton") then
            if i == "Info" then
                v.Visible = not v143 and not v144;
            elseif i == "Weapon" then
                local v145;

                if v140 then
                    v145 = not v141;
                else
                    v145 = v140;
                end;

                v.Visible = v145;
            else
                v.Visible = v140;
            end;

            updateButtonVisuals(i, v, false);
            setupButtonEvents(v, i, v142, p138);
        end;
    end;
end;

local function updateCollectionData(p146, p147) -- Line: 1514
    -- upvalues: Collections (copy), u28 (copy)
    if p147 then
        p147 = p147.collection;
    end;

    local v148;

    if p147 then
        v148 = Collections.GetCollectionByName(p147);
    else
        v148 = p147;
    end;

    local v149 = v148 ~= nil;
    local Collection = p146.Top.Frame.Frame.TextInfo:FindFirstChild("Collection");

    if Collection and Collection:IsA("TextLabel") then
        Collection.Visible = v149;
        Collection.Text = p147 or "";
    end;

    local CollectionIcon = p146.Top.Frame.Frame:FindFirstChild("CollectionIcon");

    if CollectionIcon and CollectionIcon:IsA("ImageLabel") then
        CollectionIcon.Image = v148 and v148.imageAssetId or "";
        CollectionIcon.Visible = v149;
    end;

    local WeaponName = p146:FindFirstChild("WeaponName");

    if WeaponName and WeaponName:IsA("TextLabel") then
        WeaponName.Position = v149 and u28.WEAPON_NAME_COLLECTION_POSITION or u28.WEAPON_NAME_NO_COLLECTION_POSITION;
        WeaponName.Size = v149 and u28.WEAPON_NAME_COLLECTION_SIZE or u28.WEAPON_NAME_NO_COLLECTION_SIZE;
        WeaponName.TextXAlignment = Enum.TextXAlignment.Center;
    end;

    local Rarity = p146:FindFirstChild("Rarity");

    if Rarity and Rarity:IsA("Frame") then
        Rarity.Position = v149 and u28.RARITY_FRAME_COLLECTION_POSITION or u28.RARITY_FRAME_NO_COLLECTION_POSITION;
    end;
end;

local function updateInspectFrameUI(p150) -- Line: 1552
    -- upvalues: PlayerGui (copy), setupInspectButtons (copy), shouldHideInfoButton (copy), Skins (copy), GetSkinDisplayName (copy), updateCollectionData (copy), Rarities (copy)
    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if not MainGui then
        return;
    end;

    local Menu = MainGui:FindFirstChild("Menu");

    if not Menu then
        return;
    end;

    local v151 = Menu:FindFirstChild("Inspect") or Menu:FindFirstChild("InspectFrame");

    if not v151 then
        return;
    end;

    setupInspectButtons(v151, p150);
    local v152 = shouldHideInfoButton() and v151:FindFirstChild("Information");

    if v152 then
        v152.Visible = false;
    end;

    local v153 = Skins.GetSkinInformation(p150.Name, p150.Skin);
    local Item = v151.Top.Frame.Frame.TextInfo:FindFirstChild("Item");

    if Item and Item:IsA("TextLabel") then
        local v154 = GetSkinDisplayName(p150.Skin);
        local v155 = " | " .. v154;
        Item.Text = (v153 and v153.type == "Melee" and "★ " or "") .. (p150.Name:find("Zeus") and "Taser" or p150.Name) .. (v155 and v155 == "Vanilla" and "" or v155);
    end;

    if v153 then
        updateCollectionData(v151, v153);
        local Rarity = v151.Top.Frame:FindFirstChild("Rarity");
        local v156 = Rarity and (Rarity:IsA("Frame") and v153.rarity) and Rarities[v153.rarity];

        if v156 then
            Rarity.BackgroundColor3 = v156.Color;
        end;
    end;

    local Description = v151.Bottom.Middle:FindFirstChild("Description");

    if Description then
        local v157 = typeof(p150.StatTrack) == "number" and true or p150.StatTrack == true;
        Description.Statrak.Visible = v157;
        Description.Description.Text = v153.description or "";
    end;
end;

local function hideViewmodels() -- Line: 1647
    -- upvalues: u17 (ref), CurrentCamera (copy), u7 (ref)
    u17 = {};

    for _, child in ipairs(CurrentCamera:GetChildren()) do
        if child:IsA("Model") and (child.Name ~= "InspectScene" and (not u7 or u7.Model ~= child)) then
            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if descendant.Transparency < 1 then
                        descendant:SetAttribute("_InspectPrevTransparency", descendant.Transparency);
                        descendant.Transparency = 1;
                    end;
                elseif descendant:IsA("SurfaceGui") then
                    if descendant.Enabled then
                        descendant:SetAttribute("_InspectPrevSurfaceGuiEnabled", true);
                        descendant.Enabled = false;
                    end;
                elseif descendant:IsA("Texture") and descendant.Transparency < 1 then
                    descendant:SetAttribute("_InspectPrevTransparency", descendant.Transparency);
                    descendant.Transparency = 1;
                end;
            end;

            table.insert(u17, child);
        end;
    end;
end;

local function showViewmodels() -- Line: 1683
    -- upvalues: u17 (ref)
    for _, v in ipairs(u17) do
        if v and v.Parent then
            for _, descendant in ipairs(v:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local v158 = descendant:GetAttribute("_InspectPrevTransparency");

                    if v158 ~= nil then
                        descendant.Transparency = v158;
                        descendant:SetAttribute("_InspectPrevTransparency", nil);
                    end;
                elseif descendant:IsA("SurfaceGui") then
                    if descendant:GetAttribute("_InspectPrevSurfaceGuiEnabled") ~= nil then
                        descendant.Enabled = true;
                        descendant:SetAttribute("_InspectPrevSurfaceGuiEnabled", nil);
                    end;
                elseif descendant:IsA("Texture") then
                    local v159 = descendant:GetAttribute("_InspectPrevTransparency");

                    if v159 == nil then
                        descendant.Transparency = 0.3;
                    else
                        descendant.Transparency = v159;
                        descendant:SetAttribute("_InspectPrevTransparency", nil);
                    end;
                end;
            end;
        end;
    end;

    u17 = {};
end;

local function restoreMenuFrames() -- Line: 1720
    -- upvalues: MenuState (copy), u13 (ref), MenuSceneController (copy)
    local v160 = MenuState.GetMenuFrame();

    if not (v160 and v160.Visible) then
        u13 = false;
        MenuState.ExitInspect();

        return;
    end;

    local v161 = v160:FindFirstChild("Inspect") or v160:FindFirstChild("InspectFrame");

    if v161 and v161:IsA("GuiObject") then
        local MobileButtons = v161:FindFirstChild("MobileButtons");
        v161.Visible = false;

        if MobileButtons then
            MobileButtons.Visible = false;
        end;
    end;

    local v162 = MenuState.GetScreenBeforeInspect();
    local v163 = u13;
    u13 = false;
    MenuState.ExitInspect();

    if v163 then
        MenuSceneController.ShowMenuScene();
        MenuSceneController.SetMusicVolumeMultiplier(1, 0.5);
    end;

    local Top = v160:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    if v162 then
        local v164 = v160:FindFirstChild(v162);

        if v164 then
            for _, child in ipairs(v160:GetChildren()) do
                if child:IsA("Frame") and (child.Name ~= "Top" and (child.Name ~= v162 and (child.Name ~= "Inspect" and child.Name ~= "InspectFrame"))) then
                    child.Visible = false;
                end;
            end;

            v164.Visible = true;

            if MenuState.IsCaseSceneActive() and v162 == "Store" then
                MenuState.SetBlurEnabled(false);
                v160.BackgroundTransparency = 1;
                local Pattern = v160:FindFirstChild("Pattern");

                if Pattern then
                    Pattern.Visible = false;
                end;
            else
                local v165;

                if v162 == "Dashboard" then
                    v165 = false;
                else
                    v165 = v162 ~= "Play";
                end;

                MenuState.SetBlurEnabled(v165);
                v160.BackgroundTransparency = v165 and 0.15 or 1;
                local Pattern = v160:FindFirstChild("Pattern");

                if Pattern then
                    Pattern.Visible = not v165;
                end;
            end;
        end;
    else
        for _, child in ipairs(v160:GetChildren()) do
            if child:IsA("Frame") and (child.Name ~= "Top" and (child.Name ~= "Dashboard" and (child.Name ~= "Inspect" and child.Name ~= "InspectFrame"))) then
                child.Visible = false;
            end;
        end;

        local Dashboard = v160:FindFirstChild("Dashboard");

        if Dashboard then
            Dashboard.Visible = true;
        end;

        MenuState.SetBlurEnabled(false);
        v160.BackgroundTransparency = 1;
        local Pattern = v160:FindFirstChild("Pattern");

        if Pattern then
            Pattern.Visible = true;
        end;
    end;
end;

function u1.ShowInspect(p166) -- Line: 1830
    -- upvalues: u20 (ref), u1 (copy), Router (copy), u31 (ref), u32 (ref), u9 (ref), u19 (ref), GetWeaponProperties (copy), hideMenuFrames (copy), hideViewmodels (copy), updateCharmFrameVisibility (copy), updateInspectFrameUI (copy), u12 (ref), restoreMenuFrames (copy), u16 (ref), activateInspectSceneFlags (copy), u15 (ref), applySceneLighting (copy), ReplicatedStorage (copy), applyMapLighting (copy), InputController (copy), setupViewmodelInspect (copy), setupWeaponInspect (copy), u24 (ref), u25 (ref), u26 (ref), u27 (ref), u22 (ref), DEFAULT_CAMERA_FOV (copy), u23 (ref), CurrentCamera (copy), CameraController (copy), u18 (copy), RunServiceController (copy), UserInputService (copy), u7 (ref), updateWeaponTransform (copy), u21 (ref), zero (ref), LocalPlayer (copy), u29 (ref), u30 (ref), getPinchDistance (copy), u14 (ref), u8 (ref), updateInspectMobileButtonsVisibility (copy)
    if u20 then
        u1.HideInspect();
    end;

    if Router.broadcastRouter("HasPendingCharmAttachment") then
        u31 = p166;
        u32 = 1;
    else
        u31 = nil;
    end;

    u9 = p166;
    local v167;

    if p166 then
        if p166.Type == "Glove" then
            v167 = true;
        elseif p166.Name then
            local success, result = pcall(GetWeaponProperties, p166.Name);

            if success and (result and result.Class) then
                v167 = result.Class == "Glove";
            else
                v167 = false;
            end;
        else
            v167 = false;
        end;
    else
        v167 = false;
    end;

    u19 = v167 and "Viewmodel" or "Weapon";
    hideMenuFrames();
    hideViewmodels();
    updateCharmFrameVisibility();
    updateInspectFrameUI(p166);

    if not u12 then
        warn("[InspectController]: No preloaded inspect scene available");
        restoreMenuFrames();

        return;
    end;

    if u12 and u12.Parent ~= workspace then
        u12.Parent = workspace;
    end;

    u16 = u12;
    activateInspectSceneFlags(u16);

    if u15 then
        applySceneLighting(u15);
    end;

    local u168;

    if u16 then
        u168 = u16:FindFirstChild("CamPart");
    else
        u168 = nil;
    end;

    if not u168 then
        warn("[InspectController]: Inspect scene missing CamPart");

        if u16 then
            u16.Parent = ReplicatedStorage;
            u16 = nil;
        end;

        applyMapLighting();
        restoreMenuFrames();

        return;
    end;

    local v169;

    if u16 then
        v169 = u16:FindFirstChild("WeaponPart");
    else
        v169 = nil;
    end;

    if not v169 then
        warn("[InspectController]: Inspect scene missing WeaponPart");

        if u16 then
            u16.Parent = ReplicatedStorage;
            u16 = nil;
        end;

        applyMapLighting();
        restoreMenuFrames();

        return;
    end;

    if u19 == "Viewmodel" then
        InputController.disableGroup("Gameplay");
        setupViewmodelInspect(p166);
    else
        InputController.enableGroup("Gameplay");
        setupWeaponInspect(p166);
    end;

    u24 = 0;
    u25 = 0;
    u26 = 0;
    u27 = 0;

    if u19 == "Viewmodel" then
        u22 = DEFAULT_CAMERA_FOV;
        u23 = DEFAULT_CAMERA_FOV;
    else
        u22 = 40;
        u23 = 40;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CFrame = u168.CFrame;
    CurrentCamera.Focus = u168.CFrame;
    CameraController.updateCameraFOV(u19 ~= "Viewmodel" and 40 or DEFAULT_CAMERA_FOV);
    CameraController.setForceLockOverride("Inspect", true);
    u18:Add(RunServiceController.BindToRenderStep("InspectController.CameraUpdate", function(p170) -- Line: 1946
        -- upvalues: u22 (ref), u23 (ref), u16 (ref), u168 (copy), CurrentCamera (ref), CameraController (ref), u19 (ref), UserInputService (ref), u27 (ref), u26 (ref), u7 (ref), u24 (ref), u25 (ref), updateWeaponTransform (ref)
        local v171 = math.min(1, p170 * 8);
        u22 = u22 + (u23 - u22) * v171;

        if u16 and u168 then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable;
            CurrentCamera.CFrame = u168.CFrame;
            CurrentCamera.Focus = u168.CFrame;
            CurrentCamera.FieldOfView = CameraController.clampFOV(u22);
        end;

        if u19 == "Weapon" and UserInputService.GamepadEnabled then
            local v172 = UserInputService:GetLastInputType();
            local v173 = UserInputService:GetGamepadState((v172 == Enum.UserInputType.Gamepad1 or (v172 == Enum.UserInputType.Gamepad2 or (v172 == Enum.UserInputType.Gamepad3 or v172 == Enum.UserInputType.Gamepad4))) and v172 and v172 or Enum.UserInputType.Gamepad1);

            if v173 then
                for _, v in pairs(v173) do
                    if v.KeyCode == Enum.KeyCode.Thumbstick2 then
                        local v174 = Vector2.new(v.Position.X, v.Position.Y);

                        if v174.Magnitude > 0.1 then
                            local v175 = Vector2.new(v174.X * 0.5 * 60 * p170 * 4.75, v174.Y * 0.5 * 60 * p170 * 4.75);
                            u27 = u27 + v175.X * 0.5;
                            u26 = u26 + v175.Y * 0.5;
                            u26 = math.clamp(u26, -80, 80);
                        end;
                    elseif v.KeyCode == Enum.KeyCode.ButtonR2 then
                        if v.Position.Z > 0.1 then
                            local v176 = -v.Position.Z * 2 * 30 * p170 * 0.55;

                            if u19 ~= "Viewmodel" then
                                u23 = math.clamp(u23 - v176 * 2, 20, 70);
                            end;
                        end;
                    elseif v.KeyCode == Enum.KeyCode.ButtonL2 and v.Position.Z > 0.1 then
                        local v177 = v.Position.Z * 2 * 30 * p170 * 0.55;

                        if u19 ~= "Viewmodel" then
                            u23 = math.clamp(u23 - v177 * 2, 20, 70);
                        end;
                    end;
                end;
            end;
        end;

        if u19 == "Viewmodel" and u7 then
            u7:render(p170);

            return;
        end;

        if u19 == "Weapon" then
            local v178 = math.min(1, p170 * 10);
            u24 = u24 + (u26 - u24) * v178;
            u25 = u25 + (u27 - u25) * v178;
            updateWeaponTransform();
        end;
    end), "Disconnect", "CameraUpdate");
    u18:Add(UserInputService.InputBegan:Connect(function(p179, p180) -- Line: 2034
        -- upvalues: u21 (ref), zero (ref), InputController (ref), LocalPlayer (ref), u1 (ref), u29 (ref), u30 (ref), getPinchDistance (ref)
        if p179.UserInputType == Enum.UserInputType.MouseButton1 then
            u21 = true;
            zero = Vector2.new(p179.Position.X, p179.Position.Y);
        end;

        local v181 = InputController.getActionKeybinds("Inspect");

        if table.find(v181, p179.KeyCode) then
            if LocalPlayer:GetAttribute("IsPlayerChatting") then
                return;
            end;

            u1.PlayInspectAnimation();
        end;

        if p179.UserInputType == Enum.UserInputType.Touch then
            u29[p179] = Vector2.new(p179.Position.X, p179.Position.Y);
            local v182 = 0;

            for _ in pairs(u29) do
                v182 = v182 + 1;
            end;

            if v182 == 1 then
                u21 = true;
                zero = Vector2.new(p179.Position.X, p179.Position.Y);
            end;

            u30 = getPinchDistance();
        end;
    end), "Disconnect", "InputBegan");
    u18:Add(UserInputService.InputChanged:Connect(function(p183, p184) -- Line: 2066
        -- upvalues: u21 (ref), zero (ref), u27 (ref), u26 (ref), u29 (ref), getPinchDistance (ref), u30 (ref), u19 (ref), u23 (ref)
        if p183.UserInputType == Enum.UserInputType.MouseMovement and u21 then
            local v185 = Vector2.new(p183.Position.X, p183.Position.Y);
            local v186 = v185 - zero;
            u27 = u27 + v186.X * 0.5;
            u26 = u26 + v186.Y * 0.5;
            u26 = math.clamp(u26, -80, 80);
            zero = v185;
        end;

        if p183.UserInputType == Enum.UserInputType.Touch then
            local v187 = Vector2.new(p183.Position.X, p183.Position.Y);
            u29[p183] = v187;
            local v188 = 0;

            for _ in pairs(u29) do
                v188 = v188 + 1;
            end;

            if v188 == 1 and u21 then
                local v189 = v187 - zero;
                u27 = u27 + v189.X * 0.5;
                u26 = u26 + v189.Y * 0.5;
                u26 = math.clamp(u26, -80, 80);
                zero = v187;
            end;

            if v188 >= 2 then
                local v190 = getPinchDistance();

                if v190 and u30 then
                    local v191 = (v190 - u30) * 0.01;

                    if u19 ~= "Viewmodel" then
                        u23 = math.clamp(u23 - v191 * 2, 20, 70);
                    end;
                end;

                u30 = v190;
            end;
        end;

        if p183.UserInputType == Enum.UserInputType.MouseWheel then
            if u19 == "Viewmodel" then
                return;
            end;

            u23 = math.clamp(u23 - p183.Position.Z * 2, 20, 70);
        end;
    end), "Disconnect", "InputChanged");
    u18:Add(UserInputService.InputEnded:Connect(function(p192, p193) -- Line: 2110
        -- upvalues: u21 (ref), u29 (ref), u30 (ref), getPinchDistance (ref)
        if p192.UserInputType == Enum.UserInputType.MouseButton1 then
            u21 = false;
        end;

        if p192.UserInputType == Enum.UserInputType.Touch then
            u29[p192] = nil;
            local v194 = 0;

            for _ in pairs(u29) do
                v194 = v194 + 1;
            end;

            if v194 == 0 then
                u21 = false;
            end;

            u30 = getPinchDistance();
        end;
    end), "Disconnect", "InputEnded");
    u18:Add(function() -- Line: 2130
        -- upvalues: u14 (ref), u16 (ref), u12 (ref), ReplicatedStorage (ref), u21 (ref), u29 (ref), u30 (ref), u24 (ref), u25 (ref), u26 (ref), u27 (ref), u22 (ref), u23 (ref), u8 (ref)
        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        if u16 and u16 == u12 then
            u16.Parent = ReplicatedStorage;
            u16 = nil;
        elseif u16 then
            u16:Destroy();
            u16 = nil;
        end;

        u21 = false;
        u29 = {};
        u30 = nil;
        u24 = 0;
        u25 = 0;
        u26 = 0;
        u27 = 0;
        u22 = 40;
        u23 = 40;
        u8 = nil;
    end, true, "InspectCleanup");
    u20 = true;
    updateInspectMobileButtonsVisibility();
end;

function u1.HideInspect(p195) -- Line: 2164
    -- upvalues: u20 (ref), u18 (copy), u5 (ref), u6 (ref), u7 (ref), u10 (ref), InputController (copy), u14 (ref), u8 (ref), MenuState (copy), CaseSceneController (copy), applyMapLighting (copy), CurrentCamera (copy), CameraController (copy), Constants (copy), restoreMenuFrames (copy), u13 (ref), showViewmodels (copy), u17 (ref), u31 (ref), u32 (ref), updateInspectMobileButtonsVisibility (copy)
    if not u20 then
        return;
    end;

    u18:Cleanup();

    if u5 then
        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if u7 then
        u7:destroy();
        u7 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    InputController.enableGroup("Gameplay");

    if u14 then
        u14:Destroy();
        u14 = nil;
    end;

    u8 = nil;

    if MenuState.IsCaseSceneActive() then
        CaseSceneController.ApplyCaseSceneLighting();
    else
        applyMapLighting();
    end;

    CurrentCamera.CameraType = Enum.CameraType.Custom;
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    CameraController.setForceLockOverride("Inspect", false);

    if p195 then
        MenuState.ExitInspect();
        u13 = false;
    else
        restoreMenuFrames();
    end;

    if MenuState.IsCaseSceneActive() then
        u17 = {};
    else
        showViewmodels();
    end;

    u31 = nil;
    u32 = 1;
    u20 = false;
    updateInspectMobileButtonsVisibility();
end;

function u1.IsActive() -- Line: 2217
    -- upvalues: u20 (ref)
    return u20;
end;

function u1.ToggleInspect(p196) -- Line: 2223
    -- upvalues: u20 (ref), u1 (copy)
    if u20 then
        u1.HideInspect();

        return;
    end;

    if p196 then
        u1.ShowInspect(p196);
    end;
end;

function u1.CycleCharmPosition() -- Line: 2233
    -- upvalues: u20 (ref), u31 (ref), u32 (ref), u1 (copy)
    if not (u20 and u31) then
        return;
    end;

    u32 = u32 % 4 + 1;
    u1.RefreshWeaponWithCharm((tostring(u32)));
end;

function u1.RefreshWeaponWithCharm(p197) -- Line: 2248
    -- upvalues: u20 (ref), u16 (ref), u31 (ref), u24 (ref), u25 (ref), u26 (ref), u27 (ref), u19 (ref), u14 (ref), Skins (copy), u8 (ref), updateWeaponTransform (copy), u7 (ref), u10 (ref)
    if not (u20 and (u16 and u31)) then
        return;
    end;

    local v198 = u16;
    local v199 = u31;

    if not v198:FindFirstChild("WeaponPart") then
        return;
    end;

    local v200 = u24;
    local v201 = u25;
    local v202 = u26;
    local v203 = u27;
    local Charm = v199.Charm;
    local v204 = type(Charm) == "table" and {
        _id = Charm._id,
        Position = p197
    } or p197;

    if u19 == "Weapon" then
        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        local v205 = Skins.GetCharacterModel(v199.Name, v199.Skin, v199.Float, v199.StatTrack, v199.NameTag, v204, v199.Stickers);

        if not v205 then
            warn((`[InspectController]: Failed to refresh weapon model for charm position {p197}`));

            return;
        end;

        v205.Name = "InspectWeapon";
        u14 = v205;
        u8 = v205:FindFirstChild("InspectPivot", true);
        local CharmBase = v205:FindFirstChild("CharmBase", true);

        for _, descendant in ipairs(v205:GetDescendants()) do
            if descendant:IsA("BasePart") then
                local v206;

                if CharmBase then
                    v206 = descendant:IsDescendantOf(CharmBase);
                else
                    v206 = CharmBase;
                end;

                descendant.CastShadow = false;

                if v206 then
                    descendant.Anchored = false;
                else
                    descendant.CanCollide = descendant:IsA("MeshPart") and true or false;
                    descendant.CanQuery = false;
                    descendant.CanTouch = false;
                    descendant.Anchored = true;
                end;
            end;
        end;

        v205.Parent = v198;
        u24 = v200;
        u25 = v201;
        u26 = v202;
        u27 = v203;
        updateWeaponTransform();
    end;

    if u7 and u10 then
        u7.Charm = v204;
        u7:construct(u10, nil);
    end;
end;

function u1.GetCurrentCharmPosition() -- Line: 2352
    -- upvalues: u32 (ref)
    return u32;
end;

function u1.PlayInspectAnimation() -- Line: 2358
    -- upvalues: u19 (ref), u7 (ref), u9 (ref), GetWeaponProperties (copy), u5 (ref)
    if u19 ~= "Viewmodel" or not u7 then
        return;
    end;

    local v207 = u9;
    local v208;

    if v207 then
        if v207.Type == "Glove" then
            v208 = true;
        elseif v207.Name then
            local success, result = pcall(GetWeaponProperties, v207.Name);

            if success and (result and result.Class) then
                v208 = result.Class == "Glove";
            else
                v208 = false;
            end;
        else
            v208 = false;
        end;
    else
        v208 = false;
    end;

    if v208 then
        if not u5 then
            return;
        end;

        if u7 and u7.Animation then
            u7.Animation:stopAnimations();
        end;

        if u5.IsPlaying then
            u5:Stop(0);
        end;

        u5.TimePosition = 0;
        u5:Play(0, 1, 1);

        return;
    end;

    if not u7.Animation then
        return;
    end;

    local v209 = u7.Animation:pickInspectVariant();
    u7.Animation:stopAnimations();
    u7.Animation:play("Idle");
    u7.Animation:play(v209);
end;

function u1.Initialize() -- Line: 2380
    -- upvalues: DataController (copy), LocalPlayer (copy), Lighting (copy), u11 (ref), getRandomInspectScene (copy), u15 (ref), u12 (ref), ReplicatedStorage (copy), UserInputService (copy), u20 (ref), u1 (copy), Router (copy), u32 (ref)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function() -- Line: 2382
        -- upvalues: DataController (ref), LocalPlayer (ref), Lighting (ref), u11 (ref)
        if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
            if u11 ~= nil then
                Lighting.GlobalShadows = u11;
            end;

            return;
        end;

        Lighting.GlobalShadows = false;
    end);
    local v210 = getRandomInspectScene();

    if v210 then
        u15 = v210.Name;
        u12 = v210;

        if u12 then
            u12.Name = "InspectScene";
            u12.Parent = ReplicatedStorage;
        end;
    else
        warn("[InspectController]: No inspect scene found to preload in ReplicatedStorage.Assets.InspectScenes");
    end;

    UserInputService.InputBegan:Connect(function(p211, p212) -- Line: 2404
        -- upvalues: u20 (ref), u1 (ref)
        if p212 then
            return;
        end;

        if p211.KeyCode == Enum.KeyCode.Escape and u20 then
            u1.HideInspect();
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 2415
        -- upvalues: u20 (ref), u1 (ref)
        if u20 then
            u1.HideInspect();
        end;
    end);
    Router.observerRouter("WeaponInspect", function(p213, p214, p215, p216, p217, p218, p219, p220, p221, p222, p223, p224) -- Line: 2424
        -- upvalues: ReplicatedStorage (ref), u1 (ref)
        if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
            return;
        end;

        u1.ShowInspect({
            _id = p222 or "inspect_" .. p213 .. "_" .. p214,
            Name = p213,
            Skin = p214,
            Float = p215,
            StatTrack = p216,
            NameTag = p217,
            Charm = p218,
            Stickers = p219,
            Type = p220,
            Pattern = p221,
            Serial = p223,
            IsTradeable = p224
        });
    end);
    Router.observerRouter("WeaponInspectClose", function() -- Line: 2466
        -- upvalues: u1 (ref)
        u1.HideInspect();
    end);
    Router.observerRouter("WeaponInspectCloseForGameEnd", function() -- Line: 2471
        -- upvalues: u1 (ref)
        u1.HideInspect(true);
    end);
    Router.observerRouter("IsInspectActive", function() -- Line: 2476
        -- upvalues: u1 (ref)
        return u1.IsActive();
    end);
    Router.observerRouter("GetCurrentCharmPosition", function() -- Line: 2481
        -- upvalues: u32 (ref)
        return u32;
    end);
end;

function u1.Start() -- Line: 2486
    -- upvalues: initializeInspectButtons (copy)
    initializeInspectButtons();
end;

return u1;