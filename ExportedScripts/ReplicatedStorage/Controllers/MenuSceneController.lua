-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local u2 = nil;
local Sound = require(ReplicatedStorage.Classes.Sound);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local CurrentCamera = workspace.CurrentCamera;
local u3 = nil;
local Lighting2 = ReplicatedStorage.Assets.Lighting;
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps;
local Characters = ReplicatedStorage.Assets.Characters;
local u4 = {
    CT = {
        Entrance = "rbxassetid://96240248165206",
        Idle = "rbxassetid://77870220857645"
    },
    T = {
        Entrance = "rbxassetid://100747011940776",
        Idle = "rbxassetid://99540873384647"
    }
};
local u5 = {
    CT = {
        Character = "IDF",
        Weapon = "M4A1-S",
        Glove = "CT Glove"
    },
    T = {
        Character = "Anarchist",
        Weapon = "AK-47",
        Glove = "T Glove"
    }
};
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter);
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = Janitor.new();
local u11 = false;
local u12 = nil;
local u13 = nil;
local u14 = 1;
local u15 = nil;
local u16 = nil;

local function applyGlobalShadowsSetting() -- Line: 102
    -- upvalues: DataController (copy), LocalPlayer (copy), Lighting (copy), u16 (ref)
    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u16 ~= nil then
            Lighting.GlobalShadows = u16;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end;

local function applyMapLighting() -- Line: 119
    -- upvalues: Maps (copy), u16 (ref), Lighting (copy), DataController (copy), LocalPlayer (copy)
    local Map = workspace:FindFirstChild("Map");

    if not Map then
        return;
    end;

    local v17 = Map:GetAttribute("MapName");

    if not v17 or typeof(v17) ~= "string" then
        return;
    end;

    local v18 = Maps:FindFirstChild(v17);

    if not (v18 and v18:IsA("ModuleScript")) then
        return;
    end;

    local v19 = require(v18);

    if not v19.Lighting then
        return;
    end;

    local Properties = v19.Lighting.Properties;

    if Properties then
        u16 = Properties.GlobalShadows;
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

    local Assets = v19.Lighting.Assets;

    if Assets then
        for _, child in ipairs(Assets:GetChildren()) do
            child:Clone().Parent = Lighting;
        end;
    end;

    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u16 ~= nil then
            Lighting.GlobalShadows = u16;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end;

local function applySceneLighting(p20) -- Line: 184
    -- upvalues: Lighting2 (copy), Maps (copy), u16 (ref), Lighting (copy), DataController (copy), LocalPlayer (copy)
    local v21 = Lighting2:FindFirstChild(p20);

    if not v21 then
        warn((`[MenuSceneController]: No lighting found for scene "{p20}"`));

        return;
    end;

    local v22 = Maps:FindFirstChild(p20);

    if v22 and v22:IsA("ModuleScript") then
        local v23 = require(v22);

        if v23.Lighting and v23.Lighting.Properties then
            local Properties = v23.Lighting.Properties;
            u16 = Properties.GlobalShadows;
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

    for _, child in ipairs(v21:GetChildren()) do
        child:Clone().Parent = Lighting;
    end;

    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u16 ~= nil then
            Lighting.GlobalShadows = u16;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end;

local function getMenuScenesFolder() -- Line: 235
    -- upvalues: u3 (ref), ReplicatedStorage (copy)
    if u3 then
        return u3;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        u3 = Assets:WaitForChild("MenuScenes", 10);
    end;

    return u3;
end;

local function getRandomMenuScene() -- Line: 249
    -- upvalues: u3 (ref), ReplicatedStorage (copy)
    local v24;

    if u3 then
        v24 = u3;
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            u3 = Assets:WaitForChild("MenuScenes", 10);
        end;

        v24 = u3;
    end;

    if not v24 then
        return nil;
    end;

    local v25 = v24:GetChildren();

    if #v25 > 0 then
        return v25[math.random(1, #v25)];
    end;

    return nil;
end;

local function isCharacterAlive() -- Line: 263
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local Humanoid = Character:FindFirstChild("Humanoid");

        if Humanoid and Humanoid.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

local function shouldShowMenuScene() -- Line: 276
    -- upvalues: ReplicatedStorage (copy), u2 (ref), PlayerGui (copy), LocalPlayer (copy)
    local MenuState = require(ReplicatedStorage.Interface.MenuState);

    if u2 and u2.IsActive() then
        return false;
    end;

    if MenuState.IsInspectActive() then
        return false;
    end;

    if workspace:FindFirstChild("InspectScene") then
        return false;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        local Gameplay = MainGui:FindFirstChild("Gameplay");

        if Gameplay then
            Gameplay = Gameplay:FindFirstChild("Middle");
        end;

        if Gameplay then
            Gameplay = Gameplay:FindFirstChild("TeamSelection");
        end;

        if Gameplay and Gameplay.Visible then
            return false;
        end;
    end;

    local v26 = LocalPlayer:GetAttribute("IsSpectating");
    local v27 = LocalPlayer:GetAttribute("Team");
    local v28 = require(ReplicatedStorage.Database.Components.GameState).GetState();

    if v28 == "Game Ending" or v28 == "Map Voting" then
        if v27 == "Counter-Terrorists" or v27 == "Terrorists" then
            return false;
        end;

        local Character = LocalPlayer.Character;
        local v29;

        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid");
            v29 = Humanoid and Humanoid.Health > 0 and true or false;
        else
            v29 = false;
        end;

        return not v29;
    end;

    if v27 == "Counter-Terrorists" or v27 == "Terrorists" then
        return false;
    end;

    if LocalPlayer.Character then
        return false;
    end;

    local Character = LocalPlayer.Character;
    local v30;

    if Character and Character:IsDescendantOf(workspace) then
        local Humanoid = Character:FindFirstChild("Humanoid");
        v30 = Humanoid and Humanoid.Health > 0 and true or false;
    else
        v30 = false;
    end;

    return not v30 and not v26;
end;

local function attachGlovesToCharacter(p31, p32, p33) -- Line: 341
    -- upvalues: ReplicatedStorage (copy), DataController (copy), LocalPlayer (copy), u5 (copy), AttachGlovesToCharacter (copy)
    local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
    local v34 = nil;
    local v35 = nil;
    local v36 = nil;

    if p33 then
        local v37 = p32 == "CT" and "Counter-Terrorists" or "Terrorists";
        DataController.WaitForDataLoaded(LocalPlayer);
        local v38 = DataController.Get(LocalPlayer, "Loadout");

        if v38 and (type(v38) == "table" and v38[v37]) then
            local v39 = v38[v37];

            if v39 and (type(v39) == "table" and v39.Equipped) then
                local v40 = v39.Equipped["Equipped Gloves"];

                if v40 and (v40 ~= "" and type(v40) == "string") then
                    local v41 = DataController.Get(LocalPlayer, "Inventory");

                    if v41 and type(v41) == "table" then
                        for _, v in ipairs(v41) do
                            if v and v._id == v40 then
                                v34 = v.Name;
                                v35 = v.Skin;
                                v36 = v.Float;
                                p31:SetAttribute("EquippedGloves", game:GetService("HttpService"):JSONEncode({
                                    SkinIdentifier = v40
                                }));
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local v42 = v34 or u5[p32].Glove;
    local v43;

    if v35 and (v36 and v42) then
        v43 = Skins.GetGloves(v42, v35, v36);
    else
        v43 = nil;
    end;

    local v44;

    if v43 then
        v44 = nil;
    else
        v44 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Weapons"):FindFirstChild(v42);

        if not v44 then
            warn((`[MenuSceneController]: Glove folder not found for "{v42}"`));

            return;
        end;
    end;

    local CharacterArmor = p31:FindFirstChild("CharacterArmor");

    if not CharacterArmor then
        CharacterArmor = Instance.new("Folder");
        CharacterArmor.Name = "CharacterArmor";
        CharacterArmor.Parent = p31;
    end;

    local v45;

    if v43 then
        v45 = v43:GetChildren();
    else
        if not v44 then
            warn((`[MenuSceneController]: No glove model or folder available for "{v42}"`));

            return;
        end;

        v45 = v44:GetChildren();
    end;

    AttachGlovesToCharacter(v45, p31, CharacterArmor);

    if v43 and v43.Name == "" then
        v43:Destroy();
    end;
end;

local function attachWeaponToCharacter(p46, p47, p48) -- Line: 438
    -- upvalues: ReplicatedStorage (copy), DataController (copy), LocalPlayer (copy), u5 (copy)
    local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
    local v49 = nil;
    local v50 = nil;
    local v51 = nil;
    local v52 = nil;

    if p48 then
        local v53 = p47 == "CT" and "Counter-Terrorists" or "Terrorists";
        local v54 = p47 == "CT" and "M4A1-S" or "AK-47";
        DataController.WaitForDataLoaded(LocalPlayer);
        local v55 = DataController.Get(LocalPlayer, "Loadout");
        local v56 = DataController.Get(LocalPlayer, "Inventory");

        if v55 and (type(v55) == "table" and v55[v53]) then
            local v57 = v55[v53];

            if v57 and (type(v57) == "table" and v57.Loadout) then
                local Rifles = v57.Loadout.Rifles;

                if Rifles and (Rifles.Options and (type(Rifles.Options) == "table" and (v56 and type(v56) == "table"))) then
                    for _, v in ipairs(Rifles.Options) do
                        if v and (v ~= "" and type(v) == "string") then
                            for _, v2 in ipairs(v56) do
                                if v2 and (v2._id == v and v2.Name == v54) then
                                    v49 = v2.Name;
                                    v50 = v2.Skin;
                                    v51 = v2.Float;
                                    local _ = v2.StatTrack;
                                    v52 = v2.NameTag;
                                    break;
                                end;
                            end;

                            if v49 then
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local v58 = v49 or u5[p47].Weapon;

    if not v58 then
        warn("[MenuSceneController]: No weapon name available");

        return;
    end;

    local v59;

    if v50 and (typeof(v50) == "string" and (v50 ~= "" and v58)) then
        v59 = Skins.GetCharacterModel(v58, v50, v51, nil, v52);
    else
        v59 = nil;
    end;

    local v60 = v59 or Skins.GetBaseWeaponModel(v58, "Character");

    if not v60 then
        warn((`[MenuSceneController]: Failed to get weapon model for "{v58}"`));

        return;
    end;

    v60.Name = v58;
    local RightHand = p46:FindFirstChild("RightHand");

    if RightHand then
        if not v60.PrimaryPart then
            local Weapon = v60:FindFirstChild("Weapon");

            if Weapon then
                Weapon = Weapon:FindFirstChild("Insert");
            end;

            if not Weapon then
                warn("[MenuSceneController]: Weapon model has no PrimaryPart or Insert");
                v60:Destroy();

                return;
            end;

            v60.PrimaryPart = Weapon;
        end;

        for _, descendant in ipairs(v60:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Anchored = false;
                descendant.Massless = true;
            end;
        end;

        v60.Parent = p46;
        local Motor6D = Instance.new("Motor6D");
        Motor6D.Name = "WeaponAttachment";
        Motor6D.Part0 = RightHand;
        Motor6D.Part1 = v60.PrimaryPart;
        Motor6D.Parent = RightHand;

        if v58 == "AK-47" then
            Motor6D.C0 = CFrame.new(-0.251, 0.806, -0.406) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);

            return v60;
        end;

        local Properties = v60:FindFirstChild("Properties");

        if Properties then
            local C0 = Properties:FindFirstChild("C0");

            if C0 then
                Motor6D.C0 = C0.Value;
            end;

            local C1 = Properties:FindFirstChild("C1");

            if C1 then
                Motor6D.C1 = C1.Value;
            end;
        end;

        return v60;
    end;

    warn("[MenuSceneController]: Character missing RightHand");
    v60:Destroy();
end;

local function configureMenuDisplayCharacter(p61) -- Line: 592
    local Humanoid = p61:FindFirstChild("Humanoid");
    local HumanoidRootPart = p61:FindFirstChild("HumanoidRootPart");

    for _, descendant in ipairs(p61:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
        end;
    end;

    if Humanoid then
        Humanoid.AutoRotate = false;
    end;

    if HumanoidRootPart then
        HumanoidRootPart.Anchored = true;
    end;
end;

local function spawnMenuCharacter(p62) -- Line: 617
    -- upvalues: u5 (copy), u4 (copy), Characters (copy), u7 (ref), u8 (ref), u9 (ref), attachWeaponToCharacter (copy), attachGlovesToCharacter (copy), configureMenuDisplayCharacter (copy), u10 (copy), u11 (ref)
    local PlayerPart = p62:FindFirstChild("PlayerPart");

    if not PlayerPart then
        return;
    end;

    local v63 = math.random(1, 2) == 1 and "CT" or "T";
    local v64 = u5[v63];
    local v65 = u4[v63];
    local v66 = Characters:FindFirstChild(v64.Character);

    if not v66 then
        warn((`[MenuSceneController]: Character "{v64.Character}" not found`));

        return;
    end;

    local v67 = v66:Clone();
    v67.Name = "MenuCharacter";
    u7 = v67;
    u8 = v63;
    u9 = attachWeaponToCharacter(v67, v63, true);
    attachGlovesToCharacter(v67, v63, true);
    configureMenuDisplayCharacter(v67);
    v67.Parent = p62;
    v67:PivotTo(PlayerPart.CFrame);
    local Humanoid = v67:FindFirstChild("Humanoid");

    if not Humanoid then
        warn("[MenuSceneController]: Character missing Humanoid");

        return;
    end;

    local v68 = Humanoid:FindFirstChildOfClass("Animator");

    if not v68 then
        v68 = Instance.new("Animator");
        v68.Parent = Humanoid;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = v65.Entrance;
    local Animation2 = Instance.new("Animation");
    Animation2.AnimationId = v65.Idle;
    local v69 = v68:LoadAnimation(Animation);
    local u70 = v68:LoadAnimation(Animation2);
    u10:Add(Animation, "Destroy", "EntranceAnimation");
    u10:Add(Animation2, "Destroy", "IdleAnimation");
    u10:Add(v69, "Stop", "EntranceTrack");
    u10:Add(u70, "Stop", "IdleTrack");
    v69.Priority = Enum.AnimationPriority.Action;
    v69:Play();
    v69.Stopped:Once(function() -- Line: 692
        -- upvalues: u11 (ref), u70 (copy)
        if u11 and u70 then
            u70.Looped = true;
            u70.Priority = Enum.AnimationPriority.Idle;
            u70:Play();
        end;
    end);
    u10:Add(function() -- Line: 701
        -- upvalues: u7 (ref), u8 (ref), u9 (ref)
        if u7 then
            u7:Destroy();
            u7 = nil;
            u8 = nil;
            u9 = nil;
        end;
    end, true, "MenuCharacterCleanup");
end;

local function updateMenuMusicVolume() -- Line: 713
    -- upvalues: u13 (ref), DataController (copy), LocalPlayer (copy), u14 (ref)
    if not (u13 and u13.Parent) then
        return;
    end;

    local v71 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100) / 100;
    local v72 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
    u13.Volume = (u13:GetAttribute("BaseVolume") or u13.Volume) * v71 * v72 * u14;
end;

function u1.ShowMenuScene() -- Line: 728
    -- upvalues: LocalPlayer (copy), u11 (ref), CameraController (copy), ReplicatedStorage (copy), u3 (ref), u6 (ref), applySceneLighting (copy), applyMapLighting (copy), CurrentCamera (copy), u10 (copy), RunServiceController (copy), u1 (copy), spawnMenuCharacter (copy), u13 (ref), DataController (copy), Sound (copy), u12 (ref), PlayerGui (copy), u14 (ref)
    local Character = LocalPlayer.Character;
    local v73;

    if Character and Character:IsDescendantOf(workspace) then
        local Humanoid = Character:FindFirstChild("Humanoid");
        v73 = Humanoid and Humanoid.Health > 0 and true or false;
    else
        v73 = false;
    end;

    if v73 then
        return;
    end;

    if u11 then
        CameraController.updateCameraFOV(50);
        CameraController.setMouseEnabled(true);

        return;
    end;

    if workspace:FindFirstChild("InspectScene") then
        return;
    end;

    local MenuState = require(ReplicatedStorage.Interface.MenuState);

    if MenuState.IsInspectActive() then
        return;
    end;

    if MenuState.IsCaseSceneActive() then
        return;
    end;

    local v74;

    if u3 then
        v74 = u3;
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            u3 = Assets:WaitForChild("MenuScenes", 10);
        end;

        v74 = u3;
    end;

    local v75;

    if v74 then
        local v76 = v74:GetChildren();

        if #v76 > 0 then
            v75 = v76[math.random(1, #v76)];
        else
            v75 = nil;
        end;
    else
        v75 = nil;
    end;

    if not v75 then
        CameraController.setMouseEnabled(true);

        return;
    end;

    local v77 = v75:Clone();
    v77.Parent = workspace;
    u6 = v77;
    applySceneLighting(v75.Name);
    local CamPart = v77:FindFirstChild("CamPart");

    if not CamPart then
        warn("[MenuSceneController]: Menu scene missing CamPart");
        v77:Destroy();
        u6 = nil;
        applyMapLighting();

        return;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CFrame = CamPart.CFrame;
    CurrentCamera.Focus = CamPart.CFrame;
    CameraController.updateCameraFOV(50);
    CameraController.setMouseEnabled(true);
    u10:Add(RunServiceController.BindToRenderStep("MenuSceneController.CameraUpdate", function() -- Line: 795
        -- upvalues: u6 (ref), CamPart (copy), CurrentCamera (ref)
        if u6 and CamPart then
            CurrentCamera.CFrame = CamPart.CFrame;
            CurrentCamera.Focus = CamPart.CFrame;
        end;
    end), "Disconnect", "CameraUpdate");
    u10:Add(function() -- Line: 803
        -- upvalues: u6 (ref)
        if u6 then
            u6:Destroy();
            u6 = nil;
        end;
    end, true, "MenuSceneCleanup");
    u11 = true;
    u10:Add(RunServiceController.BindToHeartbeat("MenuSceneController.AliveGuard", function() -- Line: 813
        -- upvalues: LocalPlayer (ref), u1 (ref)
        local Character2 = LocalPlayer.Character;
        local v78;

        if Character2 and Character2:IsDescendantOf(workspace) then
            local Humanoid = Character2:FindFirstChild("Humanoid");
            v78 = Humanoid and Humanoid.Health > 0 and true or false;
        else
            v78 = false;
        end;

        if v78 then
            u1.HideMenuScene();
        end;
    end), "Disconnect", "AliveGuard");
    spawnMenuCharacter(v77);

    if not (u13 and u13.IsPlaying) then
        local v79 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100) / 100;
        local v80 = Sound.new("Main Menu");
        u12 = v80;
        local u81 = v80:play({
            Name = "Main Menu Music",
            Parent = PlayerGui
        }, v79);
        u13 = u81;

        if u81 then
            local v82 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
            local Volume = u81.Volume;

            if v79 > 0 and v82 > 0 then
                Volume = Volume / (v79 * v82) or Volume;
            end;

            u81:SetAttribute("BaseVolume", Volume);
            u81:SetAttribute("AmbienceVolumeMultiplier", v79);

            if u14 ~= 1 then
                u81.Volume = u81.Volume * u14;
            end;

            u81.Destroying:Once(function() -- Line: 856
                -- upvalues: u13 (ref), u81 (copy)
                if u13 == u81 then
                    u13 = nil;
                end;
            end);
        end;
    end;
end;

function u1.HideMenuScene(p83, p84) -- Line: 867
    -- upvalues: u11 (ref), ReplicatedStorage (copy), u10 (copy), applyMapLighting (copy), CurrentCamera (copy), CameraController (copy), Constants (copy), u13 (ref), u12 (ref)
    if not u11 then
        return;
    end;

    if require(ReplicatedStorage.Interface.MenuState).IsInspectActive() or workspace:FindFirstChild("InspectScene") then
        p84 = true;
        p83 = true;
    end;

    u10:Cleanup();

    if not p84 then
        applyMapLighting();
    end;

    if not p84 then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    end;

    u11 = false;

    if not p83 then
        if u13 then
            u13:Stop();
            u13 = nil;
        end;

        if u12 then
            u12:destroy();
            u12 = nil;
        end;
    end;
end;

function u1.IsActive() -- Line: 914
    -- upvalues: u11 (ref)
    return u11;
end;

function u1.StopMenuMusic() -- Line: 920
    -- upvalues: u13 (ref), u12 (ref)
    if u13 then
        u13:Stop();
        u13 = nil;
    end;

    if u12 then
        u12:destroy();
        u12 = nil;
    end;
end;

function u1.IsMusicPlaying() -- Line: 933
    -- upvalues: u13 (ref)
    local v85;

    if u13 == nil then
        v85 = false;
    else
        v85 = u13.IsPlaying;
    end;

    return v85;
end;

function u1.SetMusicVolumeMultiplier(p86, p87) -- Line: 939
    -- upvalues: u14 (ref), u13 (ref), u15 (ref), DataController (copy), LocalPlayer (copy), TweenService (copy)
    u14 = p86;

    if not u13 then
        return;
    end;

    if u15 then
        u15:Cancel();
        u15 = nil;
    end;

    local v88 = u13:GetAttribute("BaseVolume") or 0.1;
    local v89 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100) / 100;
    local v90 = (DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100;
    local v91 = v88 * v89 * v90 * u14;

    if not p87 or p87 <= 0 then
        u13.Volume = v91;

        return;
    end;

    local v92 = TweenService:Create(u13, TweenInfo.new(p87, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = v91
    });
    u15 = v92;
    v92:Play();
end;

function u1.ApplyMapLighting() -- Line: 973
    -- upvalues: applyMapLighting (copy)
    applyMapLighting();
end;

function u1.ApplyMenuSceneLighting() -- Line: 980
    -- upvalues: u3 (ref), ReplicatedStorage (copy), applySceneLighting (copy), Lighting (copy)
    local v93;

    if u3 then
        v93 = u3;
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            u3 = Assets:WaitForChild("MenuScenes", 10);
        end;

        v93 = u3;
    end;

    local v94;

    if v93 then
        local v95 = v93:GetChildren();

        if #v95 > 0 then
            v94 = v95[math.random(1, #v95)];
        else
            v94 = nil;
        end;
    else
        v94 = nil;
    end;

    if v94 then
        applySceneLighting(v94.Name);
        Lighting.GlobalShadows = true;
    end;
end;

function u1.GetMenuCharacter() -- Line: 991
    -- upvalues: u7 (ref)
    return u7;
end;

function u1.CreateStandaloneCharacter(p96) -- Line: 995
    -- upvalues: u5 (copy), Characters (copy), ReplicatedStorage (copy), attachGlovesToCharacter (copy)
    local v97 = p96 or (math.random(1, 2) == 1 and "CT" or "T");
    local v98 = u5[v97];
    local v99 = Characters:FindFirstChild(v98.Character);

    if not v99 then
        warn((`[MenuSceneController]: Character "{v98.Character}" not found`));

        return nil;
    end;

    local v100 = v99:Clone();
    v100.Name = "StandaloneCharacter";
    v100.Parent = ReplicatedStorage;
    attachGlovesToCharacter(v100, v97, true);

    return v100;
end;

function u1.Initialize() -- Line: 1023
    -- upvalues: DataController (copy), LocalPlayer (copy), Lighting (copy), u16 (ref), updateMenuMusicVolume (copy), shouldShowMenuScene (copy), u1 (copy), u2 (ref), ReplicatedStorage (copy), Observers (copy), u7 (ref), u8 (ref), u9 (ref), attachWeaponToCharacter (copy), attachGlovesToCharacter (copy), configureMenuDisplayCharacter (copy), u10 (copy)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function() -- Line: 1025
        -- upvalues: DataController (ref), LocalPlayer (ref), Lighting (ref), u16 (ref)
        if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
            if u16 ~= nil then
                Lighting.GlobalShadows = u16;
            end;

            return;
        end;

        Lighting.GlobalShadows = false;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume", updateMenuMusicVolume);
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", updateMenuMusicVolume);

    if shouldShowMenuScene() then
        u1.ShowMenuScene();
    end;

    task.defer(function() -- Line: 1038
        -- upvalues: u2 (ref), ReplicatedStorage (ref)
        if not u2 then
            u2 = require(ReplicatedStorage.Controllers.EndScreenController);
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function(p101) -- Line: 1045
        -- upvalues: u1 (ref), shouldShowMenuScene (ref)
        u1.StopMenuMusic();
        u1.HideMenuScene();
        local v102 = p101:FindFirstChildOfClass("Humanoid");

        if not v102 then
            local v103 = tick();

            repeat
                task.wait(0.1);
                v102 = p101:FindFirstChildOfClass("Humanoid");
            until v102 or tick() - v103 > 5;
        end;

        if v102 then
            v102.Died:Connect(function() -- Line: 1061
                -- upvalues: shouldShowMenuScene (ref), u1 (ref)
                task.delay(0.1, function() -- Line: 1063
                    -- upvalues: shouldShowMenuScene (ref), u1 (ref)
                    if shouldShowMenuScene() then
                        u1.ShowMenuScene();
                    end;
                end);
            end);
        end;
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 1073
        -- upvalues: shouldShowMenuScene (ref), u1 (ref)
        task.delay(0.1, function() -- Line: 1075
            -- upvalues: shouldShowMenuScene (ref), u1 (ref)
            if shouldShowMenuScene() then
                u1.ShowMenuScene();
            end;
        end);
    end);
    Observers.observeAttribute(LocalPlayer, "IsSpectating", function(p104) -- Line: 1083
        -- upvalues: u1 (ref), shouldShowMenuScene (ref)
        if p104 then
            u1.HideMenuScene();
        elseif shouldShowMenuScene() then
            u1.ShowMenuScene();
        end;

        return function() -- Line: 1095
            -- upvalues: shouldShowMenuScene (ref), u1 (ref)
            if shouldShowMenuScene() then
                u1.ShowMenuScene();
            end;
        end;
    end);
    Observers.observeAttribute(LocalPlayer, "Team", function(p105) -- Line: 1103
        -- upvalues: u1 (ref), shouldShowMenuScene (ref)
        if p105 == "Counter-Terrorists" or p105 == "Terrorists" then
            u1.HideMenuScene();
        elseif shouldShowMenuScene() then
            u1.ShowMenuScene();
        end;

        return function() -- Line: 1115
            -- upvalues: shouldShowMenuScene (ref), u1 (ref)
            task.delay(0.1, function() -- Line: 1117
                -- upvalues: shouldShowMenuScene (ref), u1 (ref)
                if shouldShowMenuScene() then
                    u1.ShowMenuScene();
                end;
            end);
        end;
    end);

    local function updateMenuCharacterLoadout() -- Line: 1126
        -- upvalues: u7 (ref), u8 (ref), u9 (ref), attachWeaponToCharacter (ref), attachGlovesToCharacter (ref), configureMenuDisplayCharacter (ref)
        if not (u7 and u8) then
            return;
        end;

        if u9 and u9.Parent then
            u9:Destroy();
            u9 = nil;
        end;

        local RightHand = u7:FindFirstChild("RightHand");
        local v106 = RightHand and RightHand:FindFirstChild("WeaponAttachment");

        if v106 then
            v106:Destroy();
        end;

        local CharacterArmor = u7:FindFirstChild("CharacterArmor");

        if CharacterArmor then
            for _, child in ipairs(CharacterArmor:GetChildren()) do
                if child:IsA("BasePart") and child:FindFirstChild("GloveAttachment") then
                    child:Destroy();
                end;
            end;
        end;

        u9 = attachWeaponToCharacter(u7, u8, true);
        attachGlovesToCharacter(u7, u8, true);
        configureMenuDisplayCharacter(u7);
    end;

    local u107 = DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1161
        -- upvalues: updateMenuCharacterLoadout (copy)
        updateMenuCharacterLoadout();
    end);
    u10:Add(function() -- Line: 1165
        -- upvalues: DataController (ref), LocalPlayer (ref), u107 (copy)
        DataController.RemoveListener(LocalPlayer, "Loadout", u107);
    end, true, "LoadoutListener");
    local GameState = require(ReplicatedStorage.Database.Components.GameState);
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
    GameState.ListenToState(function(p108, p109) -- Line: 1172
        -- upvalues: LocalPlayer (ref), SpectateController (copy), shouldShowMenuScene (ref), u1 (ref)
        if p109 == "Game Ending" or p109 == "Map Voting" then
            if LocalPlayer:GetAttribute("IsSpectating") then
                SpectateController.Stop(false, true);
            end;

            if shouldShowMenuScene() then
                u1.ShowMenuScene();
            end;
        end;
    end);
end;

function u1.Start() -- Line: 1188
end;

return u1;