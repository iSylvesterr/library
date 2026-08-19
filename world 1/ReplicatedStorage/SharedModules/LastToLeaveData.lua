-- Decompiled with Potassium's decompiler.

local u1 = {
    TemplatePath = { "Assets", "Minigames", "LastToLeave" },
    CircleName = "Circle",
    TornadoName = "Tornado",
    SpinnerName = "SpinningKillPart",
    ArenaTag = "LastToLeaveArena",
    StartSize = Vector3.new(225, 0.072, 225),
    EndSize = Vector3.new(0.001, 0.072, 0.001),
    StartAttribute = "LastToLeaveStart",
    DurationAttribute = "LastToLeaveDuration",
    TornadoSeedAttribute = "LastToLeaveTornadoSeed",
    SpinnerSeedAttribute = "LastToLeaveSpinnerSeed",
    MeteorSeedAttribute = "LastToLeaveMeteorSeed",
    ObstacleSpawnDelay = 5,
    ObstacleSpeed = 20,
    PathRoamFraction = 0.85,
    PathLegMin = 0.4,
    PathLegMax = 1.1,
    PathLegFloor = 4,
    PathSamplesPerLeg = 10,
    PathMaxWaypoints = 2000,
    TornadoSpinPeriod = 0.25,
    TornadoHitRadius = 8,
    TornadoGrowDuration = 0.5,
    TornadoStartScale = 0.01,
    SpinnerSpinPeriod = 1,
    SpinnerFadeDuration = 0.5,
    SpinnerHitPaddingXZ = 1.5,
    SpinnerHitPaddingY = 3,
    MeteorName = "Meteor",
    MeteorBodyAsset = "ShootingStarMeteor",
    MeteorFireAsset = "SunfireFireTrail",
    MeteorFireAssetSize = 8,
    MeteorInterval = 5,
    MeteorIntervalJitter = 0.4,
    MeteorFallDuration = 2.5,
    MeteorFallHeight = 200,
    MeteorFallLateral = 90,
    MeteorBurnDuration = 10,
    MeteorBurnRadiusFraction = 0.3,
    MeteorBurnRadiusMin = 3,
    MeteorBurnRadiusMax = 12,
    MeteorMaxCount = 500
};

local function GenerateWaypoints(p2, p3) -- Line: 195
    -- upvalues: u1 (copy)
    local v4 = Random.new(p2);
    local ObstacleSpeed = u1.ObstacleSpeed;
    local ObstacleSpawnDelay = u1.ObstacleSpawnDelay;
    local v5 = ObstacleSpeed * math.max(p3 - ObstacleSpawnDelay, 0);
    local X = u1.StartSize.X;
    local X2 = u1.EndSize.X;
    local v6 = math.clamp(p3 <= 0 and 1 or ObstacleSpawnDelay / p3, 0, 1);
    local v7 = math.lerp(X, X2, v6) * 0.5 * u1.PathRoamFraction;
    local v8 = v4:NextNumber(0, 6.283185307179586);
    local v9 = v4:NextNumber();
    local v10 = math.sqrt(v9) * v7;
    local v11 = math.cos(v8) * v10;
    local v12 = math.sin(v8) * v10;
    local v13 = Vector3.new(v11, 0, v12);
    local v14 = 0;
    local v15 = { v13 };

    while v14 < v5 and #v15 < u1.PathMaxWaypoints do
        local X3 = u1.StartSize.X;
        local X4 = u1.EndSize.X;
        local v16 = math.clamp(p3 <= 0 and 1 or (ObstacleSpawnDelay + v14 / ObstacleSpeed) / p3, 0, 1);
        local v17 = math.lerp(X3, X4, v16) * 0.5 * u1.PathRoamFraction;
        local v18 = math.max(v17 * u1.PathLegMin, u1.PathLegFloor);
        local v19 = math.max(v17 * u1.PathLegMax, v18);
        local v20 = v4:NextNumber(0, 6.283185307179586);
        local v21 = v4:NextNumber();
        local v22 = math.sqrt(v21) * v17;
        local v23 = math.cos(v20) * v22;
        local v24 = math.sin(v20) * v22;
        local v25 = Vector3.new(v23, 0, v24) - v13;
        local Magnitude = v25.Magnitude;
        local v26;

        if Magnitude > 0.001 then
            v26 = v25 / Magnitude;
        else
            local v27 = math.cos(v20);
            local v28 = math.sin(v20);
            v26 = Vector3.new(v27, 0, v28);
        end;

        local v29 = v13 + v26 * math.clamp(Magnitude, v18, v19);

        if v17 < v29.Magnitude then
            v29 = v29.Unit * v17;
        end;

        v14 = v14 + (v29 - v13).Magnitude;
        table.insert(v15, v29);
        v13 = v29;
    end;

    return v15;
end;

local function CatmullRom(p30, p31, p32, p33, p34) -- Line: 244
    local v35 = p34 * p34;

    return (p31 * 2 + (p32 - p30) * p34 + (p30 * 2 - p31 * 5 + p32 * 4 - p33) * v35 + (p31 * 3 - p30 - p32 * 3 + p33) * (v35 * p34)) * 0.5;
end;

local function GetPathOffset(p36, p37) -- Line: 336
    -- upvalues: u1 (copy)
    local Samples = p36.Samples;
    local Distances = p36.Distances;
    local v38 = p37 * u1.ObstacleSpeed;

    if v38 <= 0 or #Samples < 2 then
        return Samples[1];
    end;

    if p36.Length <= v38 then
        return Samples[#Samples];
    end;

    local v39 = #Distances;
    local v40 = 1;

    while v40 < v39 - 1 do
        local v41 = (v40 + v39) // 2;

        if Distances[v41] <= v38 then
            v40 = v41;
            v41 = v39;
        end;

        v39 = v41;
    end;

    local v42 = Distances[v39] - Distances[v40];

    return Samples[v40]:Lerp(Samples[v39], v42 <= 0 and 0 or (v38 - Distances[v40]) / v42);
end;

function u1.GetDiscSizeX(p43) -- Line: 173
    -- upvalues: u1 (copy)
    local X = u1.StartSize.X;
    local X2 = u1.EndSize.X;
    local v44 = math.clamp(p43, 0, 1);

    return math.lerp(X, X2, v44);
end;

function u1.GetRoamRadius(p45, p46) -- Line: 178
    -- upvalues: u1 (copy)
    local X = u1.StartSize.X;
    local X2 = u1.EndSize.X;
    local v47 = math.clamp(p46 <= 0 and 1 or p45 / p46, 0, 1);

    return math.lerp(X, X2, v47) * 0.5 * u1.PathRoamFraction;
end;

function u1.BuildPath(p48, p49) -- Line: 261
    -- upvalues: GenerateWaypoints (copy), u1 (copy)
    local v50 = GenerateWaypoints(p48, p49);
    local v51 = { v50[1] };
    local PathSamplesPerLeg = u1.PathSamplesPerLeg;
    local v52 = { 0 };

    for i = 1, #v50 - 1 do
        local v53 = v50[math.max(i - 1, 1)];
        local v54 = v50[i];
        local v55 = v50[i + 1];
        local v56 = v50[math.min(i + 2, #v50)];

        for i2 = 1, PathSamplesPerLeg do
            local v57 = i2 / PathSamplesPerLeg;
            local v58 = v57 * v57;
            local v59 = (v54 * 2 + (v55 - v53) * v57 + (v53 * 2 - v54 * 5 + v55 * 4 - v56) * v58 + (v54 * 3 - v53 - v55 * 3 + v56) * (v58 * v57)) * 0.5;
            local v60 = v51[#v51];
            table.insert(v51, v59);
            table.insert(v52, v52[#v52] + (v59 - v60).Magnitude);
        end;
    end;

    return {
        Samples = v51,
        Distances = v52,
        Length = v52[#v52]
    };
end;

function u1.BuildMeteors(p61, p62) -- Line: 300
    -- upvalues: u1 (copy)
    local v63 = Random.new(p61);
    local MeteorIntervalJitter = u1.MeteorIntervalJitter;
    local ObstacleSpawnDelay = u1.ObstacleSpawnDelay;
    local v64 = {};

    while #v64 < u1.MeteorMaxCount do
        ObstacleSpawnDelay = ObstacleSpawnDelay + u1.MeteorInterval * (1 + v63:NextNumber(-MeteorIntervalJitter, MeteorIntervalJitter));

        if p62 <= ObstacleSpawnDelay then
            break;
        end;

        local X = u1.StartSize.X;
        local X2 = u1.EndSize.X;
        local v65 = math.clamp(p62 <= 0 and 1 or ObstacleSpawnDelay / p62, 0, 1);
        local v66 = math.lerp(X, X2, v65) * 0.5 * u1.PathRoamFraction;
        local v67 = v63:NextNumber(0, 6.283185307179586);
        local v68 = v63:NextNumber();
        local v69 = math.sqrt(v68) * v66;
        local v70 = v63:NextNumber(0, 6.283185307179586);
        local v71 = {
            At = ObstacleSpawnDelay
        };
        local v72 = math.cos(v67) * v69;
        local v73 = math.sin(v67) * v69;
        v71.Offset = Vector3.new(v72, 0, v73);
        v71.Radius = math.clamp(v66 * u1.MeteorBurnRadiusFraction, u1.MeteorBurnRadiusMin, u1.MeteorBurnRadiusMax);
        local v74 = math.cos(v70);
        local v75 = math.sin(v70);
        v71.Approach = Vector3.new(v74, 0, v75);
        table.insert(v64, v71);
    end;

    return v64;
end;

u1.GetPathOffset = GetPathOffset;

function u1.GetObstacleBase(p76) -- Line: 369
    -- upvalues: u1 (copy)
    return p76.Position + Vector3.new(0, u1.StartSize.Y * 0.5, 0);
end;

function u1.GetSpin(p77, p78) -- Line: 374
    return p77 / p78 * 6.283185307179586;
end;

function u1.GetTornadoScale(p79) -- Line: 379
    -- upvalues: u1 (copy)
    local v80 = math.clamp(p79 / u1.TornadoGrowDuration, 0, 1);

    return math.lerp(u1.TornadoStartScale, 1, v80);
end;

function u1.GetSpinnerReveal(p81) -- Line: 385
    -- upvalues: u1 (copy)
    return math.clamp(p81 / u1.SpinnerFadeDuration, 0, 1);
end;

function u1.GetSpinnerBase(p82, p83) -- Line: 393
    -- upvalues: u1 (copy)
    return p82.Position + Vector3.new(0, u1.StartSize.Y * 0.5, 0) + Vector3.new(0, p83.Y * 0.5, 0);
end;

function u1.GetSpinnerPose(p84, p85, p86, p87) -- Line: 405
    -- upvalues: GetPathOffset (copy), u1 (copy)
    local v88 = p84 + GetPathOffset(p85, p87);
    local v89 = p87 / u1.SpinnerSpinPeriod * 6.283185307179586;

    return CFrame.new(v88) * CFrame.Angles(0, v89, 0) * p86.Rotation;
end;

function u1.IsInsideSpinner(p90, p91, p92) -- Line: 415
    -- upvalues: u1 (copy)
    local v93 = p90:PointToObjectSpace(p92);
    local v94;

    if math.abs(v93.X) <= p91.X + u1.SpinnerHitPaddingXZ and math.abs(v93.Y) <= p91.Y + u1.SpinnerHitPaddingY then
        v94 = math.abs(v93.Z) <= p91.Z + u1.SpinnerHitPaddingXZ;
    else
        v94 = false;
    end;

    return v94;
end;

return table.freeze(u1);