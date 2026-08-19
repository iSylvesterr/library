-- Decompiled with Potassium's decompiler.

local u1 = {
    ApplyDeltasInCasterHorizontalFrame = true,
    Time = {
        F50_EyesGroundEnable = 0.333,
        F100_LaserSeg1End = 1.167,
        F150_DisableVfx = 2
    },
    CasterDeltaF30 = {
        formation = Vector3.new(0.086, -2.091, 0),
        eyeAboveFormation = Vector3.new(0.087, 10.941, 0)
    },
    TargetDeltaF50 = {
        nightmare = { Vector3.new(-8.291, 60.703, 25.122), Vector3.new(28.438, 60.706, -4.252), Vector3.new(-20.282, 60.694, -22.166) },
        ground = { Vector3.new(-8.276, -0.1, 25.154), Vector3.new(11.089, 0.409, -4.22), Vector3.new(-19.993, 0.409, -3.984) }
    },
    NightmareEulerDegF50 = { Vector3.new(178, -90, 0), Vector3.new(-92.001, -75.001, 90), Vector3.new(163, -90, 0) },
    NightmareDeltaAfterF100 = { Vector3.new(-8.276, 60.662, 25.155), Vector3.new(28.44, 60.662, -4.219), Vector3.new(-20.268, 60.662, -22.123) },
    GroundDeltaFromTargetF100 = { Vector3.new(13.568, -0.1, 5.924), Vector3.new(1.297, 0.409, 9.449), Vector3.new(1.701, 0.409, 6.136) },
    GroundDeltaFromTargetF150 = { Vector3.new(5.604, -0.1, 48.891), Vector3.new(55.877, 0.409, -10.977), Vector3.new(-22.401, 0.409, -45.806) },
    LaserEulerDegF100 = { Vector3.new(108, -69.999, -90), Vector3.new(-92, -60.001, 100), Vector3.new(-3.921, -35.046, -151.419) },
    LaserEulerDegF150 = { Vector3.new(-20.869, -14.935, -165.217), Vector3.new(152.339, -37.175, -45.48), Vector3.new(21.495, -37.779, 178.503) },
    UseLookAtNightmareRotation = true,
    NightmareRotFlipSkyToGround = CFrame.Angles(3.141592653589793, 0, 0),
    NightmareRotPostMul = { CFrame.new(), CFrame.new(), CFrame.new() },
    NightmareLookAtExtraRot = CFrame.Angles(0, 0, 0) * CFrame.Angles(-1.5707963267948966, 0, 0),
    GroundPivotIdentityRotation = true,
    LaserBeamAttStart = "激光2流动_1",
    LaserBeamAttEnd = "激光2流动_2",
    HitboxSize = Vector3.new(25, 25, 25),
    StrikeFollowSmoothLambda = 14
};
local u2 = {};

local function groundBezierCtlFor(p3) -- Line: 105
    -- upvalues: u2 (copy), u1 (copy)
    local v4 = u2[p3];

    if v4 then
        return v4;
    end;

    local F50_EyesGroundEnable = u1.Time.F50_EyesGroundEnable;
    local v5 = (u1.Time.F100_LaserSeg1End - F50_EyesGroundEnable) / (u1.Time.F150_DisableVfx - F50_EyesGroundEnable);
    local v6 = u1.TargetDeltaF50.ground[p3];
    local v7 = u1.GroundDeltaFromTargetF100[p3];
    local v8 = u1.GroundDeltaFromTargetF150[p3];
    local v9 = 2 * v5 * (1 - v5);

    if v9 >= 1e-8 then
        v7 = (v7 - (1 - v5) * (1 - v5) * v6 - v5 * v5 * v8) / v9;
    end;

    u2[p3] = v7;

    return v7;
end;

function u1.resolveWorldFromCasterPos(p10, p11) -- Line: 128
    return p10 + p11;
end;

function u1.resolveWorldFromTargetPos(p12, p13) -- Line: 132
    return p12 + p13;
end;

function u1.flatHorizontalLookAtCast(p14, p15) -- Line: 136
    if p14 then
        local LookVector = p14.CFrame.LookVector;
        local v16 = Vector3.new(LookVector.X, 0, LookVector.Z);

        if v16.Magnitude > 0.08 then
            return v16.Unit;
        end;
    end;

    if p15 then
        local LookVector = p15.LookVector;
        local v17 = Vector3.new(LookVector.X, 0, LookVector.Z);

        if v17.Magnitude > 0.08 then
            return v17.Unit;
        end;
    end;

    return Vector3.new(0, 0, -1);
end;

function u1.strikeOffsetWorld(p18, p19, p20) -- Line: 154
    -- upvalues: u1 (copy)
    if u1.ApplyDeltasInCasterHorizontalFrame then
        return CFrame.lookAt(p18, p18 + (p20.Magnitude < 0.01 and Vector3.new(0, 0, -1) or p20.Unit), Vector3.new(0, 1, 0)):PointToWorldSpace(p19);
    end;

    return u1.resolveWorldFromTargetPos(p18, p19);
end;

function u1.nightmarePosDeltaAtTime(p21, p22) -- Line: 168
    -- upvalues: u1 (copy)
    local F50_EyesGroundEnable = u1.Time.F50_EyesGroundEnable;
    local F100_LaserSeg1End = u1.Time.F100_LaserSeg1End;
    local v23 = u1.TargetDeltaF50.nightmare[p21];
    local v24 = u1.NightmareDeltaAfterF100[p21];

    if p22 < F50_EyesGroundEnable then
        return v23;
    end;

    if p22 < F100_LaserSeg1End then
        return v23:Lerp(v24, (math.clamp((p22 - F50_EyesGroundEnable) / (F100_LaserSeg1End - F50_EyesGroundEnable), 0, 1)));
    end;

    return v24;
end;

function u1.groundDeltaAtTime(p25, p26) -- Line: 183
    -- upvalues: u1 (copy), groundBezierCtlFor (copy)
    local F50_EyesGroundEnable = u1.Time.F50_EyesGroundEnable;
    local F150_DisableVfx = u1.Time.F150_DisableVfx;
    local v27 = u1.TargetDeltaF50.ground[p25];
    local v28 = u1.GroundDeltaFromTargetF150[p25];

    if p26 < F50_EyesGroundEnable then
        return v27;
    end;

    if F150_DisableVfx <= p26 then
        return v28;
    end;

    local v29 = math.clamp((p26 - F50_EyesGroundEnable) / (F150_DisableVfx - F50_EyesGroundEnable), 0, 1);
    local v30 = groundBezierCtlFor(p25);
    local v31 = 1 - v29;

    return v31 * v31 * v27 + 2 * v29 * v31 * v30 + v29 * v29 * v28;
end;

function u1.nightmareCFrameLookAtAtTime(p32, p33, p34, p35, p36) -- Line: 202
    -- upvalues: u1 (copy)
    local v37 = u1.strikeOffsetWorld(p34, u1.nightmarePosDeltaAtTime(p32, p33), p35);
    local v38 = u1.strikeOffsetWorld(p34, u1.groundDeltaAtTime(p32, p33), p35);

    if p36 then
        v38 = p36(v38);
    end;

    return CFrame.lookAt(v37, v38, Vector3.new(0, 1, 0)) * u1.NightmareRotFlipSkyToGround * u1.NightmareLookAtExtraRot * u1.NightmareRotPostMul[p32];
end;

function u1.eulerDegToCFrame(p39, p40) -- Line: 219
    return CFrame.new(p39) * CFrame.Angles(math.rad(p40.X), math.rad(p40.Y), (math.rad(p40.Z)));
end;

local function rotOnlyFromEulerDeg(p41) -- Line: 223
    -- upvalues: u1 (copy)
    return u1.eulerDegToCFrame(Vector3.new(0, 0, 0), p41);
end;

function u1.nightmareRotationOnlyAtTime(p42, p43) -- Line: 227
    -- upvalues: u1 (copy)
    local F50_EyesGroundEnable = u1.Time.F50_EyesGroundEnable;
    local F100_LaserSeg1End = u1.Time.F100_LaserSeg1End;
    local F150_DisableVfx = u1.Time.F150_DisableVfx;
    local v44 = u1.eulerDegToCFrame(Vector3.new(0, 0, 0), u1.NightmareEulerDegF50[p42]);
    local v45 = u1.eulerDegToCFrame(Vector3.new(0, 0, 0), u1.LaserEulerDegF100[p42]);
    local v46 = u1.eulerDegToCFrame(Vector3.new(0, 0, 0), u1.LaserEulerDegF150[p42]);
    local u47 = u1.NightmareRotFlipSkyToGround * u1.NightmareRotPostMul[p42];

    local function withPost(p48) -- Line: 235
        -- upvalues: u47 (copy)
        return p48 * u47;
    end;

    if p43 < F50_EyesGroundEnable then
        return v44 * u47;
    end;

    if p43 < F100_LaserSeg1End then
        return v44:Lerp(v45, (math.clamp((p43 - F50_EyesGroundEnable) / (F100_LaserSeg1End - F50_EyesGroundEnable), 0, 1))) * u47;
    end;

    if p43 < F150_DisableVfx then
        return v45:Lerp(v46, (math.clamp((p43 - F100_LaserSeg1End) / (F150_DisableVfx - F100_LaserSeg1End), 0, 1))) * u47;
    end;

    return v46 * u47;
end;

return u1;