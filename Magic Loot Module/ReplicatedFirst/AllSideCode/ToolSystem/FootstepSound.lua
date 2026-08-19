-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
local FootstepSoundsConfig = require(script.FootstepSoundsConfig);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, p5) -- Line: 22
    -- upvalues: u1 (copy)
    local v6 = setmetatable({}, u1);
    v6.humanoid = p2;
    v6.rootPart = p3;
    v6.runningSound = p4;
    v6.landedSound = p5;
    v6.lastMaterial = nil;

    return v6;
end;

function u1.UpdateSoundByMaterial(p7) -- Line: 39
    -- upvalues: FootstepSoundsConfig (copy)
    if not p7.runningSound then
        return false;
    end;

    local FloorMaterial = p7.humanoid.FloorMaterial;

    if FloorMaterial == Enum.Material.Air then
        return false;
    end;

    if FloorMaterial == p7.lastMaterial then
        return false;
    end;

    local v8 = FootstepSoundsConfig.IntervalSounds[FloorMaterial];

    if not v8 or #v8 == 0 then
        return false;
    end;

    local v9 = v8[math.random(1, #v8)];
    p7.runningSound.SoundId = v9;

    if p7.runningSound.IsPlaying then
        p7.runningSound:Stop();
    end;

    p7.runningSound:Play();
    p7.lastMaterial = FloorMaterial;

    return true;
end;

function u1.UpdateLandedSoundByMaterial(p10) -- Line: 89
    -- upvalues: FootstepSoundsConfig (copy)
    if not p10.landedSound then
        return false;
    end;

    local FloorMaterial = p10.humanoid.FloorMaterial;

    if FloorMaterial == Enum.Material.Air then
        return false;
    end;

    local v11 = FootstepSoundsConfig.IntervalSounds[FloorMaterial];

    if not v11 or #v11 == 0 then
        return false;
    end;

    local v12 = v11[math.random(1, #v11)];
    p10.landedSound.SoundId = v12;

    return true;
end;

function u1.Destroy(p13) -- Line: 121
    p13.humanoid = nil;
    p13.rootPart = nil;
    p13.runningSound = nil;
    p13.landedSound = nil;
end;

return u1;