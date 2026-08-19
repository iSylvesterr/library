-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
game:GetService("RunService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local Camera = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera);
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam);
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer);
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local Freecam = require(ReplicatedStorage.Classes.Freecam);
local Bullet = require(ReplicatedStorage.Components.Weapon.Classes.Bullet);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Spring = require(ReplicatedStorage.Shared.Spring);
local Sift = require(ReplicatedStorage.Packages.Sift);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Characters = workspace:WaitForChild("Characters");
local Debris = workspace:WaitForChild("Debris");
local CurrentCamera = workspace.CurrentCamera;
local u2 = RaycastParams.new();
u2.FilterType = Enum.RaycastFilterType.Exclude;
u2.IgnoreWater = true;
local u3 = {
    ["Heavy Swing"] = true,
    BackStab = true,
    Swing1 = true,
    Swing2 = true,
    Inspect = true,
    Reload = true,
    Throw = true,
    Use = true
};
local u4 = {
    StartThrow = true
};
local u5 = {
    NoSuppressorShoot = true,
    ShootRight = true,
    ShootLeft = true,
    Shoot = true,
    SlamFire = true
};

local function isInspectVariantEvent(p6) -- Line: 95
    return p6 == "Inspect" and true or string.match(p6, "^Inspect%d+$") ~= nil;
end;

local function cacheAndHideInstance(p7, p8) -- Line: 99
    if not p8:IsA("BasePart") then
        if p8:IsA("Texture") then
            local Parent = p8.Parent;

            if Parent and Parent:IsA("BasePart") then
                local v9 = p7.Transparencies[Parent] or {
                    Transparency = Parent.Transparency,
                    Textures = {}
                };

                if not table.find(v9.Textures, p8) then
                    table.insert(v9.Textures, p8);
                end;

                p8.Parent = nil;
                p7.Transparencies[Parent] = v9;

                return;
            end;
        elseif p8:IsA("BillboardGui") then
            p8.Enabled = false;
        end;

        return;
    end;

    local v10 = p7.Transparencies[p8] or {
        Transparency = p8.Transparency,
        Textures = {}
    };

    for _, child in p8:GetChildren() do
        if child:IsA("Texture") and not table.find(v10.Textures, child) then
            table.insert(v10.Textures, child);
            child.Parent = nil;
        end;
    end;

    if p8.Transparency < 1 then
        p8.Transparency = 1;
    end;

    p7.Transparencies[p8] = v10;
end;

local function updateSpectatedRevolverFireMode(p11, p12) -- Line: 140
    if not (p11 and p11.Bullet) then
        return;
    end;

    if p11.Properties.ShootingOptions ~= "Revolver" then
        return;
    end;

    local FireModes = p11.Properties.FireModes;

    if FireModes then
        FireModes = p12 == "Secondary" and FireModes.Secondary or FireModes.Primary;
    end;

    p11.Bullet:setSpreadConfig(FireModes and FireModes.Spread or p11.Properties.Spread);
end;

local function clearSpectatedRevolverChargeState(p13) -- Line: 155
    if not p13 then
        return;
    end;

    if p13 and (p13.Bullet and p13.Properties.ShootingOptions == "Revolver") then
        local FireModes = p13.Properties.FireModes;

        if FireModes then
            FireModes = FireModes.Secondary or FireModes.Primary;
        end;

        p13.Bullet:setSpreadConfig(FireModes and FireModes.Spread or p13.Properties.Spread);
    end;

    p13.IsChargeFiring = false;
    p13.ChargeStartTick = 0;
end;

local function syncSpectatedWeaponState(p14, p15) -- Line: 165
    if not p14 then
        return;
    end;

    p14.IsSuppressed = p15.IsSuppressed;
    p14.Rounds = p15.Rounds;
    p14.Capacity = p15.Capacity;
    p14.RechargeStartTime = p15.RechargeStartTime;
end;

local function syncSpectatedRechargeAfterShot(p16) -- Line: 176
    if not (p16 and (p16.Properties and p16.Properties.RechargeTime)) then
        return;
    end;

    local v17 = tonumber(p16.Properties.Rounds) or 0;
    local v18 = (tonumber(p16.Rounds) or v17) - 1;
    p16.Rounds = math.max(v18, 0);
    p16.RechargeStartTime = workspace:GetServerTimeNow();
end;

local function recreateSpectatedShotEffects(p19) -- Line: 188
    -- upvalues: CurrentCamera (copy), Debris (copy), u2 (copy), CreateTracer (copy), CreateZeusBeam (copy), DataController (copy), LocalPlayer (copy), Camera (copy)
    u2.FilterDescendantsInstances = { p19.Player.Character, CurrentCamera, Debris };
    local WeaponComponent2 = p19.WeaponComponent;

    if WeaponComponent2 and WeaponComponent2.Bullet then
        local AimingOptions = WeaponComponent2.Properties.AimingOptions;
        local IsAiming = WeaponComponent2.IsAiming;

        if WeaponComponent2.Bullet._updateShotSpread then
            WeaponComponent2.Bullet:_updateShotSpread(AimingOptions, IsAiming);
        end;
    end;

    local v20 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * p19.WeaponComponent.Properties.Range, u2);
    local v21 = v20 and v20.Distance or p19.WeaponComponent.Properties.Range;
    local MuzzlePart = p19.WeaponComponent.Viewmodel.Model.Interactables:FindFirstChild("MuzzlePart");

    if MuzzlePart then
        CreateTracer(v21, MuzzlePart.Position, CurrentCamera.CFrame.LookVector);

        if p19.WeaponComponent.Properties.MuzzleType == "Zeus x27" then
            CreateZeusBeam(MuzzlePart);
        end;

        if DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false then
            Camera(MuzzlePart, p19.WeaponComponent.Properties.HasSuppressor and p19.CurrentEquipped.IsSuppressed and "Suppressor" or p19.WeaponComponent.Properties.MuzzleType);
        end;
    end;
end;

local function destroySpectatedWeaponComponent(p22) -- Line: 228
    local WeaponComponent2 = p22.WeaponComponent;

    if not WeaponComponent2 then
        return;
    end;

    if WeaponComponent2.Bullet then
        WeaponComponent2.Bullet:destroy();
        WeaponComponent2.Bullet = nil;
    end;

    if WeaponComponent2.Janitor then
        WeaponComponent2.Janitor:Destroy();
    end;

    p22.WeaponComponent = nil;
end;

function u1.UpdateCameraCFrame(p23, p24) -- Line: 249
    -- upvalues: Spring (copy)
    if not (p23.CameraPositionSpring and p23.CameraRotationSpring) then
        p23.CameraRotationSpring = Spring.new(1, 35, p24.LookVector);
        p23.CameraPositionSpring = Spring.new(1, 35, p24.Position);
    end;

    p23.CameraRotationSpring:setGoal(p24.LookVector);
    p23.CameraPositionSpring:setGoal(p24.Position);
end;

function u1.UpdateSuppressorState(p25, p26) -- Line: 263
    local Silencer = p26.Viewmodel.Model:FindFirstChild("Silencer", true);

    if Silencer and p26.Properties.HasSuppressor then
        Silencer.Transparency = p25.CurrentEquipped.IsSuppressed and 0 or 1;
    end;
end;

function u1.UpdateSuppressor(p27) -- Line: 274
    if not (p27.WeaponComponent and p27.WeaponComponent.Viewmodel) then
        return;
    end;

    local Silencer = p27.WeaponComponent.Viewmodel.Model:FindFirstChild("Silencer", true);

    if not Silencer then
        return;
    end;

    local v30 = table.freeze({
        {
            State = false,
            AnimationTrack = p27.WeaponComponent.Viewmodel.Animation:getAnimation("RemoveSuppressor"),

            Event = function(p28) -- Line: 289, Name: Event
                -- upvalues: Silencer (copy)
                return p28:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function() -- Line: 290
                    -- upvalues: Silencer (ref)
                    Silencer.Transparency = 1;
                end);
            end
        },
        {
            State = true,
            AnimationTrack = p27.WeaponComponent.Viewmodel.Animation:getAnimation("AddSuppressor"),

            Event = function(u29) -- Line: 298, Name: Event
                -- upvalues: Silencer (copy)
                return u29:GetPropertyChangedSignal("IsPlaying"):Connect(function() -- Line: 299
                    -- upvalues: u29 (copy), Silencer (ref)
                    if u29.IsPlaying then
                        task.delay(0.016666666666666666, function() -- Line: 301
                            -- upvalues: Silencer (ref)
                            Silencer.Transparency = 0;
                        end);
                    end;
                end);
            end
        }
    });

    for _, v in ipairs(v30) do
        if p27.WeaponComponent and p27.WeaponComponent.Janitor then
            p27.WeaponComponent.Janitor:Add(v.Event(v.AnimationTrack));
            p27.WeaponComponent.Janitor:Add(v.AnimationTrack.Ended:Connect(function() -- Line: 314
                -- upvalues: Silencer (copy), v (copy)
                if Silencer.Transparency < 1 == v.State then
                    Silencer.Transparency = v.State and 0 or 1;
                end;
            end));
        end;
    end;

    p27:UpdateSuppressorState(p27.WeaponComponent);
end;

function u1.Switch(p31, p32) -- Line: 329
    -- upvalues: CurrentCamera (copy), CameraController (copy), Constants (copy), Freecam (copy), Remotes (copy)
    if p31.Humanoid and p31.Humanoid.Health > 0 then
        p31.PerspectiveState = p32;

        if p31.FreecamInstance then
            p31.FreecamInstance:Stop();
            p31.FreecamInstance:Destroy();
            p31.FreecamInstance = nil;
        end;

        if p31.PerspectiveState == "First-Person" then
            p31.TransparencyState = true;
            p31:SetCharacterTransparency(p31.TransparencyState);
            CurrentCamera.CameraType = Enum.CameraType.Scriptable;
            CurrentCamera.CameraSubject = p31.Humanoid;

            if p31.CurrentEquipped then
                p31:SetEquipped(p31.CurrentEquipped, false);
            end;

            p31:UpdateScopeState();
            CameraController.setPerspective(true, false);
        elseif p31.PerspectiveState == "Third-Person" then
            p31.TransparencyState = false;
            p31:SetCharacterTransparency(p31.TransparencyState);
            CurrentCamera.CameraType = Enum.CameraType.Follow;
            CurrentCamera.CameraSubject = p31.Humanoid;
            local v33 = p31.WeaponComponent and p31.WeaponComponent;

            if v33 then
                if v33.Bullet then
                    v33.Bullet:destroy();
                    v33.Bullet = nil;
                end;

                if v33.Janitor then
                    v33.Janitor:Destroy();
                end;

                p31.WeaponComponent = nil;
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
            CameraController.setPerspective(false, false);
        elseif p31.PerspectiveState == "Free-Cam" then
            p31.TransparencyState = false;
            p31:SetCharacterTransparency(p31.TransparencyState);
            local v34 = p31.WeaponComponent and p31.WeaponComponent;

            if v34 then
                if v34.Bullet then
                    v34.Bullet:destroy();
                    v34.Bullet = nil;
                end;

                if v34.Janitor then
                    v34.Janitor:Destroy();
                end;

                p31.WeaponComponent = nil;
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);

            if not p31.FreecamInstance then
                p31.FreecamInstance = p31.Janitor:Add(Freecam.new());
            end;

            if p31.FreecamInstance then
                p31.FreecamInstance:Start();
            end;
        end;

        Remotes.Spectate.SetSpectatePerspective.Send(p31.PerspectiveState);
    end;
end;

function u1.SetEquipped(u35, p36, p37) -- Line: 411
    -- upvalues: WeaponComponent (copy), Bullet (copy)
    local v38 = u35.WeaponComponent and u35.WeaponComponent.Identifier;
    u35.CurrentEquipped = p36;

    if v38 == p36.Identifier then
        local WeaponComponent2 = u35.WeaponComponent;

        if WeaponComponent2 then
            WeaponComponent2.IsSuppressed = p36.IsSuppressed;
            WeaponComponent2.Rounds = p36.Rounds;
            WeaponComponent2.Capacity = p36.Capacity;
            WeaponComponent2.RechargeStartTime = p36.RechargeStartTime;
        end;

        u35:UpdateSuppressorState(u35.WeaponComponent);

        return;
    end;

    if u35.WeaponComponent then
        u35:SetWeaponViewmodelTransparency(false);
        local WeaponComponent2 = u35.WeaponComponent;

        if WeaponComponent2 then
            if WeaponComponent2.Bullet then
                WeaponComponent2.Bullet:destroy();
                WeaponComponent2.Bullet = nil;
            end;

            if WeaponComponent2.Janitor then
                WeaponComponent2.Janitor:Destroy();
            end;

            u35.WeaponComponent = nil;
        end;
    end;

    if u35.CurrentEquipped and u35.PerspectiveState == "First-Person" then
        local success, result = pcall(function() -- Line: 431
            -- upvalues: WeaponComponent (ref), u35 (copy)
            return WeaponComponent.new(u35.Player, u35.CurrentEquipped.Identifier, u35.CurrentEquipped._id, 1, u35.CurrentEquipped.Name, u35.CurrentEquipped.Skin, u35.CurrentEquipped.Float, u35.CurrentEquipped.StatTrack, u35.CurrentEquipped.NameTag, u35.CurrentEquipped.OriginalOwner, u35.CurrentEquipped.Charm, u35.CurrentEquipped.Stickers);
        end);

        if not (success and result) then
            warn((`[Spectate] Failed to create viewmodel for {u35.Player.Name} ({u35.CurrentEquipped.Name} | {u35.CurrentEquipped.Skin}): {tostring(result)}`));
            u35.TransparencyState = false;

            if not pcall(function() -- Line: 457
                -- upvalues: u35 (copy)
                u35:SetCharacterTransparency(false);
            end) then
                warn("[Spectate] Failed to restore character transparency after viewmodel creation failure");
            end;

            u35:Switch("Third-Person");
            u35.CurrentEquippedChanged:Fire(u35.CurrentEquipped);

            return;
        end;

        if result.Properties and result.Properties.Spread then
            local v39 = Bullet.new(result, result.Properties);
            result.Bullet = v39;

            if result.Janitor then
                result.Janitor:Add(v39, "destroy", "SpectateBullet");
            end;
        end;

        if result then
            result.IsSuppressed = p36.IsSuppressed;
            result.Rounds = p36.Rounds;
            result.Capacity = p36.Capacity;
            result.RechargeStartTime = p36.RechargeStartTime;
        end;

        u35.WeaponComponent = result;
        u35.TransparencyState = true;
        u35:SetCharacterTransparency(u35.TransparencyState);

        if u35.WeaponComponent and u35.WeaponComponent.Viewmodel then
            u35.WeaponComponent.Viewmodel:equip(not p37);

            if u35.WeaponComponent.Properties.HasSuppressor then
                u35:UpdateSuppressor();
            end;
        end;

        u35:UpdateScopeState();
    end;

    u35.CurrentEquippedChanged:Fire(u35.CurrentEquipped);
end;

function u1.UpdateScopeState(p40) -- Line: 507
    -- upvalues: CameraController (copy), Constants (copy)
    if p40.PerspectiveState ~= "First-Person" then
        return;
    end;

    if not p40.CurrentEquipped then
        return;
    end;

    local Name = p40.CurrentEquipped.Name;
    local v41 = Name == "AUG" and true or Name == "SG 553";
    local v42 = p40.Player:GetAttribute("ScopeIncrement") or 0;
    local v43 = v42 > 0;

    if Name == "AWP" and true or Name == "SSG 08" then
        if p40.WeaponComponent and (p40.WeaponComponent.Viewmodel and p40.WeaponComponent.Viewmodel.Bobble) then
            local ScopeReticlePart = p40.WeaponComponent.Viewmodel.Bobble.ScopeReticlePart;
            local v44 = ScopeReticlePart and ScopeReticlePart:FindFirstChildOfClass("SurfaceGui");

            if v44 then
                v44.Enabled = false;
            end;
        end;

        if v43 and v42 <= 2 then
            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - ({ 37, 60 })[v42]);

            if p40.WeaponComponent and p40.WeaponComponent.Viewmodel then
                p40:SetWeaponViewmodelTransparency(true);
            end;
        else
            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);

            if p40.WeaponComponent and p40.WeaponComponent.Viewmodel then
                p40:SetWeaponViewmodelTransparency(false);
            end;
        end;
    elseif v41 then
        local v45 = p40.WeaponComponent and p40.WeaponComponent.Viewmodel;

        if v45 then
            if v43 then
                if not v45.Hidden then
                    v45:hide();
                end;

                if v45.Bobble and (v45.Bobble.Scope and v45.Bobble.ScopeReticlePart) then
                    v45:aim();
                end;

                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15);

                return;
            end;

            if v45.Hidden then
                v45:unhide();
            end;

            if v45.Bobble and (v45.Bobble.Scope and v45.Bobble.ScopeReticlePart) then
                v45:unaim();
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
        end;
    else
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);

        if p40.WeaponComponent and p40.WeaponComponent.Viewmodel then
            p40:SetWeaponViewmodelTransparency(false);
        end;
    end;
end;

function u1.SetWeaponViewmodelTransparency(p46, p47) -- Line: 595
    if not (p46.WeaponComponent and (p46.WeaponComponent.Viewmodel and p46.WeaponComponent.Viewmodel.Model)) then
        return;
    end;

    local Model = p46.WeaponComponent.Viewmodel.Model;

    if not p46.WeaponTransparencyCache then
        p46.WeaponTransparencyCache = {};
    end;

    for _, descendant in ipairs(Model:GetDescendants()) do
        if descendant:IsA("BasePart") and (descendant.Name ~= "Right Arm" and (descendant.Name ~= "Left Arm" and (descendant.Name ~= "HumanoidRootPart" and descendant.Name ~= "ViewmodelLight"))) then
            if p47 then
                if not p46.WeaponTransparencyCache[descendant] then
                    p46.WeaponTransparencyCache[descendant] = descendant.Transparency;
                end;

                descendant.Transparency = 1;
            else
                local v48 = p46.WeaponTransparencyCache[descendant];

                if v48 ~= nil then
                    descendant.Transparency = v48;
                    p46.WeaponTransparencyCache[descendant] = nil;
                end;
            end;
        end;
    end;
end;

function u1.HideDebrisWeapons(p49) -- Line: 639
    -- upvalues: Debris (copy), cacheAndHideInstance (copy)
    if not p49.TransparencyState then
        return;
    end;

    local Name = p49.Player.Name;
    local v50 = Debris:FindFirstChild(Name .. "_Weapon");

    if v50 then
        for _, descendant in ipairs(v50:GetDescendants()) do
            cacheAndHideInstance(p49, descendant);
        end;
    end;

    local v51 = Debris:FindFirstChild(Name .. "_WeaponAttachments");

    if v51 then
        for _, descendant in ipairs(v51:GetDescendants()) do
            cacheAndHideInstance(p49, descendant);
        end;
    end;
end;

function u1.SetCharacterTransparency(u52, p53) -- Line: 666
    -- upvalues: cacheAndHideInstance (copy), Janitor (copy), Debris (copy), RemoveFromArray (copy)
    local v54 = u52.Character:GetDescendants();

    local function processDebrisWeapon(p55) -- Line: 670
        -- upvalues: cacheAndHideInstance (ref), u52 (copy)
        for _, descendant in ipairs(p55:GetDescendants()) do
            cacheAndHideInstance(u52, descendant);
        end;

        if u52.TransparencyJanitor then
            u52.TransparencyJanitor:Add(p55.DescendantAdded:Connect(function(p56) -- Line: 677
                -- upvalues: u52 (ref), cacheAndHideInstance (ref)
                if u52.TransparencyState then
                    cacheAndHideInstance(u52, p56);
                end;
            end));
        end;
    end;

    if p53 then
        if not u52.TransparencyJanitor then
            local v57 = u52.Janitor:Add(Janitor.new());
            u52.TransparencyJanitor = v57;
            v57:Add(u52.Character.DescendantAdded:Connect(function(p58) -- Line: 692
                -- upvalues: u52 (copy), cacheAndHideInstance (ref)
                if u52.TransparencyState then
                    cacheAndHideInstance(u52, p58);
                end;
            end));
            v57:Add(Debris.ChildAdded:Connect(function(p59) -- Line: 699
                -- upvalues: u52 (copy), processDebrisWeapon (copy)
                if not u52.TransparencyState then
                    return;
                end;

                local Name = u52.Player.Name;

                if p59.Name == Name .. "_Weapon" or p59.Name == Name .. "_WeaponAttachments" then
                    processDebrisWeapon(p59);
                end;
            end));
        end;

        for _, v in ipairs(v54) do
            cacheAndHideInstance(u52, v);
        end;

        local Name = u52.Player.Name;
        local v60 = Debris:FindFirstChild(Name .. "_Weapon");

        if v60 then
            processDebrisWeapon(v60);
        end;

        local v61 = Debris:FindFirstChild(Name .. "_WeaponAttachments");

        if v61 then
            processDebrisWeapon(v61);
        end;
    else
        if u52.TransparencyJanitor then
            u52.TransparencyJanitor:Destroy();
            u52.TransparencyJanitor = nil;
        end;

        for i, v in pairs(u52.Transparencies) do
            if i and i.Parent then
                i.Transparency = v.Transparency;
                RemoveFromArray(v.Textures, function(p62, p63) -- Line: 739
                    -- upvalues: i (copy)
                    p63.Parent = i;

                    return true;
                end);
            end;
        end;

        for _, v in ipairs(v54) do
            if v:IsA("BillboardGui") then
                v.Enabled = true;
            end;
        end;
    end;
end;

function u1.AddSpectateEvent(p64, p65) -- Line: 757
    -- upvalues: recreateSpectatedShotEffects (copy), u5 (copy), syncSpectatedRechargeAfterShot (copy), u4 (copy), u3 (copy)
    if p64.WeaponComponent and p64.WeaponComponent.Viewmodel then
        local v66 = p64.WeaponComponent.Viewmodel and p64.WeaponComponent.Viewmodel.Animation;
        local WeaponComponent2 = p64.WeaponComponent;

        if p65 == "RevolverChargeStart" then
            if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                local FireModes = WeaponComponent2.Properties.FireModes;

                if FireModes then
                    FireModes = FireModes.Primary;
                end;

                WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
            end;

            WeaponComponent2.IsChargeFiring = true;
            WeaponComponent2.ChargeStartTick = tick();
            v66:stopAnimations();
            v66:play("Shoot");
            v66:play("Idle");

            return;
        end;

        if p65 == "RevolverChargeCancel" then
            if WeaponComponent2 then
                if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                    local FireModes = WeaponComponent2.Properties.FireModes;

                    if FireModes then
                        FireModes = FireModes.Secondary or FireModes.Primary;
                    end;

                    WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
                end;

                WeaponComponent2.IsChargeFiring = false;
                WeaponComponent2.ChargeStartTick = 0;
            end;

            v66:stopAnimations();
            v66:play("Idle");

            return;
        end;

        if p65 == "RevolverChargeRelease" then
            if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                local FireModes = WeaponComponent2.Properties.FireModes;

                if FireModes then
                    FireModes = FireModes.Primary;
                end;

                WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
            end;

            recreateSpectatedShotEffects(p64);

            if not WeaponComponent2 then
                return;
            end;

            if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                local FireModes = WeaponComponent2.Properties.FireModes;

                if FireModes then
                    FireModes = FireModes.Secondary or FireModes.Primary;
                end;

                WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
            end;

            WeaponComponent2.IsChargeFiring = false;
            WeaponComponent2.ChargeStartTick = 0;

            return;
        end;

        if u5[p65] then
            if WeaponComponent2.Properties.ShootingOptions == "Revolver" then
                local v67 = p65 == "SlamFire" and "Secondary" or "Primary";

                if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                    local FireModes = WeaponComponent2.Properties.FireModes;

                    if FireModes then
                        FireModes = v67 == "Secondary" and FireModes.Secondary or FireModes.Primary;
                    end;

                    WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
                end;

                if v67 == "Secondary" then
                    if WeaponComponent2 then
                        if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                            local FireModes = WeaponComponent2.Properties.FireModes;

                            if FireModes then
                                FireModes = FireModes.Secondary or FireModes.Primary;
                            end;

                            WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
                        end;

                        WeaponComponent2.IsChargeFiring = false;
                        WeaponComponent2.ChargeStartTick = 0;
                    end;
                else
                    WeaponComponent2.IsChargeFiring = false;
                    WeaponComponent2.ChargeStartTick = 0;
                end;
            end;

            syncSpectatedRechargeAfterShot(WeaponComponent2);
            local v68 = not v66:getAnimation(p65) and "Shoot" or p65;
            v66:stopAnimations();
            v66:play(v68);
            v66:play("Idle");
            recreateSpectatedShotEffects(p64);

            if WeaponComponent2.Properties.ShootingOptions == "Revolver" and p65 ~= "SlamFire" then
                if not WeaponComponent2 then
                    return;
                end;

                if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Properties.ShootingOptions == "Revolver") then
                    local FireModes = WeaponComponent2.Properties.FireModes;

                    if FireModes then
                        FireModes = FireModes.Secondary or FireModes.Primary;
                    end;

                    WeaponComponent2.Bullet:setSpreadConfig(FireModes and FireModes.Spread or WeaponComponent2.Properties.Spread);
                end;

                WeaponComponent2.IsChargeFiring = false;
                WeaponComponent2.ChargeStartTick = 0;
            end;
        else
            if p65 == "Remove Suppressor" or p65 == "Add Suppressor" then
                v66:stopAnimations();
                v66:play(string.gsub(p65, " ", ""));
                v66:play("Idle");

                return;
            end;

            if p65 == "Cancel Plant" then
                v66:stopAnimations();
                v66:play("Idle");

                return;
            end;

            if p65 == "Switch Fire Mode" then
                v66:stopAnimations();
                v66:play("Switch");
                v66:play("Idle");

                return;
            end;

            if u4[p65] then
                v66:stopAnimations();
                v66:play("StartThrow");
                local v69 = v66:play("ThrowIdle");

                if v69 then
                    v69.Looped = true;
                end;
            else
                if p65 == "CancelThrow" then
                    v66:stopAnimations();
                    v66:play("Idle");

                    return;
                end;

                if u3[p65] or (p65 == "Inspect" or string.match(p65, "^Inspect%d+$") ~= nil) then
                    local v70 = (p65 == "Inspect" and true or string.match(p65, "^Inspect%d+$") ~= nil) and not v66:getAnimation(p65) and "Inspect" or p65;
                    v66:stopAnimations();
                    v66:play(v70);
                    v66:play("Idle");
                end;
            end;
        end;
    end;
end;

local function updateSpectatorAutomaticScope(p71, p72) -- Line: 837
    if p71.PerspectiveState ~= "First-Person" then
        return;
    end;

    if not p71.CurrentEquipped then
        return;
    end;

    local Name = p71.CurrentEquipped.Name;

    if Name ~= "AUG" and Name ~= "SG 553" then
        return;
    end;

    if (p71.Player:GetAttribute("ScopeIncrement") or 0) <= 0 then
        return;
    end;

    if not (p71.WeaponComponent and p71.WeaponComponent.Viewmodel) then
        return;
    end;

    local Viewmodel = p71.WeaponComponent.Viewmodel;

    if not (Viewmodel.Bobble and Viewmodel.Bobble.IsAiming) then
        return;
    end;

    local WeaponComponent2 = p71.WeaponComponent;

    if not (WeaponComponent2 and WeaponComponent2.Bullet) then
        return;
    end;

    local v73 = WeaponComponent2.Bullet:getBaseSpread() or 0;
    local v74 = math.abs(v73 - (p71.LastSpreadValue or 0));
    local v75 = (p71.LastScopeUpdateTime or 0) + p72;

    if v74 < 0.01 and v75 < 0.03333333333333333 then
        p71.LastScopeUpdateTime = v75;

        return;
    end;

    p71.LastScopeUpdateTime = 0;
    p71.LastSpreadValue = v73;
    local ScopeReticlePart = Viewmodel.Bobble.ScopeReticlePart;

    if not ScopeReticlePart then
        return;
    end;

    local ScopeUICache = p71.ScopeUICache;

    if ScopeUICache and ScopeUICache.SurfaceGui == ScopeReticlePart then
        local Crosshair = ScopeUICache.Crosshair;

        if Crosshair and Crosshair.Parent then
            local v76 = math.clamp(v73, 0, 2) * 2;
            Crosshair.Size = UDim2.fromScale(v76 + 2.5, v76 + 2.5);
            Crosshair.Position = UDim2.fromScale(0.5, 0.5);

            return;
        end;

        p71.ScopeUICache = nil;
    end;

    local v77 = ScopeReticlePart:FindFirstChildOfClass("SurfaceGui");

    if not v77 then
        return;
    end;

    local Frame = v77:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    local Frame2 = Frame:FindFirstChild("Frame");

    if not Frame2 then
        return;
    end;

    p71.ScopeUICache = {
        Crosshair = Frame2,
        SurfaceGui = v77,
        Frame = Frame
    };
    local v78 = math.clamp(v73, 0, 2) * 2;
    Frame2.Size = UDim2.fromScale(v78 + 2.5, v78 + 2.5);
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
end;

function u1.Render(p79, p80) -- Line: 960
    -- upvalues: CurrentCamera (copy), updateSpectatorAutomaticScope (copy)
    if p79.PerspectiveState == "Free-Cam" then
        return;
    end;

    if p79.CameraPositionSpring and p79.CameraRotationSpring then
        p79.CameraPositionSpring:update(p80);
        p79.CameraRotationSpring:update(p80);

        if p79.PerspectiveState == "First-Person" then
            CurrentCamera.CFrame = CFrame.lookAt(p79.CameraPositionSpring:getPosition(), p79.CameraPositionSpring:getPosition() + p79.CameraRotationSpring:getPosition());

            if p79.WeaponComponent and p79.WeaponComponent.Viewmodel then
                p79.WeaponComponent.Viewmodel:render(p80);
            end;

            local WeaponComponent2 = p79.WeaponComponent;

            if WeaponComponent2 and (WeaponComponent2.Bullet and WeaponComponent2.Bullet.updateSpread) then
                WeaponComponent2.Bullet:updateSpread(p80);
            end;

            updateSpectatorAutomaticScope(p79, p80);
        end;
    end;
end;

function u1.new(p81, p82, p83) -- Line: 1000
    -- upvalues: u1 (copy), Janitor (copy), Signal (copy), LocalPlayer (copy), HttpService (copy), Remotes (copy), Characters (copy), Sift (copy), CameraController (copy), Constants (copy)
    local u84 = setmetatable({}, u1);
    u84.Janitor = Janitor.new();
    u84.CurrentEquippedChanged = u84.Janitor:Add(Signal.new());
    u84.StopSpectating = u84.Janitor:Add(Signal.new());
    u84.Humanoid = p83;
    u84.Character = p82;
    u84.Player = p81;
    u84.CurrentPlayerTeam = p81:GetAttribute("Team");
    u84.PerspectiveState = "First-Person";
    u84.TransparencyState = true;
    u84.FreecamInstance = nil;
    u84.Transparencies = {};
    u84.TransparencyJanitor = nil;
    u84.WeaponTransparencyCache = {};
    u84.ScopeUICache = nil;
    u84.LastScopeUpdateTime = 0;
    u84.LastSpreadValue = 0;
    u84:SetCharacterTransparency(u84.TransparencyState);
    u84:Switch(u84.PerspectiveState);
    LocalPlayer.ReplicationFocus = u84.Humanoid;
    u84.Janitor:Add(function() -- Line: 1045
        -- upvalues: LocalPlayer (ref)
        LocalPlayer.ReplicationFocus = nil;
    end);

    if u84.Player:GetAttribute("CurrentEquipped") then
        u84:SetEquipped(HttpService:JSONDecode((u84.Player:GetAttribute("CurrentEquipped"))), false);
    end;

    u84.Janitor:Add(u84.Player:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 1055
        -- upvalues: u84 (copy), HttpService (ref)
        local v85 = u84.Player:GetAttribute("CurrentEquipped");

        if v85 then
            u84:SetEquipped(HttpService:JSONDecode(v85), true);
            task.defer(function() -- Line: 1061
                -- upvalues: u84 (ref)
                if u84.TransparencyState and u84.PerspectiveState == "First-Person" then
                    u84:HideDebrisWeapons();
                end;
            end);
        end;
    end));

    if u84.Character:GetAttribute("CameraCFrame") then
        u84:UpdateCameraCFrame((u84.Character:GetAttribute("CameraCFrame")));
    end;

    u84.Janitor:Add(u84.Character:GetAttributeChangedSignal("CameraCFrame"):Connect(function() -- Line: 1075
        -- upvalues: u84 (copy)
        u84:UpdateCameraCFrame((u84.Character:GetAttribute("CameraCFrame")));
    end));

    if u84.Player:GetAttribute("ScopeIncrement") then
        u84:UpdateScopeState();
    end;

    u84.Janitor:Add(u84.Player:GetAttributeChangedSignal("ScopeIncrement"):Connect(function() -- Line: 1085
        -- upvalues: u84 (copy)
        u84:UpdateScopeState();
    end));

    if u84.Humanoid.Health <= 0 then
        task.defer(function() -- Line: 1092
            -- upvalues: u84 (copy)
            u84.StopSpectating:Fire();
        end);
    end;

    u84.Janitor:Add(u84.Humanoid:GetPropertyChangedSignal("Health"):Connect(function() -- Line: 1097
        -- upvalues: u84 (copy)
        if u84.Humanoid and u84.Humanoid.Health <= 0 then
            u84.StopSpectating:Fire();
        end;
    end));

    if u84.Character:GetAttribute("Dead") then
        task.defer(function() -- Line: 1106
            -- upvalues: u84 (copy)
            u84.StopSpectating:Fire();
        end);
    end;

    u84.Janitor:Add(u84.Character:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 1111
        -- upvalues: u84 (copy)
        if u84.Character:GetAttribute("Dead") then
            u84.StopSpectating:Fire();
        end;
    end));
    u84.Janitor:Add(Remotes.UI.UIPlayerKilled.Listen(function(p86) -- Line: 1119
        -- upvalues: u84 (copy)
        local Victim = p86.Victim;

        if Victim and tostring(u84.Player.UserId) == Victim then
            u84.StopSpectating:Fire();
        end;
    end));
    u84.Janitor:Add(u84.Character.AncestryChanged:Connect(function(p87, p88) -- Line: 1128
        -- upvalues: Characters (ref), u84 (copy)
        if not (p88 and p88:IsDescendantOf(Characters)) then
            u84.StopSpectating:Fire();
        end;
    end));
    u84.Janitor:Add(function() -- Line: 1135
        -- upvalues: u84 (copy), Sift (ref), CameraController (ref), Constants (ref)
        u84.TransparencyState = false;

        if Sift.Dictionary.count(u84.Transparencies) > 0 then
            u84:SetCharacterTransparency(u84.TransparencyState);
        end;

        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    end);
    u84.Janitor:Add(function() -- Line: 1146
        -- upvalues: u84 (copy)
        if u84.WeaponComponent then
            local v89 = u84;
            local WeaponComponent2 = v89.WeaponComponent;

            if WeaponComponent2 then
                if WeaponComponent2.Bullet then
                    WeaponComponent2.Bullet:destroy();
                    WeaponComponent2.Bullet = nil;
                end;

                if WeaponComponent2.Janitor then
                    WeaponComponent2.Janitor:Destroy();
                end;

                v89.WeaponComponent = nil;
            end;
        end;

        u84.WeaponTransparencyCache = {};
        u84.LastScopeUpdateTime = 0;
        u84.LastSpreadValue = 0;
        u84.ScopeUICache = nil;
    end);
    u84.Janitor:Add(function() -- Line: 1158
        -- upvalues: u84 (copy)
        if u84.FreecamInstance then
            u84.FreecamInstance:Stop();
            u84.FreecamInstance:Destroy();
            u84.FreecamInstance = nil;
        end;
    end);

    return u84;
end;

function u1.Destroy(p90) -- Line: 1174
    p90.Janitor:Destroy();
end;

return u1;