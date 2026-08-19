-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SkillCommon = require(script.Parent.Parent._Templates.SkillCommon);
local u1 = {
    PATH_SPAWN_RADIUS = 80,
    PATH_Z_OFFSET = 30,
    PATH_MAX_SPAWN_HEIGHT_DELTA = 10
};
local u2 = RaycastParams.new();
u2.FilterType = Enum.RaycastFilterType.Include;
u2.IgnoreWater = false;

local function refreshWaterRayIncludeList() -- Line: 42
    -- upvalues: Workspace (copy), u2 (copy)
    local v3 = { Workspace.Terrain };
    local v4 = Workspace:FindFirstChild("场景");

    if v4 then
        table.insert(v3, v4);
    end;

    u2.FilterDescendantsInstances = v3;
end;

local function isWaterMaterial(p5) -- Line: 51
    return p5 == Enum.Material.Water;
end;

local function isInWaterAt(p6) -- Line: 56
    -- upvalues: Workspace (copy), u2 (copy)
    local v7 = { Workspace.Terrain };
    local v8 = Workspace:FindFirstChild("场景");

    if v8 then
        table.insert(v7, v8);
    end;

    u2.FilterDescendantsInstances = v7;
    local v9 = Workspace:Raycast(p6, Vector3.new(0, 64, 0), u2);

    if v9 and v9.Material == Enum.Material.Water then
        return true;
    end;

    local v10 = Workspace:Raycast(p6, Vector3.new(0, -64, 0), u2);

    if v10 and v10.Material == Enum.Material.Water then
        local v11 = p6.Y - v10.Position.Y;

        if v11 >= -1 and v11 <= 6 then
            return true;
        end;
    end;

    return false;
end;

local function isSpawnHeightDeltaValid(p12, p13) -- Line: 75
    -- upvalues: u1 (copy)
    return math.abs(p13 - p12) <= u1.PATH_MAX_SPAWN_HEIGHT_DELTA;
end;

function u1.isPathEndpointGroundValid(p14, p15) -- Line: 80
    -- upvalues: isInWaterAt (copy), u1 (copy)
    if isInWaterAt(p15) then
        return false;
    end;

    return math.abs(p15.Y - p14.Y) <= u1.PATH_MAX_SPAWN_HEIGHT_DELTA;
end;

function u1.validatePathEndpoints(p16, p17, p18) -- Line: 88
    -- upvalues: u1 (copy)
    return u1.isPathEndpointGroundValid(p16, p17) and u1.isPathEndpointGroundValid(p16, p18);
end;

local function snapGround(p19) -- Line: 94
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p19), 4, 0.15, "Ground").Position;
end;

local function flatUnit(p20, p21) -- Line: 98
    local v22 = Vector3.new(p21.X - p20.X, 0, p21.Z - p20.Z);

    return v22.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v22.Unit;
end;

local function flatRightFromRouteCF(p23, p24, p25) -- Line: 106
    local v26 = Vector3.new(p23.X, p25, p23.Z);
    local v27 = Vector3.new(p24.X, p25, p24.Z);

    if Vector3.new(v27.X - v26.X, 0, v27.Z - v26.Z).Magnitude < 0.01 then
        return Vector3.new(1, 0, 0);
    end;

    local v28 = CFrame.lookAt(v26, v27);
    local v29 = Vector3.new(v28.RightVector.X, 0, v28.RightVector.Z);

    return v29.Magnitude < 0.01 and Vector3.new(1, 0, 0) or v29.Unit;
end;

function u1.snapSpawnGround(p30) -- Line: 121
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p30), 4, 0.15, "Ground").Position;
end;

function u1.buildHorizontalPlan(p31, p32) -- Line: 129
    -- upvalues: u1 (copy), flatRightFromRouteCF (copy), SkillCommon (copy)
    local Y = p31.Y;
    local v33 = Vector3.new(p32.X, Y, p32.Z);
    local v34 = Vector3.new(v33.X - p31.X, 0, v33.Z - p31.Z);
    local v35 = v34.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v34.Unit;
    local v36 = p31 - v35 * u1.PATH_SPAWN_RADIUS;
    local v37 = p31 + v35 * u1.PATH_SPAWN_RADIUS;
    local v38 = flatRightFromRouteCF(v36, v37, Y);
    local v39 = v36:Lerp(v37, 0.3333333333333333) + v38 * u1.PATH_Z_OFFSET;
    local v40 = v36:Lerp(v37, 0.6666666666666666) - v38 * u1.PATH_Z_OFFSET;
    local Position = SkillCommon.getGroundCF(CFrame.new(v36), 4, 0.15, "Ground").Position;
    local Position2 = SkillCommon.getGroundCF(CFrame.new(v39), 4, 0.15, "Ground").Position;
    local Position3 = SkillCommon.getGroundCF(CFrame.new(v40), 4, 0.15, "Ground").Position;
    local Position4 = SkillCommon.getGroundCF(CFrame.new(v37), 4, 0.15, "Ground").Position;

    if u1.validatePathEndpoints(p31, Position, Position4) then
        return u1.planFromPoints({
            Position,
            Position2,
            Position3,
            Position4
        });
    end;

    return nil;
end;

function u1.copyPathPoints(p41) -- Line: 155
    local v42 = {};

    for i = 1, math.min(4, #p41) do
        local v43 = p41[i];
        v42[i] = Vector3.new(v43.X, v43.Y, v43.Z);
    end;

    return v42;
end;

function u1.planFromPoints(p44) -- Line: 164
    -- upvalues: u1 (copy)
    if #p44 < 4 then
        return nil;
    end;

    local v45 = u1.copyPathPoints(p44);

    return {
        startPos = v45[1],
        waypoint1 = v45[2],
        waypoint2 = v45[3],
        endPos = v45[4],
        points = v45
    };
end;

local function coerceVector3(p46) -- Line: 178
    if typeof(p46) == "Vector3" then
        return p46;
    end;

    if type(p46) == "table" then
        local v47 = p46.X or p46.x;
        local v48 = p46.Y or p46.y;
        local v49 = p46.Z or p46.z;

        if type(v47) == "number" and (type(v48) == "number" and type(v49) == "number") then
            return Vector3.new(v47, v48, v49);
        end;
    end;

    return nil;
end;

function u1.normalizePathPointsFromSync(p50, p51) -- Line: 192
    -- upvalues: coerceVector3 (copy)
    if type(p51) == "table" and #p51 >= 12 then
        return {
            Vector3.new(p51[1], p51[2], p51[3]),
            Vector3.new(p51[4], p51[5], p51[6]),
            Vector3.new(p51[7], p51[8], p51[9]),
            Vector3.new(p51[10], p51[11], p51[12])
        };
    end;

    if type(p50) ~= "table" then
        return nil;
    end;

    local v52 = {};

    for i = 1, 4 do
        local v53 = coerceVector3(p50[i]) or coerceVector3(p50[tostring(i)]);

        if not v53 then
            return nil;
        end;

        v52[i] = v53;
    end;

    return v52;
end;

function u1.packPathPointsForSync(p54) -- Line: 215
    local v55 = {};
    local v56 = p54[1];
    v55[1] = v56.X;
    v55[2] = v56.Y;
    v55[3] = v56.Z;
    local v57 = p54[2];
    v55[4] = v57.X;
    v55[5] = v57.Y;
    v55[6] = v57.Z;
    local v58 = p54[3];
    v55[7] = v58.X;
    v55[8] = v58.Y;
    v55[9] = v58.Z;
    local v59 = p54[4];
    v55[10] = v59.X;
    v55[11] = v59.Y;
    v55[12] = v59.Z;

    return v55;
end;

function u1.applySyncFieldsToSkillInputData(p60, p61) -- Line: 228
    -- upvalues: u1 (copy), coerceVector3 (copy)
    if not (p60 and p61) then
        return;
    end;

    local v62 = u1.normalizePathPointsFromSync(p61.multThunderPathPoints, p61.multThunderPathPacked);

    if v62 then
        p60.multThunderPathPoints = u1.copyPathPoints(v62);
    end;

    local v63 = coerceVector3(p61.multThunderSpawnGround);

    if v63 then
        p60.multThunderSpawnGround = v63;
    end;

    if p61.moveFaceMode ~= nil then
        p60.moveFaceMode = p61.moveFaceMode;
    end;

    local v64 = coerceVector3(p61.moveFaceWorldPos);

    if v64 then
        p60.moveFaceWorldPos = v64;
    end;

    local v65 = coerceVector3(p61.approachLandWorldPos);

    if v65 then
        p60.approachLandWorldPos = v65;
    end;
end;

function u1.resolveSpawnGroundFromCharacter(p66) -- Line: 253
    -- upvalues: UtilsSystem (copy), u1 (copy)
    local SystemEnemy = UtilsSystem.SystemEnemy;

    if SystemEnemy and SystemEnemy.getPackByModel then
        local v67 = SystemEnemy.getPackByModel(p66);

        if v67 then
            v67 = v67.entity;
        end;

        if v67 and typeof(v67.spawnPos) == "Vector3" then
            return u1.snapSpawnGround(v67.spawnPos);
        end;
    end;

    local SystemSummon = UtilsSystem.SystemSummon;

    if SystemSummon and SystemSummon.getPackByModel then
        local v68 = SystemSummon.getPackByModel(p66);

        if v68 then
            v68 = v68.entity;
        end;

        if v68 and typeof(v68.spawnPos) == "Vector3" then
            return u1.snapSpawnGround(v68.spawnPos);
        end;
    end;

    return nil;
end;

function u1.inferSpawnGroundFromPathStart(p69, p70) -- Line: 274
    -- upvalues: u1 (copy), SkillCommon (copy)
    local v71 = Vector3.new(p70.X - p69.X, 0, p70.Z - p69.Z);

    return SkillCommon.getGroundCF(CFrame.new(p69 + (v71.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v71.Unit) * u1.PATH_SPAWN_RADIUS), 4, 0.15, "Ground").Position;
end;

function u1.buildPlanFromCharacterAndTarget(p72, p73) -- Line: 279
    -- upvalues: u1 (copy), SkillCommon (copy)
    local v74 = u1.resolveSpawnGroundFromCharacter(p72);

    if not v74 then
        local HumanoidRootPart = p72:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return nil;
        end;

        v74 = u1.inferSpawnGroundFromPathStart(SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position), 4, 0.15, "Ground").Position, p73);
    end;

    return u1.buildHorizontalPlan(v74, p73);
end;

function u1.buildPlanFromEntityAndTarget(p75, p76) -- Line: 291
    -- upvalues: u1 (copy)
    if not p75 or typeof(p75.spawnPos) ~= "Vector3" then
        return nil;
    end;

    local v77 = u1.snapSpawnGround(p75.spawnPos);

    return u1.buildHorizontalPlan(v77, p76);
end;

local function computeSegmentLengths(p78) -- Line: 299
    local v79 = {};
    local v80 = 0;

    for i = 1, #p78 - 1 do
        local Magnitude = (p78[i + 1] - p78[i]).Magnitude;
        v79[i] = Magnitude;
        v80 = v80 + Magnitude;
    end;

    return v79, v80;
end;

function u1.getPolylineSegmentAt(p81, p82) -- Line: 311
    -- upvalues: computeSegmentLengths (copy)
    local points = p81.points;
    local v83 = #points - 1;

    if v83 <= 0 then
        return 1, 0, p81.startPos;
    end;

    local v84 = math.clamp(p82, 0, 1);
    local v85, v86 = computeSegmentLengths(points);

    if v86 < 0.01 then
        return 1, 0, points[1];
    end;

    local v87 = v84 * v86;

    for i = 1, v83 do
        if v87 <= v85[i] or i == v83 then
            local v88 = math.clamp(v85[i] <= 0.01 and 1 or v87 / v85[i], 0, 1);

            return i, v88, points[i]:Lerp(points[i + 1], v88);
        end;

        v87 = v87 - v85[i];
    end;

    return v83, 1, points[#points];
end;

function u1.samplePolylineGround(p89, p90) -- Line: 337
    -- upvalues: u1 (copy)
    local _, _, v91 = u1.getPolylineSegmentAt(p89, p90);

    return v91;
end;

function u1.flatTangentAtPathT(p92, p93) -- Line: 343
    -- upvalues: u1 (copy)
    local v94, _, _ = u1.getPolylineSegmentAt(p92, (math.clamp(p93, 0, 1)));
    local points = p92.points;
    local v95 = points[v94];
    local v96 = points[math.min(v94 + 1, #points)];
    local v97 = Vector3.new(v96.X - v95.X, 0, v96.Z - v95.Z);

    return v97.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v97.Unit;
end;

function u1.pathArcTForLeapSegment(p98, p99, p100) -- Line: 358
    -- upvalues: computeSegmentLengths (copy)
    local v101, v102 = computeSegmentLengths(p98.points);

    if v102 < 0.01 then
        return 0;
    end;

    local v103 = 0;

    for i = 1, p99 - 1 do
        v103 = v103 + v101[i];
    end;

    return (v103 + math.clamp(p100, 0, 1) * v101[p99]) / v102;
end;

function u1.leapTimeAtPathArcT(p104, p105, p106, p107, p108, p109) -- Line: 376
    -- upvalues: u1 (copy)
    local v110, v111 = u1.getPolylineSegmentAt(p104, p105);

    return u1.leapTimeAtLeapSegment(v110, v111, p106, p107, p108, p109);
end;

function u1.leapTimeAtLeapSegment(p112, p113, p114, p115, p116, p117) -- Line: 391
    local v118 = 0;

    for i = 1, p112 - 1 do
        v118 = v118 + ((p114[i] or 0) + p117);
    end;

    local v119 = p115[p112] or 0;

    return v118 + ((p116[p112] or 0) + math.clamp(p113, 0, 1) * v119);
end;

return u1;