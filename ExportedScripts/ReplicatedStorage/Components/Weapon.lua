-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Camera = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera);
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam);
local CreateBloodSplatter = require(ReplicatedStorage.Components.Common.VFXLibary.CreateBloodSplatter);
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker);
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact);
local CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer);
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local SoundController = require(ReplicatedStorage.Controllers.SoundController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local HintController = require(ReplicatedStorage.Controllers.HintController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Bullet = require(script.Classes.Bullet);
local CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local Other = Sound.new("Other");
local u2 = { 37, 60 };
local u3 = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 };
local u4 = { Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2 };
local u5 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true;
workspace:GetAttributeChangedSignal("VIPInfiniteAmmoEnabled"):Connect(function() -- Line: 73
    -- upvalues: u5 (ref)
    u5 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true;
end);
local u6 = {};

for _, child in ipairs(ReplicatedStorage.Database.Custom.Weapons:GetChildren()) do
    if child:IsA("ModuleScript") then
        u6[child.Name] = require(child);
    end;
end;

local function isPlayer(p7) -- Line: 93
    -- upvalues: Players (copy)
    if p7 then
        p7 = p7:FindFirstAncestorOfClass("Model");
    end;

    local v8;

    if p7 == nil then
        v8 = false;
    else
        v8 = Players:GetPlayerFromCharacter(p7) ~= nil;
    end;

    return v8;
end;

local function isSniperRifle(p9) -- Line: 100
    return p9 == "SSG 08" and true or p9 == "AWP";
end;

local function isEquippedLocal(p10) -- Line: 106
    return not p10.IsDestroyed and p10.IsEquipped == true;
end;

local function isDamagePredictionEnabled() -- Line: 112
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true;
end;

local function getPressedActionBinding(p11, p12) -- Line: 118
    -- upvalues: InputController (copy)
    local v13 = InputController.getActionKeybinds(p11);

    for _, v in ipairs(v13) do
        if InputController.isBindingPressed(v) then
            return v;
        end;
    end;

    if p12 and #v13 == 0 then
        for _, v in ipairs(p12) do
            if InputController.isBindingPressed(v) then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function getPressedFireBinding() -- Line: 141
    -- upvalues: getPressedActionBinding (copy), u3 (copy)
    return getPressedActionBinding("Fire", u3);
end;

local function getPressedSecondaryFireBinding() -- Line: 145
    -- upvalues: getPressedActionBinding (copy), u4 (copy)
    return getPressedActionBinding("SecondaryFire", u4);
end;

local function isRevolverWeapon(p14) -- Line: 151
    return p14.Properties.ShootingOptions == "Revolver";
end;

local function getRevolverFireMode(p15, p16) -- Line: 157
    local FireModes = p15.Properties.FireModes;

    if FireModes then
        return (p16 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary;
    end;

    return nil;
end;

local function getActiveFireRate(p17, p18) -- Line: 172
    local FireModes = p17.Properties.FireModes;
    local v19;

    if FireModes then
        v19 = (p18 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v19 = nil;
    end;

    return v19 and v19.FireRate or (p17.Properties.FireRate or 0.1);
end;

local function applyActiveSpreadProfile(p20, p21) -- Line: 179
    if not p20.Bullet then
        return;
    end;

    local FireModes = p20.Properties.FireModes;
    local v22;

    if FireModes then
        v22 = (p21 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v22 = nil;
    end;

    p20.Bullet:setSpreadConfig(v22 and v22.Spread or p20.Properties.Spread);
end;

local function buildActiveRecoilPattern(p23, p24) -- Line: 189
    local Recoil = p23.Properties.Recoil;

    if not Recoil then
        return nil;
    end;

    local Properties = p23.Properties;

    if p23.Properties.ShootingOptions == "Revolver" and p24 then
        Properties = table.clone(p23.Properties);
        local FireModes = p23.Properties.FireModes;
        local v25;

        if FireModes then
            v25 = (p24 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary;
        else
            v25 = nil;
        end;

        Properties.FireRate = v25 and v25.FireRate or (p23.Properties.FireRate or 0.1);
    end;

    return Recoil.Pattern(Properties);
end;

local function applyActiveRecoilProfile(p26, p27) -- Line: 204
    -- upvalues: buildActiveRecoilPattern (copy)
    local Recoil = p26.Recoil;

    if not Recoil then
        return;
    end;

    local v28 = p26.Properties.ShootingOptions == "Revolver" and p27 and p27 or "Default";
    local FireModes = p26.Properties.FireModes;
    local v29;

    if FireModes then
        v29 = (p27 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v29 = nil;
    end;

    local v30 = v29 and v29.FireRate or (p26.Properties.FireRate or 0.1);
    local v31 = Recoil.Functions[v28];

    if not v31 then
        v31 = buildActiveRecoilPattern(p26, p27);

        if not v31 then
            return;
        end;

        Recoil.Functions[v28] = v31;
    end;

    local ActiveFireRate = Recoil.ActiveFireRate;

    if ActiveFireRate > 0 and (v30 > 0 and ActiveFireRate ~= v30) then
        Recoil.Time = Recoil.Time / ActiveFireRate * v30;
    end;

    Recoil.Function = v31;
    Recoil.ActiveFireRate = v30;
end;

local function applyActiveWeaponModeProfiles(p32, p33) -- Line: 230
    -- upvalues: applyActiveRecoilProfile (copy)
    if p32.Bullet then
        local FireModes = p32.Properties.FireModes;
        local v34;

        if FireModes then
            v34 = (p33 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary;
        else
            v34 = nil;
        end;

        p32.Bullet:setSpreadConfig(v34 and v34.Spread or p32.Properties.Spread);
    end;

    applyActiveRecoilProfile(p32, p33);
end;

local function applyRevolverRestingWeaponModeProfiles(p35) -- Line: 235
    -- upvalues: applyActiveRecoilProfile (copy)
    if p35.Properties.ShootingOptions ~= "Revolver" then
        return;
    end;

    if p35.Bullet then
        local FireModes = p35.Properties.FireModes;
        local v36;

        if FireModes then
            v36 = FireModes.Secondary or FireModes.Primary;
        else
            v36 = nil;
        end;

        p35.Bullet:setSpreadConfig(v36 and v36.Spread or p35.Properties.Spread);
    end;

    applyActiveRecoilProfile(p35, "Secondary");
end;

local function applyRevolverChargeStartSpread(p37, p38) -- Line: 243
    if not (p37.Bullet and (p38 and p38.ChargeStartSpread)) then
        return;
    end;

    local v39 = p38.Spread or p37.Properties.Spread;

    if not v39 then
        return;
    end;

    p37.Bullet:setBaseSpreadForConfig(p38.ChargeStartSpread, v39);
end;

local function replicateRevolverChargeStartSound(p40) -- Line: 258
    -- upvalues: LocalPlayer (copy), Remotes (copy)
    local v41 = LocalPlayer and LocalPlayer.Character;

    if not (v41 and v41:IsDescendantOf(workspace)) then
        return;
    end;

    local Head = v41:FindFirstChild("Head");

    if not Head then
        return;
    end;

    Remotes.Sound.ReplicateSound.Send({
        Name = "Prepare",
        Parent = Head,
        Class = p40.Name
    });
end;

local function cancelRechargeTimer(p42) -- Line: 278
    if p42.RechargeThread then
        task.cancel(p42.RechargeThread);
        p42.RechargeThread = nil;
    end;
end;

local function startRechargeTimer(u43) -- Line: 285
    -- upvalues: u5 (ref)
    local RechargeTime = u43.Properties.RechargeTime;
    local Rounds = u43.Properties.Rounds;

    if not (RechargeTime and Rounds) then
        return;
    end;

    if u5 then
        if u43.RechargeThread then
            task.cancel(u43.RechargeThread);
            u43.RechargeThread = nil;
        end;

        u43.Rounds = Rounds;
        u43.RechargeStartTime = nil;

        return;
    end;

    if Rounds <= u43.Rounds then
        if u43.RechargeThread then
            task.cancel(u43.RechargeThread);
            u43.RechargeThread = nil;
        end;

        u43.RechargeStartTime = nil;

        return;
    end;

    if u43.RechargeThread then
        task.cancel(u43.RechargeThread);
        u43.RechargeThread = nil;
    end;

    local v44 = workspace:GetServerTimeNow();
    local Identifier = u43.Identifier;
    local v45 = u43.RechargeStartTime or v44;
    local v46 = RechargeTime - math.max(v44 - v45, 0);
    local v47 = math.max(v46, 0);
    u43.RechargeStartTime = v45;

    if v47 > 0 then
        u43.RechargeThread = task.delay(v47, function() -- Line: 321
            -- upvalues: u43 (copy), Identifier (copy), Rounds (copy)
            if u43.IsDestroyed or u43.Identifier ~= Identifier then
                return;
            end;

            u43.RechargeThread = nil;
            u43.Rounds = Rounds;
            u43.RechargeStartTime = nil;
        end);

        return;
    end;

    u43.Rounds = Rounds;
    u43.RechargeStartTime = nil;
end;

local function resolveFireAnimationNames(p48, p49, p50, p51) -- Line: 334
    local FireModes = p48.Properties.FireModes;
    local v52;

    if FireModes then
        v52 = (p51 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v52 = nil;
    end;

    if not v52 then
        return p49, p50;
    end;

    local Animation = v52.Animation;

    if Animation and (p48.Viewmodel and p48.Viewmodel.Animation) then
        if not p48.Viewmodel.Animation:getAnimation(Animation) then
            Animation = p49;
        end;
    else
        Animation = p49;
    end;

    local CharacterAnimation = v52.CharacterAnimation;

    if CharacterAnimation and p48.CharacterAnimator then
        if not p48.CharacterAnimator:getAnimation(CharacterAnimation) then
            CharacterAnimation = p50;
        end;
    else
        CharacterAnimation = p50;
    end;

    return Animation, CharacterAnimation;
end;

local function clearRevolverChargeTracking(p53) -- Line: 372
    if p53.ChargeThread then
        task.cancel(p53.ChargeThread);
        p53.ChargeThread = nil;
    end;

    if p53.ChargeShootConnection and p53.ChargeShootConnection.Connected then
        p53.ChargeShootConnection:Disconnect();
    end;

    p53.ChargeShootConnection = nil;
end;

local function resetRevolverChargeState(p54) -- Line: 386
    if p54.ChargeThread then
        task.cancel(p54.ChargeThread);
        p54.ChargeThread = nil;
    end;

    if p54.ChargeShootConnection and p54.ChargeShootConnection.Connected then
        p54.ChargeShootConnection:Disconnect();
    end;

    p54.ChargeShootConnection = nil;
    p54.HasPendingChargeRequest = false;
    p54.IsChargeFiring = false;
    p54.ChargeStartTick = 0;
    p54.CurrentWalkSpeedOverride = nil;
end;

local function isWeaponFireBlockedByBuyPeriod() -- Line: 397
    -- upvalues: GameState (copy)
    return GameState.GetState() == "Buy Period";
end;

local function stopRevolverChargeAnimation(p55, p56) -- Line: 403
    -- upvalues: resolveFireAnimationNames (copy)
    if not (p55.Viewmodel and (p55.Viewmodel.Animation and p55.CharacterAnimator)) then
        return;
    end;

    local v57, v58 = resolveFireAnimationNames(p55, "Shoot", "Shoot", "Primary");
    p55.Viewmodel.Animation:cancelCrossfade();
    p55.Viewmodel.Animation:stop(v57);
    p55.CharacterAnimator:stop(v58);

    if p56 ~= false and p55.IsEquipped then
        p55.Viewmodel.Animation:play("Idle");
        p55.CharacterAnimator:play("Idle");
    end;
end;

local function completeRevolverChargeShot(p59) -- Line: 423
    -- upvalues: LocalPlayer (copy), GameState (copy), applyActiveRecoilProfile (copy)
    if p59.IsDestroyed then
        return;
    end;

    if not p59.IsEquipped then
        return;
    end;

    if not p59.IsChargeFiring then
        return;
    end;

    local v60 = LocalPlayer and LocalPlayer.Character;
    local v61 = not v60 or v60:GetAttribute("Dead");

    if v61 or (GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true)) then
        p59:cancelRevolverCharge(false, not v61);

        return;
    end;

    p59.CurrentWalkSpeedOverride = nil;

    if p59.Rounds > 0 then
        p59:shoot("Primary");

        return;
    end;

    if p59.ChargeThread then
        task.cancel(p59.ChargeThread);
        p59.ChargeThread = nil;
    end;

    if p59.ChargeShootConnection and p59.ChargeShootConnection.Connected then
        p59.ChargeShootConnection:Disconnect();
    end;

    p59.ChargeShootConnection = nil;
    p59.HasPendingChargeRequest = false;
    p59.IsChargeFiring = false;
    p59.ChargeStartTick = 0;
    p59.CurrentWalkSpeedOverride = nil;

    if p59.Properties.ShootingOptions == "Revolver" then
        if p59.Bullet then
            local FireModes = p59.Properties.FireModes;
            local v62;

            if FireModes then
                v62 = FireModes.Secondary or FireModes.Primary;
            else
                v62 = nil;
            end;

            p59.Bullet:setSpreadConfig(v62 and v62.Spread or p59.Properties.Spread);
        end;

        applyActiveRecoilProfile(p59, "Secondary");
    end;

    p59:reload();
end;

local function kickCamera(p63) -- Line: 458
    -- upvalues: CameraController (copy)
    local Rotation = p63.Rotation;
    local Position = p63.Position;
    local Value = Rotation.RotationDampen.Value;
    local Value2 = Rotation.RotationSpeed.Value;
    local Value3 = Position.PositionDampen.Value;
    local Value4 = Position.PositionSpeed.Value;
    local Value5 = Rotation.RotationX.Value;
    local Value6 = Rotation.RotationY.Value;
    local Value7 = Rotation.RotationZ.Value;
    local v64 = math.abs(Value6) < 0.1 and 25 or math.abs(Value6);
    local v65 = (math.random() * 2 - 1) * v64 * 0.5;
    local v66 = {
        Value = Vector3.new((Value5 < 0.1 and 1 or Value5) * 0.8, v65, Value7 < 0.1 and 1 or Value7),
        Damper = Value >= 5 and 1 or Value,
        Speed = Value2 >= 30 and 25 or Value2
    };
    local v67 = {
        Value = Vector3.new(Position.PositionX.Value, Position.PositionY.Value, Position.PositionZ.Value),
        Damper = Value3 > 2 and 1 or Value3,
        Speed = Value4 > 2 and 1 or Value4
    };
    CameraController.weaponKick(v66, v67);
end;

function u1.isJumping(p68) -- Line: 502
    return false;
end;

function u1.getSpread(p69) -- Line: 509
    local v70 = p69.Bullet:getTrueSpread();

    if p69:isJumping() then
        return v70 + 0;
    end;

    return v70;
end;

function u1.getCrosshairDisplayState(p71) -- Line: 522
    return nil;
end;

function u1.getBaseSpread(p72) -- Line: 528
    local v73 = p72.Bullet:getBaseSpread();

    if p72:isJumping() then
        return v73 + 0;
    end;

    return v73;
end;

function u1.cancelRevolverCharge(p74, p75, p76) -- Line: 540
    -- upvalues: applyActiveRecoilProfile (copy), stopRevolverChargeAnimation (copy), Remotes (copy)
    local IsChargeFiring = p74.IsChargeFiring;

    if p74.ChargeThread then
        task.cancel(p74.ChargeThread);
        p74.ChargeThread = nil;
    end;

    if p74.ChargeShootConnection and p74.ChargeShootConnection.Connected then
        p74.ChargeShootConnection:Disconnect();
    end;

    p74.ChargeShootConnection = nil;
    p74.HasPendingChargeRequest = false;
    p74.IsChargeFiring = false;
    p74.ChargeStartTick = 0;
    p74.CurrentWalkSpeedOverride = nil;

    if p74.Properties.ShootingOptions == "Revolver" then
        if p74.Bullet then
            local FireModes = p74.Properties.FireModes;
            local v77;

            if FireModes then
                v77 = FireModes.Secondary or FireModes.Primary;
            else
                v77 = nil;
            end;

            p74.Bullet:setSpreadConfig(v77 and v77.Spread or p74.Properties.Spread);
        end;

        applyActiveRecoilProfile(p74, "Secondary");
    end;

    if IsChargeFiring then
        stopRevolverChargeAnimation(p74, p76);

        if p76 ~= false and (p74.IsEquipped and not p74.IsDestroyed) then
            Remotes.Spectate.ReplicateSpectateEvent.Send("RevolverChargeCancel");
        end;
    end;

    if p75 ~= true then
        p74.IsFireHeld = false;
        p74.FireInputBinding = nil;
    end;
end;

function u1.startRevolverCharge(u78, p79) -- Line: 560
    -- upvalues: LocalPlayer (copy), GameState (copy), applyActiveRecoilProfile (copy), resolveFireAnimationNames (copy), completeRevolverChargeShot (copy), replicateRevolverChargeStartSound (copy), Remotes (copy)
    if u78.Properties.ShootingOptions ~= "Revolver" then
        return;
    end;

    local FireModes = u78.Properties.FireModes;
    local v80;

    if FireModes then
        v80 = FireModes.Primary;
    else
        v80 = nil;
    end;

    if not v80 or v80.InputBehavior ~= "Charge" then
        return;
    end;

    u78:stopRevolverSecondaryFire();
    local v81 = u78.Viewmodel.Animation:getAnimation("Equip");

    if (v81 and (v81.Length and (v81.Length > 0 and v81.Length * 0.925)) or 0.5) >= tick() - u78.WeaponEquippedTick then
        return;
    end;

    if LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Dead")) then
        return;
    end;

    if GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true) then
        u78.IsFireHeld = false;
        u78.FireInputBinding = nil;
        u78.IsAlternativeFireHeld = false;
        u78.AlternativeFireInputBinding = nil;
        u78.HasPendingChargeRequest = false;

        return;
    end;

    if u78.IsAdjustingSuppressor or (u78.IsReloading or u78.IsChargeFiring) then
        return;
    end;

    if u78.IsShooting then
        local v82 = tick() - u78.ShootRequestTick;
        local FireModes2 = u78.Properties.FireModes;
        local v83;

        if FireModes2 then
            v83 = FireModes2.Primary;
        else
            v83 = nil;
        end;

        if math.max(0, (v83 and v83.FireRate or (u78.Properties.FireRate or 0.1)) - v82) <= 0.15 then
            u78.IsFireHeld = true;
            u78.FireInputBinding = p79;
            u78.HasPendingChargeRequest = true;
        end;

        return;
    end;

    if u78.Rounds <= 0 then
        u78.IsFireHeld = false;
        u78.FireInputBinding = nil;
        u78:reload();

        return;
    end;

    u78.IsFireHeld = true;
    u78.FireInputBinding = p79;
    u78.HasPendingChargeRequest = false;
    u78.IsChargeFiring = true;
    u78.ChargeStartTick = tick();
    u78.CurrentWalkSpeedOverride = v80.HoldWalkSpeed or u78.Properties.WalkSpeed;

    if u78.Bullet then
        local FireModes2 = u78.Properties.FireModes;
        local v84;

        if FireModes2 then
            v84 = FireModes2.Primary;
        else
            v84 = nil;
        end;

        u78.Bullet:setSpreadConfig(v84 and v84.Spread or u78.Properties.Spread);
    end;

    applyActiveRecoilProfile(u78, "Primary");
    local v85 = u78.Bullet and (v80 and v80.ChargeStartSpread) and (v80.Spread or u78.Properties.Spread);

    if v85 then
        u78.Bullet:setBaseSpreadForConfig(v80.ChargeStartSpread, v85);
    end;

    if u78.IsInspecting or u78.IsInspectFadingOut then
        u78:cancelInspect(nil, nil, true);
    end;

    if u78.ChargeThread then
        task.cancel(u78.ChargeThread);
        u78.ChargeThread = nil;
    end;

    if u78.ChargeShootConnection and u78.ChargeShootConnection.Connected then
        u78.ChargeShootConnection:Disconnect();
    end;

    u78.ChargeShootConnection = nil;
    u78:stopAllAnimations();
    local v86, v87 = resolveFireAnimationNames(u78, "Shoot", "Shoot", "Primary");
    local v88 = u78.Viewmodel.Animation:play(v86);

    if v88 then
        v88:AdjustSpeed(1);
        u78.ChargeShootConnection = v88:GetMarkerReachedSignal("Shoot"):Connect(function() -- Line: 639
            -- upvalues: completeRevolverChargeShot (ref), u78 (copy)
            completeRevolverChargeShot(u78);
        end);
    end;

    local v89 = u78.CharacterAnimator:play(v87);

    if v89 then
        v89:AdjustSpeed(1);
    end;

    replicateRevolverChargeStartSound(u78);
    Remotes.Spectate.ReplicateSpectateEvent.Send("RevolverChargeStart");

    if not v88 then
        u78.ChargeThread = task.delay(v80.ChargeTime or 0, function() -- Line: 654
            -- upvalues: completeRevolverChargeShot (ref), u78 (copy)
            completeRevolverChargeShot(u78);
        end);
    end;
end;

function u1.startRevolverSecondaryFire(p90, p91) -- Line: 662
    -- upvalues: GameState (copy), LocalPlayer (copy), applyActiveRecoilProfile (copy)
    if p90.Properties.ShootingOptions ~= "Revolver" then
        return;
    end;

    if GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true) then
        p90.IsFireHeld = false;
        p90.FireInputBinding = nil;
        p90.IsAlternativeFireHeld = false;
        p90.AlternativeFireInputBinding = nil;
        p90.HasPendingChargeRequest = false;

        return;
    end;

    p90:cancelRevolverCharge(false, false);
    p90.IsAlternativeFireHeld = true;
    p90.AlternativeFireInputBinding = p91;

    if p90.Bullet then
        local FireModes = p90.Properties.FireModes;
        local v92;

        if FireModes then
            v92 = FireModes.Secondary or FireModes.Primary;
        else
            v92 = nil;
        end;

        p90.Bullet:setSpreadConfig(v92 and v92.Spread or p90.Properties.Spread);
    end;

    applyActiveRecoilProfile(p90, "Secondary");

    if p90.IsShooting or (p90.IsReloading or p90.IsAdjustingSuppressor) then
        return;
    end;

    if p90.Rounds > 0 then
        p90:shoot("Secondary");

        return;
    end;

    p90:reload();
end;

function u1.stopRevolverSecondaryFire(p93) -- Line: 698
    -- upvalues: applyActiveRecoilProfile (copy)
    p93.IsAlternativeFireHeld = false;
    p93.AlternativeFireInputBinding = nil;

    if not p93.IsChargeFiring then
        if p93.Properties.ShootingOptions ~= "Revolver" then
            return;
        end;

        if p93.Bullet then
            local FireModes = p93.Properties.FireModes;
            local v94;

            if FireModes then
                v94 = FireModes.Secondary or FireModes.Primary;
            else
                v94 = nil;
            end;

            p93.Bullet:setSpreadConfig(v94 and v94.Spread or p93.Properties.Spread);
        end;

        applyActiveRecoilProfile(p93, "Secondary");
    end;
end;

function u1.stopAllAnimations(p95) -- Line: 708
    if not p95.CharacterAnimator then
        return;
    end;

    if not (p95.Viewmodel and p95.Viewmodel.Animation) then
        return;
    end;

    p95.Viewmodel.Animation:cancelCrossfade();

    for i, v in pairs(p95.CharacterAnimator.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p95.CharacterAnimator:stop(i);
        end;
    end;

    for i, v in pairs(p95.Viewmodel.Animation.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p95.Viewmodel.Animation:stop(i);
        end;
    end;
end;

function u1.removeSuppressor(p96) -- Line: 735
    -- upvalues: Remotes (copy)
    if tick() - p96.WeaponEquippedTick <= 1 then
        return;
    end;

    if p96.IsAdjustingSuppressor or (p96.IsShooting or (p96.IsReloading or p96.IsAiming)) then
        return;
    end;

    p96.IsAdjustingSuppressor = true;
    p96.IsBurstShooting = false;
    p96.IsInspecting = false;
    p96.IsReloading = false;
    p96.IsShooting = false;
    p96.IsAiming = false;
    p96.ScopeStartTick = 0;
    p96:stopAllAnimations();
    p96.Viewmodel.Animation:play("RemoveSuppressor");
    p96.CharacterAnimator:play("RemoveSuppressor");
    Remotes.Spectate.ReplicateSpectateEvent.Send("Remove Suppressor");
end;

function u1.addSuppressor(p97) -- Line: 760
    -- upvalues: Remotes (copy)
    if tick() - p97.WeaponEquippedTick <= 1 then
        return;
    end;

    if p97.IsAdjustingSuppressor or (p97.IsShooting or (p97.IsReloading or p97.IsAiming)) then
        return;
    end;

    p97.IsAdjustingSuppressor = true;
    p97.IsBurstShooting = false;
    p97.IsInspecting = false;
    p97.IsReloading = false;
    p97.IsShooting = false;
    p97.IsAiming = false;
    p97:stopAllAnimations();
    p97.Viewmodel.Animation:play("AddSuppressor");
    p97.CharacterAnimator:play("AddSuppressor");
    Remotes.Spectate.ReplicateSpectateEvent.Send("Add Suppressor");
end;

function u1.scope(p98, p99) -- Line: 787
    -- upvalues: Other (copy), LocalPlayer (copy), CameraController (copy), Constants (copy), u2 (copy), Remotes (copy)
    if not p98.Viewmodel then
        return;
    end;

    if tick() - p98.WeaponEquippedTick <= 1 then
        return;
    end;

    if p98.IsAdjustingSuppressor or (p98.IsReloading or p98.IsShooting and p98.Properties.AimingOptions ~= "AutomaticScope") then
        return;
    end;

    if p98.IsDestroyed then
        return;
    end;

    if p98.Properties.HasScope then
        if not p98.IsAiming then
            p98:stopAllAnimations();
        end;

        p98.IsBurstShooting = false;
        p98.IsInspecting = false;
        p98.IsReloading = false;
        p98.IsShooting = false;

        if not p98.IsAiming then
            p98.ScopeStartTick = tick();
        end;

        p98.IsAiming = true;
        local Name = p98.Name;

        if Name == "SSG 08" and true or Name == "AWP" then
            p98.IsSniperScoped = true;

            if p98.Name == "AWP" and p98.Player then
                p98.Player:SetAttribute("IsSniperScoped", true);
            end;
        end;

        if p98.Properties.AimingOptions == "SniperScope" then
            if not p98.Viewmodel.Hidden then
                p98.Viewmodel:hide();
            end;

            Other:play({
                Name = "Toggle Scope",
                Parent = LocalPlayer.PlayerGui
            });

            if not p99 then
                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - u2[1]);
                Remotes.Inventory.UpdateScopeIncrement.Send(1);

                return;
            end;

            p98.CurrentScopeIncrement = p98.CurrentScopeIncrement + 1;

            if p98.CurrentScopeIncrement >= 3 then
                p98:unscope();

                return;
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - u2[p98.CurrentScopeIncrement]);
            Remotes.Inventory.UpdateScopeIncrement.Send(p98.CurrentScopeIncrement);

            return;
        end;

        if p98.Properties.AimingOptions == "AutomaticScope" then
            if p98.CurrentScopeIncrement == 1 then
                p98:unscope();

                return;
            end;

            p98.CurrentScopeIncrement = 1;

            if not p98.Viewmodel.Hidden then
                p98.Viewmodel:hide();
            end;

            p98.Viewmodel:aim();
            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * p98.CurrentScopeIncrement);
            Remotes.Inventory.UpdateScopeIncrement.Send(p98.CurrentScopeIncrement);
            Other:play({
                Name = "Scope In",
                Parent = LocalPlayer.PlayerGui
            });
        end;
    end;
end;

function u1.unscope(p100, p101) -- Line: 914
    -- upvalues: Remotes (copy), ReplicatedStorage (copy), CameraController (copy), Constants (copy), Other (copy), LocalPlayer (copy)
    if tick() - p100.WeaponEquippedTick <= 1 then
        return;
    end;

    if p100.IsAdjustingSuppressor then
        return;
    end;

    if tick() - p100.WeaponEquippedTick <= 1 then
        return;
    end;

    if p100.Properties.HasScope then
        if p100.IsAiming then
            p100:stopAllAnimations();
        end;

        if p100.CurrentScopeIncrement > 0 or p100.IsAiming then
            Remotes.Inventory.UpdateScopeIncrement.Send(0);
        end;

        if not p101 then
            p100.CurrentScopeIncrement = 0;
        end;

        p100.IsInspecting = false;
        p100.IsReloading = false;
        p100.IsAiming = false;
        p100.ScopeStartTick = 0;
        local Name = p100.Name;

        if Name == "SSG 08" and true or Name == "AWP" then
            p100.IsSniperScoped = false;

            if p100.Name == "AWP" and p100.Player then
                p100.Player:SetAttribute("IsSniperScoped", false);
            end;
        end;

        if p100.Properties.AimingOptions == "SniperScope" then
            if p100.Viewmodel.Hidden then
                p100.Viewmodel:unhide();
            end;

            local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
            local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

            if not (CaseSceneController.IsActive() or MenuSceneController.IsActive()) then
                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
            end;

            if p101 then
                p100.CurrentScopeIncrement = math.clamp(p100.CurrentScopeIncrement - 1, 0, 3);
            end;
        elseif p100.Properties.AimingOptions == "AutomaticScope" then
            p100.CurrentScopeIncrement = 0;
            p100.Viewmodel:unaim();

            if p100.Viewmodel.Hidden then
                p100.Viewmodel:unhide();
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV - 15 * p100.CurrentScopeIncrement);
            Other:play({
                Name = "Scope Out",
                Parent = LocalPlayer.PlayerGui
            });
        end;
    end;
end;

function u1.cancelInspect(u102, p103, p104, p105) -- Line: 1004
    if not (u102.IsInspecting or u102.IsInspectFadingOut) then
        return;
    end;

    if u102.InspectDelayThread then
        task.cancel(u102.InspectDelayThread);
        u102.InspectDelayThread = nil;
    end;

    if u102.CancelDelayThread then
        task.cancel(u102.CancelDelayThread);
        u102.CancelDelayThread = nil;
    end;

    if u102.FadeCompleteThread then
        task.cancel(u102.FadeCompleteThread);
        u102.FadeCompleteThread = nil;
    end;

    if p105 then
        u102.IsInspecting = false;
        u102.IsInspectFadingOut = false;
        u102.Viewmodel.Animation:markInspectCancel();
        u102.Viewmodel.Animation:cancelCrossfade();

        return;
    end;

    local u106 = p103 or 0.25;
    u102.IsInspectFadingOut = true;
    u102.IsInspecting = false;
    u102.Viewmodel.Animation:markInspectCancel();
    u102.CancelDelayThread = task.delay(p104 or 0.3, function() -- Line: 1051
        -- upvalues: u102 (copy), u106 (copy)
        if u102.IsDestroyed then
            return;
        end;

        if not u102.IsInspectFadingOut then
            return;
        end;

        u102.Viewmodel.Animation:crossfadeTo("Idle", u106);
        u102.FadeCompleteThread = task.delay(u106, function() -- Line: 1065
            -- upvalues: u102 (ref)
            if not u102.IsDestroyed then
                u102.FadeCompleteThread = nil;
                u102.IsInspectFadingOut = false;
            end;
        end);
    end);
end;

function u1.inspect(u107) -- Line: 1076
    -- upvalues: Remotes (copy)
    if tick() - u107.WeaponEquippedTick <= 1 then
        return;
    end;

    if u107.IsChargeFiring then
        u107:cancelRevolverCharge(false, false);
    end;

    u107:stopRevolverSecondaryFire();

    if u107.IsAdjustingSuppressor or (u107.IsShooting or (u107.IsReloading or u107.IsAiming)) then
        return;
    end;

    if u107.IsInspecting and not u107.IsInspectFadingOut then
        return;
    end;

    local v108 = u107.IsInspectFadingOut == true;

    if v108 then
        u107.IsInspectFadingOut = false;

        if u107.CancelDelayThread then
            task.cancel(u107.CancelDelayThread);
            u107.CancelDelayThread = nil;
        end;

        if u107.FadeCompleteThread then
            task.cancel(u107.FadeCompleteThread);
            u107.FadeCompleteThread = nil;
        end;

        u107.Viewmodel.Animation:cancelCrossfade();
    end;

    u107.IsBurstShooting = false;
    u107.IsInspecting = true;
    u107.IsReloading = false;
    u107.IsShooting = false;
    u107.ScopeStartTick = 0;
    u107.IsAiming = false;

    if u107.InspectDelayThread then
        task.cancel(u107.InspectDelayThread);
        u107.InspectDelayThread = nil;
    end;

    local v109 = u107.Viewmodel.Animation:pickInspectVariant();

    if v108 then
        if not u107.Viewmodel.Animation:crossfadeRestart(v109, 0.25) then
            u107:stopAllAnimations();
            u107.Viewmodel.Animation:play(v109);
        end;

        Remotes.Spectate.ReplicateSpectateEvent.Send(v109);
        local v110 = u107.Viewmodel.Animation:getAnimation(v109);

        if v110 then
            u107.InspectDelayThread = task.delay(v110.Length, function() -- Line: 1144
                -- upvalues: u107 (copy)
                if not u107.IsDestroyed then
                    u107.InspectDelayThread = nil;
                    u107.IsInspecting = false;
                end;
            end);
        end;

        return;
    end;

    u107:stopAllAnimations();
    local v111 = u107.Viewmodel.Animation:play(v109);
    Remotes.Spectate.ReplicateSpectateEvent.Send(v109);
    u107.InspectDelayThread = task.delay(v111.Length, function() -- Line: 1163
        -- upvalues: u107 (copy)
        if not u107.IsDestroyed then
            u107.InspectDelayThread = nil;
            u107.IsInspecting = false;
        end;
    end);
end;

function u1.updateFireMode(p112) -- Line: 1173
    -- upvalues: Other (copy), LocalPlayer (copy), Remotes (copy), Router (copy)
    if tick() - p112.WeaponEquippedTick <= 1 then
        return;
    end;

    if p112.IsShooting or (p112.IsReloading or (p112.IsBurstShooting or p112.IsChargeFiring)) then
        return;
    end;

    Other:play({
        Name = "Switch Fire Mode",
        Parent = LocalPlayer.PlayerGui
    });
    p112:stopAllAnimations();
    p112.Viewmodel.Animation:play("Switch");
    p112.AlternativeSwitchTick = tick();
    p112.AlternativeShootingOption = p112.AlternativeShootingOption == "Burst" and "Default" or "Burst";
    Remotes.Spectate.ReplicateSpectateEvent.Send("Switch Fire Mode");
    local v113 = p112.Properties.Automatic and "Switched to automatic" or "Switched to semi-automatic";
    Router.broadcastRouter("CreateNotification", "Switched Fire Mode", p112.AlternativeShootingOption == "Default" and v113 and v113 or "Switched to burst-fire mode", 2.5);
end;

function u1.drop(p114) -- Line: 1219
    -- upvalues: GameState (copy), Remotes (copy), GetCharacterVelocity (copy), LocalPlayer (copy), CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false;
    end;

    if GameState.GetState() == "Warmup" then
        return false;
    end;

    if not p114.Properties.Droppable then
        return false;
    end;

    p114:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(LocalPlayer.Character),
        Direction = CurrentCamera.CFrame.LookVector,
        Identifier = p114.Identifier
    });

    return true;
end;

function u1.reload(u115) -- Line: 1247
    -- upvalues: Other (copy), LocalPlayer (copy), HttpService (copy), Remotes (copy), HintController (copy)
    local u116;

    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        u116 = u115.Properties.ReloadAnimationCount == 1;
    else
        u116 = false;
    end;

    if tick() - u115.WeaponEquippedTick <= 1 then
        return;
    end;

    if u115.IsChargeFiring then
        u115:cancelRevolverCharge(false, false);
    end;

    u115:stopRevolverSecondaryFire();

    if u115.IsAdjustingSuppressor or (u115.IsReloading or u115.IsShooting) then
        return;
    end;

    if u115.Properties.Rounds == u115.Rounds then
        if u115.IsInspecting or u115.IsInspectFadingOut then
            u115:cancelInspect(0.25);
        end;

        return;
    end;

    if u115.Properties.RechargeTime then
        if u115.IsInspecting or u115.IsInspectFadingOut then
            u115:cancelInspect(0.25);
        end;

        return;
    end;

    if u115.Capacity <= 0 and not u116 then
        if u115.IsInspecting or u115.IsInspectFadingOut then
            u115:cancelInspect(0.25);
        end;

        return Other:play({
            Name = "No Ammo",
            Parent = LocalPlayer.PlayerGui
        });
    end;

    if u115.IsAiming then
        u115:unscope();
    end;

    if not (u115.Properties.Rounds and u115.Properties.ReloadAnimationCount) then
        return;
    end;

    if u115.IsInspecting or u115.IsInspectFadingOut then
        u115:cancelInspect(nil, nil, true);
    end;

    u115:stopAllAnimations();
    u115.ReloadStartTick = tick();
    u115.IsBurstShooting = false;
    u115.IsInspecting = false;
    u115.IsReloading = true;
    u115.IsShooting = false;
    u115.CurrentWalkSpeedOverride = nil;

    if u115.Properties.ReloadAnimationCount > 1 then
        local u117 = u115.Properties.Rounds / u115.Properties.ReloadAnimationCount;
        local v118 = u115.Viewmodel.Animation:play("ReloadStart");
        task.wait(v118.Length * 0.75);

        for _ = 1, math.ceil(u115.Properties.Rounds - u115.Rounds / u117) do
            if not u115.IsReloading then
                break;
            end;

            local v119 = u115.Viewmodel.Animation:play("ReloadAction");

            if not v119 then
                error((`Client failed to fetch reload animation for {u115.Name}.`));
            end;

            local u120 = HttpService:GenerateGUID(false);
            u115.CurrentReloadIdentity = u120;
            u115.CharacterAnimator:play("Reload");
            Remotes.Spectate.ReplicateSpectateEvent.Send("Reload");
            v119:GetMarkerReachedSignal("MagOut"):Once(function() -- Line: 1338
                -- upvalues: Remotes (ref), u115 (copy)
                Remotes.Inventory.CreateMagazine.Send(u115.Identifier);
            end);
            v119:GetMarkerReachedSignal("MagIn"):Once(function() -- Line: 1342
                -- upvalues: u115 (copy), u117 (copy), u120 (copy), Remotes (ref)
                local v121 = u115;

                if not v121.IsDestroyed and v121.IsEquipped == true then
                    local v122 = math.clamp(u117, 0, u115.Capacity);

                    if u115.CurrentReloadIdentity == u120 and v122 <= u115.Capacity then
                        Remotes.Inventory.ReloadWeapon.Send({
                            Identifier = u115.Identifier,
                            Capacity = u115.Capacity,
                            Rounds = u115.Rounds
                        });
                        u115.Rounds = u115.Rounds + v122;

                        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                            u115.Capacity = u115.Capacity - v122;
                        end;
                    end;
                end;
            end);
            task.wait(v119.Length);
        end;

        if u115.IsReloading then
            u115.Viewmodel.Animation:play("ReloadEnd").Ended:Once(function() -- Line: 1372
                -- upvalues: u115 (copy)
                u115.IsReloading = false;
            end);
        end;
    else
        local u123 = HttpService:GenerateGUID(false);
        u115.CurrentReloadIdentity = u123;
        local u124 = u115.Viewmodel.Animation:play("Reload");
        local v125 = `Client failed to fetch reload animation for {u115.Name}.`;
        assert(u124, v125);

        if u124 then
            u115.CharacterAnimator:play("Reload");
            Remotes.Spectate.ReplicateSpectateEvent.Send("Reload");
            u124:GetMarkerReachedSignal("MagOut"):Once(function() -- Line: 1390
                -- upvalues: Remotes (ref), u115 (copy)
                Remotes.Inventory.CreateMagazine.Send(u115.Identifier);
            end);
            u124:GetMarkerReachedSignal("MagIn"):Once(function() -- Line: 1394
                -- upvalues: u115 (copy), u123 (copy), Remotes (ref), HintController (ref), u116 (copy)
                local v126 = u115;

                if not v126.IsDestroyed and v126.IsEquipped == true then
                    local v127 = math.abs(u115.Properties.Rounds - u115.Rounds);

                    if u115.CurrentReloadIdentity == u123 then
                        Remotes.Inventory.ReloadWeapon.Send({
                            Identifier = u115.Identifier,
                            Rounds = u115.Rounds,
                            Capacity = u115.Capacity
                        });
                        HintController:clearHint("Reload");

                        if u116 then
                            u115.Rounds = u115.Properties.Rounds;
                            u115.Capacity = u115.Properties.Capacity;

                            return;
                        end;

                        if u115.Capacity - v127 > 0 then
                            u115.Rounds = u115.Properties.Rounds;

                            if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                                u115.Capacity = math.max(0, u115.Capacity - v127);
                            end;
                        elseif u115.Capacity - v127 <= 0 then
                            u115.Rounds = u115.Rounds + u115.Capacity;
                            u115.Capacity = 0;
                        end;
                    end;
                end;
            end);

            if u115.ReloadTrackFinishedConnection and u115.ReloadTrackFinishedConnection.Connected then
                u115.ReloadTrackFinishedConnection:Disconnect();
            end;

            u115.ReloadTrackFinishedConnection = u124:GetPropertyChangedSignal("IsPlaying"):Connect(function() -- Line: 1429
                -- upvalues: u115 (copy), u124 (copy)
                if u115.IsDestroyed then
                    return;
                end;

                if not u124.IsPlaying and u115.WeaponEquippedTick < u115.ReloadStartTick then
                    u115.IsReloading = false;
                end;

                if u115.ReloadTrackFinishedConnection and u115.ReloadTrackFinishedConnection.Connected then
                    u115.ReloadTrackFinishedConnection:Disconnect();
                end;

                u115.ReloadTrackFinishedConnection = nil;
            end);
        end;
    end;

    return nil;
end;

function u1.shoot(u128, p129) -- Line: 1452
    -- upvalues: LocalPlayer (copy), GameState (copy), u1 (ref), u6 (copy), Other (copy), CameraController (copy), u5 (ref), resolveFireAnimationNames (copy), startRechargeTimer (copy), SoundController (copy), Router (copy), applyActiveRecoilProfile (copy), Remotes (copy), DataController (copy), CreateZeusBeam (copy), Camera (copy), CreateTracer (copy), Players (copy), CreateImpact (copy), CreateBloodSplatter (copy), BreakGlass (copy), CreateMarker (copy), kickCamera (copy), HapticsController (copy), InputController (copy)
    local v130 = p129 or "Primary";
    local FireModes = u128.Properties.FireModes;
    local v131;

    if FireModes then
        v131 = (v130 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary;
    else
        v131 = nil;
    end;

    local u132 = v131 and v131.FireRate or (u128.Properties.FireRate or 0.1);
    local v133 = u128.Properties.ShootingOptions == "Revolver";

    if v133 then
        if v130 == "Primary" then
            v133 = u128.IsChargeFiring;
        else
            v133 = false;
        end;
    end;

    local v134 = u128.Viewmodel.Animation:getAnimation("Equip");

    if LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true then
        u128.IsFireHeld = false;
        u128.FireInputBinding = nil;
        u128.IsAlternativeFireHeld = false;
        u128.AlternativeFireInputBinding = nil;
        u128.HasPendingChargeRequest = false;

        if u128.IsChargeFiring then
            u128:cancelRevolverCharge(false, false);
        end;

        return;
    end;

    if tick() - u128.WeaponEquippedTick <= v134.Length * 0.925 or LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Dead")) then
        return;
    end;

    if GameState.GetState() == "Buy Period" then
        return;
    end;

    if pcall(function() -- Line: 1484
        -- upvalues: u128 (copy)
        local Properties = u128.Properties;
        Properties.FireRate = Properties.FireRate + 1e-7;
    end) then
        u1 = {};

        while true do

        end;
    end;

    if u6 and u6[u128.Name] then
        local v135 = u6[u128.Name];

        if u128.Properties.FireRate < v135.FireRate or (u128.Properties.BulletsPerShot > v135.BulletsPerShot or (u128.Properties.Range > v135.Range or u128.Properties.Penetration > v135.Penetration)) then
            u1 = {};

            while true do

            end;
        end;
    end;

    if not (u128.Properties.FireRate and u128.Properties.BulletsPerShot) then
        return;
    end;

    if u128.IsAdjustingSuppressor then
        return;
    end;

    if u128.IsReloading and u128.Properties.MuzzleType ~= "ShotGun" then
        return;
    end;

    local v136 = u128.Player and u128.Player.Character;

    if not v136 then
        return;
    end;

    if not u128.CharacterAnimator then
        return;
    end;

    if u128.AlternativeShootingOption ~= "Burst" then
        u128.ShootRequestTick = tick();
    end;

    if u128.IsShooting and u128.AlternativeShootingOption == "Default" then
        return;
    end;

    local Interactables = u128.Viewmodel.Model:FindFirstChild("Interactables");

    if not Interactables then
        return;
    end;

    if u128.Rounds <= 0 then
        u128:reload();

        return;
    end;

    local Rounds = u128.Properties.Rounds;

    if Rounds and u128.Rounds <= Rounds * 0.2 then
        Other:play({
            Name = "Low Ammo Fire",
            Parent = LocalPlayer.PlayerGui
        });
    end;

    local v137 = u128.IsAiming and u128.Properties.AimingOptions == "AutomaticScope" and "AimShoot" or "Shoot";
    local v138 = u128.Properties.HasSuppressor and not u128.IsSuppressed and "NoSuppressorShoot" or "Shoot";
    CameraController.toWeaponFirePosition();

    if not v133 and (u128.IsInspecting or u128.IsInspectFadingOut) then
        u128:cancelInspect(nil, nil, true);
    end;

    if not v133 then
        u128:stopAllAnimations();
    end;

    u128.CurrentReloadIdentity = nil;
    u128.IsInspecting = false;
    u128.IsInspectFadingOut = false;
    u128.IsReloading = false;
    u128.IsShooting = true;

    if u128.ChargeThread then
        task.cancel(u128.ChargeThread);
        u128.ChargeThread = nil;
    end;

    if u128.ChargeShootConnection and u128.ChargeShootConnection.Connected then
        u128.ChargeShootConnection:Disconnect();
    end;

    u128.ChargeShootConnection = nil;
    u128.HasPendingChargeRequest = false;
    u128.IsChargeFiring = false;
    u128.ChargeStartTick = 0;
    u128.CurrentWalkSpeedOverride = nil;

    if not u5 then
        u128.Rounds = u128.Rounds - 1;
    end;

    u128.RechargeStartTime = workspace:GetServerTimeNow();

    if u128.Properties.ShootingOptions == "Dual" then
        u128.ShootingHand = u128.ShootingHand == "Left" and "Right" or "Left";
        v137 = "Shoot" .. u128.ShootingHand;
        v138 = "Shoot" .. u128.ShootingHand;
    end;

    local v139, v140 = resolveFireAnimationNames(u128, v138, v137, v130);
    local v141;

    if v133 then
        v141 = v139;
    else
        v141 = u128.Viewmodel.Animation:pickVariant(v139);
    end;

    if u128.Properties.MuzzleType ~= "ShotGun" then
        u128.CharacterAnimator:adjustAnimationSpeed(v140, u132);
    end;

    if u128.Rounds > 150 then
        return;
    end;

    startRechargeTimer(u128);
    local Position = v136.PrimaryPart.Position;
    local v142 = SoundController.GetWeaponShootRange(u128.Name, (u128.Properties.HasSuppressor and u128.IsSuppressed) == true);
    Router.broadcastRouter("UpdatePlayerNoiseCone", "Weapon", Position, v142, nil);

    if u128.Bullet then
        local FireModes2 = u128.Properties.FireModes;
        local v143;

        if FireModes2 then
            v143 = (v130 or "Primary") == "Secondary" and FireModes2.Secondary or FireModes2.Primary;
        else
            v143 = nil;
        end;

        u128.Bullet:setSpreadConfig(v143 and v143.Spread or u128.Properties.Spread);
    end;

    applyActiveRecoilProfile(u128, v130);
    local v144 = u128.Properties.ShootingOptions == "Dual" and (u128.ShootingHand == "Left" and Interactables:FindFirstChild("MuzzlePartL") or Interactables:FindFirstChild("MuzzlePartR")) or Interactables.MuzzlePart;
    local Position2 = v144.Position;
    debug.profilebegin("Weapon.BuildShootPacket");
    local v145 = {};
    local v146 = {};

    for _ = 1, u128.Properties.BulletsPerShot do
        local v147 = u128.Bullet:create(u128.Properties.AimingOptions, u128.IsAiming);

        if v147 then
            table.insert(v145, v147);
            local Origin = v147.Origin;
            local v148 = {};

            for _, v in ipairs(v147.Hits) do
                table.insert(v148, {
                    Distance = (v.Position - Origin).Magnitude,
                    Instance = v.Instance,
                    Position = v.Position,
                    Normal = v.Normal,
                    Material = v.Material,
                    Exit = v.Exit
                });
                Origin = v.Position;
            end;

            table.insert(v146, {
                Direction = v147.Direction,
                Origin = v147.Origin,
                Hits = v148
            });
        end;
    end;

    debug.profileend();

    if v133 and u128.Properties.ShootingOptions == "Revolver" then
        if u128.Bullet then
            local FireModes2 = u128.Properties.FireModes;
            local v149;

            if FireModes2 then
                v149 = FireModes2.Secondary or FireModes2.Primary;
            else
                v149 = nil;
            end;

            u128.Bullet:setSpreadConfig(v149 and v149.Spread or u128.Properties.Spread);
        end;

        applyActiveRecoilProfile(u128, "Secondary");
    end;

    debug.profilebegin("Weapon.SendShootPacket");
    u128.ShotSeq = u128.ShotSeq + 1;
    Remotes.Inventory.ShootWeapon.Send({
        IsSniperScoped = u128.IsSniperScoped,
        ShootingHand = u128.ShootingHand,
        Identifier = u128.Identifier,
        Seq = u128.ShotSeq,
        Bullets = v146
    });
    debug.profileend();
    local v150 = DataController.Get(LocalPlayer, "Settings.Video.Presets.First Person Tracers") ~= false;
    local v151 = DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false;

    if v151 then
        local v152;

        if u128.Properties.AimingOptions == "AutomaticScope" then
            v152 = u128.IsAiming;
        else
            v152 = false;
        end;

        v151 = not v152;
    end;

    local v153 = DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true;
    local v154 = u128.Properties.MuzzleType ~= "Zeus x27";
    local v155 = u128.Properties.MuzzleType == "Zeus x27";

    if u128.Properties.MuzzleType == "Zeus x27" then
        CreateZeusBeam(v144);
    end;

    if v151 and #v145 > 0 then
        Camera(v144, u128.Properties.HasSuppressor and u128.IsSuppressed and "Suppressor" or u128.Properties.MuzzleType);
    end;

    for _, v in ipairs(v145) do
        if v150 then
            CreateTracer(v.Distance, Position2, v.Direction);
        end;

        local v156 = false;

        for _, v2 in ipairs(v.Hits) do
            local Instance = v2.Instance;
            local Position3 = v2.Position;
            local Material = v2.Material;
            local Normal = v2.Normal;
            local Exit = v2.Exit;
            local v157;

            if Instance then
                v157 = Instance:FindFirstAncestorOfClass("Model");
            else
                v157 = Instance;
            end;

            local v158;

            if v157 == nil then
                v158 = false;
            else
                v158 = Players:GetPlayerFromCharacter(v157) ~= nil;
            end;

            if v158 then
                if v153 then
                    CreateImpact(Instance, "Blood Splatter", Position3, Normal, Exit, false, true, nil, v156, nil, v155);

                    if not (Exit or v155) then
                        CreateBloodSplatter(Position3, v.Direction);
                    end;
                end;
            else
                v156 = not Exit and true or v156;

                if v154 then
                    CreateImpact(Instance, Material, Position3, Normal, Exit, false, true);
                end;

                local Parent = Instance.Parent;

                if Parent and (Parent:HasTag("BreakableGlass") and not Exit) then
                    BreakGlass(Instance, Position3, v.Direction);
                elseif not (Instance:HasTag("BreakableGlass") or Parent and Parent:HasTag("BreakableGlass")) and v154 then
                    CreateMarker(Instance, "Bullet", Position3, Normal);
                end;

                if Parent and (Parent:HasTag("BreakableDoor") and (u128.Properties.Penetration or 0) <= 0) then
                    break;
                end;
            end;
        end;
    end;

    if u128.Viewmodel.Model.CameraShake then
        kickCamera(u128.Viewmodel.Model.CameraShake);
    end;

    u128.Viewmodel.Bobble:addScopeKick();

    if u128.Viewmodel.applyCharmImpulse then
        u128.Viewmodel:applyCharmImpulse(u128.Viewmodel.Model.WorldPivot.LookVector * -1 + u128.Viewmodel.Model.WorldPivot.UpVector * 0.3);
    end;

    if u128.Recoil then
        local Recoil = u128.Recoil;
        Recoil.Time = Recoil.Time + u132;
    end;

    Remotes.Spectate.ReplicateSpectateEvent.Send(v133 and "RevolverChargeRelease" or v139);
    local u159 = u128.IsAiming and u128.Properties.AimingOptions == "SniperScope";

    if u159 then
        u128:unscope(true);
    end;

    local v160;

    if v133 then
        v160 = u128.Viewmodel.Animation:getAnimation(v139);
    else
        v160 = u128.Viewmodel.Animation:play(v141);
    end;

    if v133 then
        if not (v160 and v160.IsPlaying) then
            v160 = u128.Viewmodel.Animation:play(v139);
            u128.CharacterAnimator:play(v140);
        end;
    else
        u128.CharacterAnimator:play(v140);
    end;

    HapticsController.vibrate(Enum.VibrationMotor.Small, 1.25, 0.225);

    if u128.ShootDelayThread then
        task.cancel(u128.ShootDelayThread);
        u128.ShootDelayThread = nil;
    end;

    local v161 = u132 or (v160 and v160.Length or 0.1);
    local v162 = os.clock();
    local NextShotDue = u128.NextShotDue;
    local v163;

    if NextShotDue and v162 - NextShotDue < 0.035 then
        v163 = NextShotDue + v161;
    else
        v163 = v162 + v161;
    end;

    u128.NextShotDue = v163;
    local ShootRequestTick = u128.ShootRequestTick;
    u128.ShootDelayThread = task.delay(v163 - v162, function() -- Line: 1806
        -- upvalues: u128 (copy), u159 (copy), DataController (ref), LocalPlayer (ref), InputController (ref), u132 (copy), ShootRequestTick (copy)
        if u128.IsDestroyed then
            return;
        end;

        u128.IsShooting = false;
        u128.ShootDelayThread = nil;
        local v164 = u128;

        if not (not v164.IsDestroyed and v164.IsEquipped == true) then
            return;
        end;

        if u159 and (u128.ShootRequestTick > u128.WeaponEquippedTick and (u128.Rounds > 0 and DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Re-Zoom Sniper Rifle after Shot") == true)) then
            u128:scope(true);
        end;

        if u128.Properties.ShootingOptions ~= "Revolver" then
            local v165 = tick();
            local v166 = math.min(0.15, u132);
            local v167;

            if ShootRequestTick < u128.ShootRequestTick then
                v167 = v165 - u128.ShootRequestTick <= v166;
            else
                v167 = false;
            end;

            local v168 = u128.IsFireHeld == true;

            if v168 and (u128.FireInputBinding and not InputController.isBindingPressed(u128.FireInputBinding)) then
                u128.IsFireHeld = false;
                u128.FireInputBinding = nil;
                v168 = false;
            end;

            if not (u128.Properties.Automatic and v168 and v168) and (u128.Properties.Automatic or (not v167 or v168)) then
                return;
            end;

            if u128.Properties.ShootingOptions == "Burst" and u128.AlternativeShootingOption == "Burst" then
                return;
            end;

            if u128.Rounds > 0 then
                u128:shoot();

                return;
            end;

            u128:reload();

            return;
        end;

        local v169 = u128.IsAlternativeFireHeld == true;

        if v169 and (u128.AlternativeFireInputBinding and not InputController.isBindingPressed(u128.AlternativeFireInputBinding)) then
            u128.IsAlternativeFireHeld = false;
            u128.AlternativeFireInputBinding = nil;
            v169 = false;
        end;

        local FireModes2 = u128.Properties.FireModes;
        local v170;

        if FireModes2 then
            v170 = FireModes2.Secondary or FireModes2.Primary;
        else
            v170 = nil;
        end;

        if v169 and (v170 and v170.HoldRepeat) then
            if u128.Rounds > 0 then
                u128:shoot("Secondary");

                return;
            end;

            u128:reload();

            return;
        end;

        local v171 = u128.IsFireHeld == true;

        if v171 and (u128.FireInputBinding and not InputController.isBindingPressed(u128.FireInputBinding)) then
            u128.IsFireHeld = false;
            u128.FireInputBinding = nil;
            v171 = false;
        end;

        local FireModes3 = u128.Properties.FireModes;
        local v172;

        if FireModes3 then
            v172 = FireModes3.Primary;
        else
            v172 = nil;
        end;

        if not (v171 and (v172 and v172.HoldRepeat)) then
            if u128.HasPendingChargeRequest == true then
                u128.HasPendingChargeRequest = false;

                if v171 then
                    u128:startRevolverCharge(u128.FireInputBinding);
                end;
            end;

            return;
        end;

        if u128.Rounds > 0 then
            u128:startRevolverCharge(u128.FireInputBinding);

            return;
        end;

        u128:reload();
    end);
end;

function u1.equip(u173) -- Line: 1919
    -- upvalues: GameState (copy), LocalPlayer (copy), InputController (copy), getPressedActionBinding (copy), u4 (copy), u3 (copy), applyActiveRecoilProfile (copy)
    u173.IsEquipped = true;

    if u173.Bullet then
        u173.Bullet:setActive(true);
    end;

    if u173.Viewmodel.Hidden then
        u173.Viewmodel:unhide();
    end;

    u173.Viewmodel.Animation:stopAnimations();
    u173.CharacterAnimator:stopAnimations();
    u173.CharacterAnimator:play("Idle");
    u173.CharacterAnimator:play("Equip");
    u173.WeaponEquippedTick = tick();
    u173.Viewmodel:equip(false);

    if u173.Janitor:Get("EquipDelayFire") then
        u173.Janitor:Remove("EquipDelayFire");
    end;

    local v174 = u173.Viewmodel.Animation:getAnimation("Equip");
    local u177 = task.delay(v174 and (v174.Length and (v174.Length > 0 and v174.Length * 0.925)) or 0.5, function() -- Line: 1946
        -- upvalues: u173 (copy), GameState (ref), LocalPlayer (ref), InputController (ref), getPressedActionBinding (ref), u4 (ref), u3 (ref)
        if u173.IsDestroyed then
            return;
        end;

        if not u173.IsEquipped then
            return;
        end;

        if GameState.GetState() == "Buy Period" then
            return;
        end;

        if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true and LocalPlayer:GetAttribute("IsLocallyDefusingBomb") ~= true then
            if u173.Properties.ShootingOptions == "Revolver" and (u173.IsAlternativeFireHeld or InputController.isActionActive("SecondaryFire")) then
                local v175 = u173.AlternativeFireInputBinding or getPressedActionBinding("SecondaryFire", u4);

                if v175 or u173.IsAlternativeFireHeld then
                    u173:startRevolverSecondaryFire(v175);

                    return;
                end;
            end;

            if not InputController.isActionActive("Fire") then
                return;
            end;

            local v176 = getPressedActionBinding("Fire", u3);

            if v176 then
                if u173.Properties.ShootingOptions == "Revolver" then
                    u173:startRevolverCharge(v176);

                    return;
                end;

                u173.IsFireHeld = true;
                u173.FireInputBinding = v176;
                u173:shoot();
            end;

            return;
        end;

        u173.IsFireHeld = false;
        u173.FireInputBinding = nil;
        u173.IsAlternativeFireHeld = false;
        u173.AlternativeFireInputBinding = nil;
        u173.HasPendingChargeRequest = false;
    end);
    u173.Janitor:Add(function() -- Line: 1991
        -- upvalues: u177 (copy)
        task.cancel(u177);
    end, false, "EquipDelayFire");
    u173.CurrentScopeIncrement = 0;
    u173.IsBurstShooting = false;
    u173.IsInspectFadingOut = false;
    u173.IsInspecting = false;
    u173.IsReloading = false;
    u173.IsShooting = false;
    u173.IsFireHeld = false;
    u173.FireInputBinding = nil;
    u173.HasPendingChargeRequest = false;
    u173.IsAlternativeFireHeld = false;
    u173.AlternativeFireInputBinding = nil;
    u173.IsAiming = false;
    u173.IsChargeFiring = false;
    u173.ScopeStartTick = 0;
    u173.IsAdjustingSuppressor = false;
    u173.CurrentWalkSpeedOverride = nil;
    u173.ChargeStartTick = 0;
    u173.ChargeThread = nil;
    u173.ChargeShootConnection = nil;

    if u173.Properties.ShootingOptions == "Revolver" then
        if u173.Bullet then
            local FireModes = u173.Properties.FireModes;
            local v178;

            if FireModes then
                v178 = FireModes.Secondary or FireModes.Primary;
            else
                v178 = nil;
            end;

            u173.Bullet:setSpreadConfig(v178 and v178.Spread or u173.Properties.Spread);
        end;

        applyActiveRecoilProfile(u173, "Secondary");
    end;

    local Name = u173.Name;

    if Name == "SSG 08" and true or Name == "AWP" then
        u173.IsSniperScoped = false;

        if u173.Name == "AWP" and u173.Player then
            u173.Player:SetAttribute("IsSniperScoped", false);
        end;
    end;
end;

function u1.unequip(p179) -- Line: 2026
    -- upvalues: ReplicatedStorage (copy), CameraController (copy), Constants (copy)
    p179.IsEquipped = false;

    if p179.Bullet then
        p179.Bullet:setActive(false);
    end;

    p179:cancelRevolverCharge(false, false);
    p179:stopRevolverSecondaryFire();

    if p179.Janitor:Get("EquipDelayFire") then
        p179.Janitor:Remove("EquipDelayFire");
    end;

    if p179.ShootDelayThread then
        task.cancel(p179.ShootDelayThread);
        p179.ShootDelayThread = nil;
    end;

    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

    if not (CaseSceneController.IsActive() or MenuSceneController.IsActive()) then
        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    end;

    p179.CharacterAnimator:stopAnimations();
    p179.Viewmodel:unequip();

    if p179.IsAiming then
        p179:unscope();
    end;

    if p179.Viewmodel.Hidden then
        p179.Viewmodel:unhide();
    end;

    p179.IsBurstShooting = false;
    p179.IsInspectFadingOut = false;
    p179.IsInspecting = false;
    p179.IsReloading = false;
    p179.IsShooting = false;
    p179.IsFireHeld = false;
    p179.FireInputBinding = nil;
    p179.HasPendingChargeRequest = false;
    p179.IsAlternativeFireHeld = false;
    p179.AlternativeFireInputBinding = nil;
    p179.IsAiming = false;
    p179.IsChargeFiring = false;
    p179.IsAdjustingSuppressor = false;
    p179.CurrentWalkSpeedOverride = nil;
    p179.ChargeStartTick = 0;
    p179.ChargeThread = nil;
    p179.ChargeShootConnection = nil;
    local Name = p179.Name;

    if Name == "SSG 08" and true or Name == "AWP" then
        p179.IsSniperScoped = false;

        if p179.Name == "AWP" and p179.Player then
            p179.Player:SetAttribute("IsSniperScoped", false);
        end;
    end;

    if p179.Recoil then
        p179.Recoil.Function = p179.Recoil.Functions.Default;
        p179.Recoil.ActiveFireRate = p179.Properties.FireRate or 0.1;
        p179.Recoil.Value = Vector2.zero;
        p179.Recoil.Time = 0;
    end;
end;

function u1.createSuppressor(u180) -- Line: 2097
    -- upvalues: Remotes (copy)
    local Silencer = u180.Viewmodel.Model:FindFirstChild("Silencer", true);

    if not Silencer then
        return;
    end;

    Silencer.Transparency = u180.IsSuppressed and 0 or 1;
    local Identifier = u180.Identifier;

    local function _(p181) -- Line: 2111
        -- upvalues: u180 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        if u180.IsDestroyed then
            return;
        end;

        Silencer.Transparency = p181;
        Remotes.Inventory.UpdateWeaponSuppressor.Send({
            Identifier = Identifier,
            State = p181 == 0
        });
    end;

    local u182 = false;
    local v183 = u180.Viewmodel.Animation:getAnimation("RemoveSuppressor");
    local u184 = u180.Viewmodel.Animation:getAnimation("AddSuppressor");
    u180.Janitor:Add(v183:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function() -- Line: 2128
        -- upvalues: u180 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        if u180.IsDestroyed then
            return;
        end;

        Silencer.Transparency = 1;
        Remotes.Inventory.UpdateWeaponSuppressor.Send({
            State = false,
            Identifier = Identifier
        });
    end));
    u180.Janitor:Add(v183.Ended:Connect(function() -- Line: 2131
        -- upvalues: u180 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        u180.IsAdjustingSuppressor = false;

        if Silencer.Transparency < 1 == false then
            if not u180.IsDestroyed then
                Silencer.Transparency = 1;
                Remotes.Inventory.UpdateWeaponSuppressor.Send({
                    State = false,
                    Identifier = Identifier
                });
            end;

            u180.IsSuppressed = false;
        end;
    end));
    u180.Janitor:Add(u184:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function() -- Line: 2141
        -- upvalues: u182 (ref), u180 (copy), Silencer (copy), Remotes (ref), Identifier (copy)
        u182 = true;

        if not u180.IsDestroyed then
            Silencer.Transparency = 0;
            Remotes.Inventory.UpdateWeaponSuppressor.Send({
                State = true,
                Identifier = Identifier
            });
        end;

        u180.IsSuppressed = true;
    end));
    u180.Janitor:Add(u184:GetPropertyChangedSignal("IsPlaying"):Connect(function() -- Line: 2146
        -- upvalues: u184 (copy), u182 (ref), Silencer (copy)
        if u184.IsPlaying then
            u182 = false;
            task.delay(0.016666666666666666, function() -- Line: 2149
                -- upvalues: u184 (ref), Silencer (ref)
                if u184.IsPlaying then
                    Silencer.Transparency = 0;
                end;
            end);
        end;
    end));
    u180.Janitor:Add(u184.Ended:Connect(function() -- Line: 2156
        -- upvalues: u180 (copy), u182 (ref), Silencer (copy)
        u180.IsAdjustingSuppressor = false;

        if not u182 then
            Silencer.Transparency = 1;
        end;
    end));
end;

function u1.setupRecoil(u185) -- Line: 2166
    -- upvalues: RunServiceController (copy), CameraController (copy)
    local Recoil = u185.Properties.Recoil;

    if u185.Properties.Recoil then
        local RecoverySpeed = Recoil.RecoverySpeed;
        local Scale = Recoil.Scale;
        local Damper = Recoil.Damper;
        local Speed = Recoil.Speed;
        local CameraScale = Recoil.CameraScale;
        local Identifier = u185.Identifier;
        local v186 = Recoil.Pattern(u185.Properties);
        u185.Recoil = {
            RotationValue = Vector3.new(0, 0, 0),
            Time = 0,
            Function = v186,
            Functions = {
                Default = v186
            },
            Value = Vector2.zero,
            ActiveFireRate = u185.Properties.FireRate or 0.1
        };
        local Recoil2 = u185.Recoil;
        u185.Janitor:Add(RunServiceController.BindToStepped(`Components.Weapon.{u185.Identifier}.Recoil`, function(p187, p188) -- Line: 2196
            -- upvalues: u185 (copy), Recoil2 (copy), RecoverySpeed (copy), Scale (copy), Identifier (copy), CameraController (ref), Damper (copy), Speed (copy), CameraScale (copy)
            if u185.IsDestroyed or not (Recoil2 and u185.IsEquipped) then
                return;
            end;

            if u185.IsShooting or u185.Properties.Automatic and u185.IsFireHeld then
                Recoil2.Value = Recoil2.Function(Recoil2.Time);
            else
                local v189 = RecoverySpeed * Recoil2.ActiveFireRate;
                local v190 = v189 <= 0 and 0 or math.exp(-p188 / v189);
                local v191 = Recoil2;
                v191.Time = v191.Time * v190;
                Recoil2.Value = Recoil2.Value:Lerp(Vector2.zero, 1 - v190);
            end;

            local v192 = Vector3.new(Recoil2.Value.Y, Recoil2.Value.X, 0) * math.rad(Scale);
            Recoil2.RotationValue = v192;

            if not u185.IsDestroyed and (u185.IsEquipped and u185.Identifier == Identifier) then
                CameraController.setWeaponRecoil({
                    Value = v192,
                    Damper = Damper,
                    Speed = Speed
                }, CameraScale);
            end;
        end), "Disconnect", "RecoilConnection");
    end;
end;

function u1.new(p193, p194, p195, p196, p197, p198, p199, p200, p201, p202, p203, p204, p205) -- Line: 2235
    -- upvalues: WeaponComponent (copy), u1 (ref), Bullet (copy), applyActiveRecoilProfile (copy), ReplicatedStorage (copy), CameraController (copy), Constants (copy), startRechargeTimer (copy)
    local v206 = WeaponComponent.new(p193, p194, p195, p196, p197, p198, p199, p200, p201, p202, p203, p204);
    local u207 = setmetatable(v206, u1);
    u207.IsEquipped = false;
    local v208 = p205 or {};
    u207.Bullet = Bullet.new(u207, u207.Properties);
    u207.Capacity = v208.Capacity or u207.Properties.Capacity;
    u207.Rounds = v208.Rounds or u207.Properties.Rounds;
    u207.RechargeStartTime = v208.RechargeStartTime;
    u207.CurrentReloadIdentity = nil;
    u207.AlternativeShootingOption = "Default";
    u207.AlternativeSwitchTick = 0;
    u207.IsBurstShooting = false;
    u207.ShootingHand = "Right";
    u207.HasPendingChargeRequest = false;
    u207.IsAlternativeFireHeld = false;
    u207.AlternativeFireInputBinding = nil;
    u207.IsChargeFiring = false;
    u207.CurrentWalkSpeedOverride = nil;
    u207.IsAdjustingSuppressor = false;
    u207.IsInspectFadingOut = false;
    u207.IsInspecting = false;
    u207.IsReloading = false;
    u207.IsShooting = false;
    u207.IsAiming = false;
    u207.IsFireHeld = false;
    u207.FireInputBinding = nil;
    u207.ScopeStartTick = 0;

    if v208.IsSuppressed == nil then
        u207.IsSuppressed = u207.Properties.HasSuppressor;
    else
        u207.IsSuppressed = v208.IsSuppressed;
    end;

    u207.IsSniperScoped = false;
    u207.ReloadTrackFinishedConnection = nil;
    u207.ShootDelayThread = nil;
    u207.InspectDelayThread = nil;
    u207.CancelDelayThread = nil;
    u207.FadeCompleteThread = nil;
    u207.ChargeThread = nil;
    u207.RechargeThread = nil;
    u207.ChargeShootConnection = nil;
    u207.CurrentScopeIncrement = 0;
    u207.WeaponEquippedTick = 0;
    u207.ChargeStartTick = 0;
    u207.ShootRequestTick = 0;
    u207.ShotSeq = 0;
    u207.NextShotDue = nil;
    u207.ReloadStartTick = 0;
    u207.ScopeStartTick = 0;
    u207:setupRecoil();

    if u207.Properties.ShootingOptions == "Revolver" then
        if u207.Bullet then
            local FireModes = u207.Properties.FireModes;
            local v209;

            if FireModes then
                v209 = FireModes.Secondary or FireModes.Primary;
            else
                v209 = nil;
            end;

            u207.Bullet:setSpreadConfig(v209 and v209.Spread or u207.Properties.Spread);
        end;

        applyActiveRecoilProfile(u207, "Secondary");
    end;

    u207.Janitor:Add(function() -- Line: 2346
        -- upvalues: u207 (copy), ReplicatedStorage (ref), CameraController (ref), Constants (ref)
        u207:cancelRevolverCharge(false, false);
        u207:stopRevolverSecondaryFire();

        if u207.Bullet then
            u207.Bullet:destroy();
            u207.Bullet = nil;
        end;

        if u207.IsAiming then
            local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
            local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

            if not (CaseSceneController.IsActive() or MenuSceneController.IsActive()) then
                CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
            end;
        end;
    end);

    if u207.Properties.HasSuppressor then
        u207:createSuppressor();
    end;

    if u207.Rounds < (u207.Properties.Rounds or u207.Rounds) then
        startRechargeTimer(u207);
    end;

    return u207;
end;

function u1.destroy(p210) -- Line: 2380
    -- upvalues: WeaponComponent (copy)
    if not p210.IsDestroyed then
        p210.IsDestroyed = true;

        if p210.ReloadTrackFinishedConnection and p210.ReloadTrackFinishedConnection.Connected then
            p210.ReloadTrackFinishedConnection:Disconnect();
            p210.ReloadTrackFinishedConnection = nil;
        end;

        if p210.ShootDelayThread then
            task.cancel(p210.ShootDelayThread);
            p210.ShootDelayThread = nil;
        end;

        if p210.ChargeThread then
            task.cancel(p210.ChargeThread);
            p210.ChargeThread = nil;
        end;

        if p210.RechargeThread then
            task.cancel(p210.RechargeThread);
            p210.RechargeThread = nil;
        end;

        if p210.ChargeShootConnection and p210.ChargeShootConnection.Connected then
            p210.ChargeShootConnection:Disconnect();
            p210.ChargeShootConnection = nil;
        end;

        if p210.InspectDelayThread then
            task.cancel(p210.InspectDelayThread);
            p210.InspectDelayThread = nil;
        end;

        if p210.CancelDelayThread then
            task.cancel(p210.CancelDelayThread);
            p210.CancelDelayThread = nil;
        end;

        if p210.FadeCompleteThread then
            task.cancel(p210.FadeCompleteThread);
            p210.FadeCompleteThread = nil;
        end;

        if p210.Recoil then
            p210.Recoil.RotationValue = nil;
            p210.Recoil.ActiveFireRate = nil;
            p210.Recoil.Function = nil;
            p210.Recoil.Functions = nil;
            p210.Recoil.Value = nil;
            p210.Recoil.Time = nil;
            p210.Recoil = nil;
        end;

        if p210.Bullet then
            p210.Bullet:destroy();
            p210.Bullet = nil;
        end;

        p210.Janitor:Destroy();
        p210.Janitor = nil;
        p210.AlternativeShootingOption = nil;
        p210.AlternativeSwitchTick = nil;
        p210.CurrentReloadIdentity = nil;
        p210.CurrentScopeIncrement = nil;
        p210.WeaponEquippedTick = nil;
        p210.ChargeStartTick = nil;
        p210.ShootRequestTick = nil;
        p210.ReloadStartTick = nil;
        p210.ShootingHand = nil;
        p210.CurrentWalkSpeedOverride = nil;
        p210.HasPendingChargeRequest = nil;
        p210.IsAlternativeFireHeld = nil;
        p210.AlternativeFireInputBinding = nil;
        p210.IsChargeFiring = nil;
        p210.ChargeThread = nil;
        p210.ChargeShootConnection = nil;
        WeaponComponent.destroy(p210);
    end;
end;

return u1;