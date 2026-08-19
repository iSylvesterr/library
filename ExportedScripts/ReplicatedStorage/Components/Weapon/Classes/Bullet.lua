-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("RunServiceController"));
local LocalPlayer = Players.LocalPlayer;
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local Raycast = require(ReplicatedStorage.Shared.Raycast);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);
local cast = Raycast.cast;
local castThrough = Raycast.castThrough;
local CurrentCamera = workspace.CurrentCamera;
local min = math.min;
local rad = math.rad;
local max = math.max;
local abs = math.abs;
local _ = math.clamp;
local _ = math.deg;
local _ = math.acos;
local _ = pcall;
local v2 = {};
v2[1] = v2;

local function getSpreadConfig(p3) -- Line: 58
    return p3.ActiveSpreadConfig or p3.Properties.Spread;
end;

local function getCharacterSpeedForSpread(p4) -- Line: 62
    return p4.CharacterSpeed < 6.4 and 0 or p4.CharacterSpeed;
end;

local function getRawBaseSpread(p5) -- Line: 67
    local v6 = p5.Spread:getPosition();

    return type(v6) ~= "number" and 0 or v6;
end;

local function clampBaseSpreadForConfig(p7, p8) -- Line: 72
    if p8 then
        return math.clamp(p7, p8.Range.Min, p8.Range.Max);
    end;

    return p7;
end;

local function sampleSpreadPitch(p9, p10) -- Line: 80
    -- upvalues: rad (copy)
    local v11 = rad(p9 / 2);

    return v11 <= 0 and 0 or p10:NextNumber(0, v11);
end;

local function resetMovementSpreadState(p12) -- Line: 89
    p12.CharacterSpeed = 0;
    p12.isInAir = false;
    p12.jumpStartSpeed = nil;
    p12.verticalVelocity = 0;
    p12.isAtJumpPeak = false;
end;

local function updateCharacterSpeed(p13) -- Line: 97
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        p13.CharacterSpeed = 0;
        p13.isInAir = false;
        p13.jumpStartSpeed = nil;
        p13.verticalVelocity = 0;
        p13.isAtJumpPeak = false;

        return;
    end;

    local PrimaryPart = Character.PrimaryPart;

    if not PrimaryPart then
        p13.CharacterSpeed = 0;
        p13.isInAir = false;
        p13.jumpStartSpeed = nil;
        p13.verticalVelocity = 0;
        p13.isAtJumpPeak = false;

        return;
    end;

    local v14 = Character:FindFirstChildOfClass("Humanoid");

    if not v14 then
        p13.CharacterSpeed = 0;
        p13.isInAir = false;
        p13.jumpStartSpeed = nil;
        p13.verticalVelocity = 0;
        p13.isAtJumpPeak = false;

        return;
    end;

    local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity;
    local v15 = v14:GetState();
    p13.verticalVelocity = AssemblyLinearVelocity.Y;
    local isInAir = p13.isInAir;
    p13.isInAir = v15 == Enum.HumanoidStateType.Jumping and true or v15 == Enum.HumanoidStateType.Freefall;
    local Properties = p13.Properties;
    local v16 = p13.ActiveSpreadConfig or p13.Properties.Spread;
    local v17;

    if v16 then
        v17 = v16.Range;
    else
        v17 = v16;
    end;

    if v17 then
        v17 = v17.Min;
    end;

    local v18;

    if v16 then
        v18 = v16.PerShot;
    else
        v18 = v16;
    end;

    local v19;

    if v16 then
        v19 = v16.MovementMultiplier;
    else
        v19 = v16;
    end;

    local v20;

    if Properties.AimingOptions == "SniperScope" and (Properties.MuzzleType == "Sniper" and (v17 == 0 and v18 == 0)) then
        v20 = v19 == 2;
    else
        v20 = false;
    end;

    if v20 and p13.isInAir then
        p13.isAtJumpPeak = math.abs(p13.verticalVelocity) <= 3;
    else
        p13.isAtJumpPeak = false;
    end;

    if p13.isInAir and not isInAir then
        p13.jumpStartSpeed = AssemblyLinearVelocity.Magnitude + (v16 and v16.JumpShotMinimum or 100);
    elseif not p13.isInAir and isInAir then
        p13.jumpStartSpeed = nil;
        p13.isAtJumpPeak = false;
    end;

    if not (p13.isInAir and p13.jumpStartSpeed) then
        p13.CharacterSpeed = AssemblyLinearVelocity.Magnitude;

        return;
    end;

    if v20 and p13.isAtJumpPeak then
        p13.CharacterSpeed = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;

        return;
    end;

    p13.CharacterSpeed = p13.jumpStartSpeed;
end;

local function isSpreadSettled(p21) -- Line: 162
    local v22 = p21.Spread:getPosition();
    local v23 = p21.Spread:getGoal();
    local v24 = p21.Spread:getVelocity();

    if type(v22) ~= "number" or (type(v23) ~= "number" or type(v24) ~= "number") then
        return false;
    end;

    local v25;

    if math.abs(v22 - v23) <= 0.001 then
        v25 = math.abs(v24) <= 0.001;
    else
        v25 = false;
    end;

    return v25;
end;

local function stopSpreadRecovery(p26) -- Line: 174
    if p26.SpreadRecoveryConnection then
        p26.SpreadRecoveryConnection:Disconnect();
        p26.SpreadRecoveryConnection = nil;
    end;
end;

local function ensureSpreadRecovery(u27) -- Line: 181
    -- upvalues: RunServiceController (copy)
    if u27.IsDestroyed or u27.SpreadRecoveryConnection then
        return;
    end;

    u27.SpreadRecoveryConnection = RunServiceController.BindToStepped(`{u27.BindingName}.SpreadRecovery`, function(p28, p29) -- Line: 188
        -- upvalues: u27 (copy)
        u27:updateSpread(p29);
    end);
end;

function u1._performRaycast(p30, p31) -- Line: 194
    -- upvalues: GetRayIgnore (copy), CurrentCamera (copy), min (copy), rad (copy), abs (copy), cast (copy), castThrough (copy)
    local v32 = GetRayIgnore();
    local v33 = CurrentCamera.ViewportSize * 0.5;
    local v34 = CurrentCamera:ViewportPointToRay(v33.X, v33.Y);
    local v35 = min(p31, 69);
    local v36 = os.clock() * 1000000 % 2147483647;
    local v37 = math.floor(v36);
    local v38 = Random.new(v37);
    local v39 = {
        Theta = v38:NextNumber(-3.141592653589793, 3.141592653589793),
        Phi = v38:NextNumber(0, (rad(v35 * 0.5)))
    };
    local Direction = v34.Direction;
    local v40 = Direction.Magnitude > 0 and Direction.Unit or Vector3.new(0, 0, 1);
    local v41 = abs(v40.Y) > 0.9999 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0);
    local v42 = CFrame.lookAlong(Vector3.new(0, 0, 0), v40, v41);
    local v43 = CFrame.Angles(0, 0, v39.Theta);
    local v44 = CFrame.Angles(v39.Phi, 0, 0);
    local LookVector = (v42 * v43 * v44).LookVector;
    local Origin = v34.Origin;
    local v45 = p30.Properties.Penetration or 0;
    local v46 = p30.Properties.Range or 500;
    local v47 = {
        Distance = 0,
        Origin = Origin,
        Direction = LookVector,
        Hits = {}
    };
    local v48 = cast(Origin, LookVector * (v46 * 8 / 8), nil, v32);

    if not v48.instance then
        v47.Distance = v46;

        return v47;
    end;

    local position = v48.position;
    v47.Distance = (position - Origin).Magnitude;
    local v49 = castThrough(position + LookVector * -0.001, LookVector * (v45 + 0.001), v45, v32);
    local Hits = v47.Hits;

    for i = 1, #v49 do
        local v50 = v49[i];

        if v50.instance and v50.material then
            Hits[#Hits + 1] = {
                Position = v50.position,
                Instance = v50.instance,
                Material = v50.material.Name,
                Normal = v50.normal or Vector3.new(0, 0, 0),
                Exit = i % 2 == 0
            };
        end;
    end;

    return v47;
end;

function u1.setSpreadConfig(p51, p52) -- Line: 273
    local v53 = p51.ActiveSpreadConfig or p51.Properties.Spread;
    p51.ActiveSpreadConfig = p52;
    local v54 = p51.ActiveSpreadConfig or p51.Properties.Spread;
    assert(v54, "Weapon properties missing spread configuration");
    p51.Spread:setFrequency(v54.RecoverySpeed);

    if v53 == v54 then
        return;
    end;

    local v55 = p51.Spread:getPosition();
    local v56 = type(v55) ~= "number" and 0 or v55;
    local v57 = math.clamp(v56, v54.Range.Min, v54.Range.Max);
    p51.Spread:reset(v57);
    p51.Spread:setGoal(v54.Range.Min);
end;

function u1.create(p58, p59, p60) -- Line: 296
    -- upvalues: max (copy)
    p58.LastShotTick = tick();

    if p59 == "SniperScope" and not p60 then
        local v61 = p58.ActiveSpreadConfig or p58.Properties.Spread;
        local v62 = v61 and v61.MovementMultiplier or 1;
        local v63 = v62 == 2 and 6 or (v62 == 3 and 12 or 15);
        local v64 = p58.Spread:getPosition();

        if (type(v64) ~= "number" and 0 or v64) < v63 then
            p58.Spread:setPosition(v63);
        end;
    end;

    local v65;

    if p59 == "SniperScope" and p60 then
        local Weapon = p58.Weapon;

        if Weapon.Name == "AWP" then
            local v66 = Weapon.ScopeStartTick or 0;

            if tick() - v66 < 0.2 then
                v65 = false;
            else
                v65 = p60;
            end;
        else
            v65 = p60;
        end;
    else
        v65 = p60;
    end;

    local v67 = p58:getTrueSpread();

    if p59 == "SniperScope" and (p60 and (not v65 and p58.Weapon.Name == "AWP")) then
        local v68 = p58.ActiveSpreadConfig or p58.Properties.Spread;
        local v69 = v68 and v68.MovementMultiplier or 1;
        v67 = max(v67, v69 == 2 and 6 or (v69 == 3 and 12 or 15));
    end;

    p58:_updateShotSpread(p59, v65);

    return p58:_performRaycast(v67);
end;

function u1.getTrueSpread(p70) -- Line: 361
    return p70:getSpreadForConfig(p70.ActiveSpreadConfig or p70.Properties.Spread);
end;

function u1.getBaseSpread(p71) -- Line: 365
    local v72 = p71.Spread:getPosition();

    return type(v72) ~= "number" and 0 or v72;
end;

function u1.getBaseSpreadForConfig(p73, p74) -- Line: 369
    local v75 = p74 or (p73.ActiveSpreadConfig or p73.Properties.Spread);
    local v76 = p73.Spread:getPosition();
    local v77 = type(v76) ~= "number" and 0 or v76;

    if v75 then
        return math.clamp(v77, v75.Range.Min, v75.Range.Max);
    end;

    return v77;
end;

function u1.getMovementSpreadForConfig(p78, p79) -- Line: 374
    local v80 = p79 or (p78.ActiveSpreadConfig or p78.Properties.Spread);

    return (p78.CharacterSpeed < 6.4 and 0 or p78.CharacterSpeed) * (not v80 and 1 or v80.MovementMultiplier);
end;

function u1.getSpreadForConfig(p81, p82) -- Line: 381
    local v83 = p82 or (p81.ActiveSpreadConfig or p81.Properties.Spread);

    return p81:getBaseSpreadForConfig(v83) + p81:getMovementSpreadForConfig(v83);
end;

function u1.setBaseSpreadForConfig(p84, p85, p86) -- Line: 387
    local v87 = p86 or (p84.ActiveSpreadConfig or p84.Properties.Spread);
    assert(v87, "Weapon properties missing spread configuration");
    local Spread = p84.Spread;

    if v87 then
        p85 = math.clamp(p85, v87.Range.Min, v87.Range.Max);
    end;

    Spread:setPosition(p85);
end;

function u1.updateSpread(p88, p89) -- Line: 398
    -- upvalues: isSpreadSettled (copy)
    p88.Spread:update(p89);

    if not p88.IsActive and isSpreadSettled(p88) then
        p88.Spread:reset(p88.Spread:getGoal());

        if p88.SpreadRecoveryConnection then
            p88.SpreadRecoveryConnection:Disconnect();
            p88.SpreadRecoveryConnection = nil;
        end;
    end;
end;

function u1.setActive(u90, p91) -- Line: 407
    -- upvalues: updateCharacterSpeed (copy), RunServiceController (copy)
    if u90.IsDestroyed or u90.IsActive == p91 then
        return;
    end;

    u90.IsActive = p91;

    if p91 then
        updateCharacterSpeed(u90);

        if not (u90.IsDestroyed or u90.SpreadRecoveryConnection) then
            u90.SpreadRecoveryConnection = RunServiceController.BindToStepped(`{u90.BindingName}.SpreadRecovery`, function(p92, p93) -- Line: 188
                -- upvalues: u90 (copy)
                u90:updateSpread(p93);
            end);
        end;

        u90.CharacterSpeedConnection = RunServiceController.BindToHeartbeat(`{u90.BindingName}.CharacterSpeed`, function() -- Line: 429
            -- upvalues: updateCharacterSpeed (ref), u90 (copy)
            updateCharacterSpeed(u90);
        end);

        return;
    end;

    if u90.CharacterSpeedConnection then
        u90.CharacterSpeedConnection:Disconnect();
        u90.CharacterSpeedConnection = nil;
    end;

    u90.CharacterSpeed = 0;
    u90.isInAir = false;
    u90.jumpStartSpeed = nil;
    u90.verticalVelocity = 0;
    u90.isAtJumpPeak = false;
end;

function u1._updateShotSpread(p94, p95, p96) -- Line: 435
    local v97 = p94.ActiveSpreadConfig or p94.Properties.Spread;
    assert(v97, "Weapon properties missing spread configuration");
    local Range = v97.Range;
    local Min = Range.Min;
    local Max = Range.Max;

    if p95 == "SniperScope" then
        if p96 then
            Min = 0;
        else
            local v98 = v97.MovementMultiplier or 1;
            Min = v98 == 2 and 6 or (v98 == 3 and 12 or 15);
        end;
    end;

    local v99 = p94.Spread:getPosition();
    local v100 = type(v99) ~= "number" and 0 or v99;
    local v101 = math.clamp(v100 + v97.PerShot, Min, Max);
    p94.Spread:setPosition(v101);
end;

function u1.new(p102, p103) -- Line: 465
    -- upvalues: u1 (copy), Janitor (copy), Spring (copy), RunServiceController (copy)
    local v104 = setmetatable({}, u1);
    v104.Janitor = Janitor.new();
    v104.IsDestroyed = false;
    v104.Properties = p103;
    v104.Weapon = p102;
    v104.CharacterSpeed = 0;
    v104.isInAir = false;
    v104.jumpStartSpeed = nil;
    v104.verticalVelocity = 0;
    v104.isAtJumpPeak = false;
    local Spread = p103.Spread;
    assert(Spread, "Weapon properties missing spread configuration");
    v104.Spread = Spring.new(1, Spread.RecoverySpeed, Spread.Range.Min);
    v104.ActiveSpreadConfig = nil;
    v104.LastShotTick = 0;
    v104.IsActive = false;
    v104.BindingName = RunServiceController.CreateBindingName("Components.Bullet");
    v104.CharacterSpeedConnection = nil;
    v104.SpreadRecoveryConnection = nil;

    return v104;
end;

function u1.destroy(p105) -- Line: 504
    if p105.IsDestroyed then
        return;
    end;

    p105:setActive(false);

    if p105.SpreadRecoveryConnection then
        p105.SpreadRecoveryConnection:Disconnect();
        p105.SpreadRecoveryConnection = nil;
    end;

    p105.IsDestroyed = true;
    p105.Janitor:Destroy();
    p105.Properties = nil;
    p105.Weapon = nil;
    p105.Spread = nil;
    p105.Janitor = nil;
end;

return u1;