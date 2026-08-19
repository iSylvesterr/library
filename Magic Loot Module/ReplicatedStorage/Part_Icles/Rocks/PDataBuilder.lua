-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Parent.Graph);
local Range = require(script.Parent.Parent.Range);
local PartConstants = require(script.Parent.Parent.PartConstants);
local DirectionVectors = PartConstants.DirectionVectors;
local u1 = CFrame.new(1000000000, 1000000000, 1000000000);
local u2 = {};

local function rollRange(p3) -- Line: 19
    -- upvalues: Range (copy)
    return Range.RandomValueFromRange(p3);
end;

local function rollAxis(p4, p5, p6, p7) -- Line: 24
    -- upvalues: Range (copy)
    if p5 and p7 > 0 then
        return p4.Min + (p4.Max - p4.Min) * ((p6 - 0.5) / p7);
    end;

    return Range.RandomValueFromRange(p4);
end;

local function randomAxis() -- Line: 32
    local v8 = math.random() * 2 - 1;
    local v9 = math.random() * 2 - 1;
    local v10 = math.random() * 2 - 1;
    local v11 = Vector3.new(v8, v9, v10);

    return v11.Magnitude < 0.001 and Vector3.new(0, 1, 0) or v11.Unit;
end;

local function launchDir(p12, p13, p14, p15) -- Line: 41
    -- upvalues: DirectionVectors (copy)
    local v16 = DirectionVectors[p12.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
    local v17 = CFrame.new()[v16.vector] * v16.multiplier;

    if p12.BurstMode ~= "Ring" then
        local v18 = p12.SpreadAngle or Vector2.new(0, 0);
        local v19 = CFrame.lookAt(Vector3.new(0, 0, 0), v17);

        if v18.X > 0 or v18.Y > 0 then
            local Angles = CFrame.Angles;
            local v20 = (math.random() * 2 - 1) * v18.X;
            local v21 = math.rad(v20);
            local v22 = (math.random() * 2 - 1) * v18.Y;
            v19 = v19 * Angles(v21, math.rad(v22), 0);
        end;

        return p13.Rotation:VectorToWorldSpace(v19.LookVector);
    end;

    local v23 = v17:Cross(Vector3.new(1, 0, 0));

    if v23.Magnitude < 0.01 then
        v23 = v17:Cross(Vector3.new(0, 0, 1));
    end;

    local Unit = v23.Unit;
    local v24 = v17:Cross(Unit);
    local v25 = (p14 - 0.5) / p15 * 2 * 3.141592653589793 + (math.random() - 0.5) * 0.2;
    local v26 = math.rad(p12.SpreadAngle.X);
    local v27 = (Unit * math.cos(v25) + v24 * math.sin(v25)) * math.cos(v26) + v17 * math.sin(v26);

    return p13.Rotation:VectorToWorldSpace(v27);
end;

function u2.rollChunks(p28, p29, u30, p31) -- Line: 68
    -- upvalues: Range (copy), Graph (copy), launchDir (copy), u1 (copy)
    local v32 = p29.RenderTemplate and p29.RenderTemplate:IsA("BasePart") and (p29.RenderTemplate.Size or Vector3.new(1, 1, 1)) or Vector3.new(1, 1, 1);
    local v33 = Range.RandomValueFromRange(p29.ChunkCount) + 0.5;
    local v34 = math.floor(v33);
    local v35 = math.clamp(v34, 1, u30.chunkCap);
    p28._chunkCount = v35;
    local u36 = p29.Scale and (Graph.QueryPointsWithTime(0, p29.Scale, p28.Seeds.Scale) or 1) or 1;
    p28._curScale = u36;

    for i = 1, u30.chunkCap do
        local u37 = u30.parts[i];

        if i <= v35 then
            local PosX = p29.PosX;
            local v38;

            if p29.PosXEven and v35 > 0 then
                v38 = PosX.Min + (PosX.Max - PosX.Min) * ((i - 0.5) / v35);
            else
                v38 = Range.RandomValueFromRange(PosX);
            end;

            local PosY = p29.PosY;
            local v39;

            if p29.PosYEven and v35 > 0 then
                v39 = PosY.Min + (PosY.Max - PosY.Min) * ((i - 0.5) / v35);
            else
                v39 = Range.RandomValueFromRange(PosY);
            end;

            local PosZ = p29.PosZ;
            local v40;

            if p29.PosZEven and v35 > 0 then
                v40 = PosZ.Min + (PosZ.Max - PosZ.Min) * ((i - 0.5) / v35);
            else
                v40 = Range.RandomValueFromRange(PosZ);
            end;

            local u41;

            if p29.PosMode == "Global" then
                u41 = p31.Position + Vector3.new(v38, v39, v40);
            else
                u41 = (p31 * CFrame.new(v38, v39, v40)).Position;
            end;

            u30.baseSize[i] = v32 * Range.RandomValueFromRange(p29.ChunkScale);
            u30.halfExt[i] = u30.baseSize[i] * 0.5;
            local v42 = p29.Speed and (Graph.QueryPointsWithTime(0, p29.Speed, Graph.GenerateSeed(p29.Speed)) or 0) or 0;
            local v43 = launchDir(p29, p31, i, v35) * v42;
            local v44 = math.random() * 2 - 1;
            local v45 = math.random() * 2 - 1;
            local v46 = math.random() * 2 - 1;
            local v47 = Vector3.new(v44, v45, v46);
            local v48 = v47.Magnitude < 0.001 and Vector3.new(0, 1, 0) or v47.Unit;
            local v49 = Range.RandomValueFromRange(p29.TumbleSpeed);
            local v50 = math.rad(v49) * (math.random() < 0.5 and -1 or 1);
            local u51 = CFrame.Angles(math.random() * 6.283, math.random() * 6.283, math.random() * 6.283);
            u30.launchVel[i] = v43;
            u30.launchAng[i] = v48 * v50;
            u30.spawnPos[i] = u41;
            u30.spawnRot[i] = u51;
            u30.trajs[i] = nil;
            local bounciness = u30.bounciness;
            local v52 = Range.RandomValueFromRange(p29.Bounciness);
            bounciness[i] = math.clamp(v52, 0, 1);
            u30.touched[i] = false;
            u30.writeCFs[i] = u51 + u41;
            pcall(function() -- Line: 104
                -- upvalues: u37 (copy), u30 (copy), i (copy), u36 (copy), u51 (copy), u41 (ref)
                u37.Size = u30.baseSize[i] * math.max(u36, 0.01);
                u37.CFrame = u51 + u41;
            end);
        else
            pcall(function() -- Line: 109
                -- upvalues: u37 (copy), u1 (ref)
                u37.Anchored = true;
                u37.CanCollide = false;
                u37.CanTouch = false;
                u37.CFrame = u1;
            end);
            u30.launchVel[i] = Vector3.new(0, 0, 0);
            u30.launchAng[i] = Vector3.new(0, 0, 0);
            u30.spawnPos[i] = u1.Position;
            u30.spawnRot[i] = CFrame.identity;
            u30.trajs[i] = nil;
            u30.touched[i] = false;
            u30.writeCFs[i] = u1;
        end;
    end;
end;

function u2.build(p53, p54, p55, p56, p57, p58, p59) -- Line: 126
    -- upvalues: Graph (copy), PartConstants (copy), u2 (copy)
    local v60 = {
        Scale = Graph.GenerateSeed(p54.Scale),
        Brightness = Graph.GenerateSeed(p54.Brightness),
        Transparency = Graph.GenerateSeed(p54.Transparency),
        Timescale = Graph.GenerateSeed(p54.Timescale)
    };
    local v61 = {
        Type = "Rocks",
        CurrentStep = 0,
        _hitFired = false,
        _ownsOnHit = true,
        VisualPart = p55,
        _rig = p56,
        Events = p54.Events,
        StartTime = os.clock(),
        TotalKeyFrames = math.max(1, p54.TotalKeyFrames),
        LifeTime = p57,
        PartLife = p54.PartLife or 0,
        _sourceItem = p53,
        Graphs = {
            Scale = p54.Scale,
            Brightness = p54.Brightness,
            Transparency = p54.Transparency,
            Timescale = p54.Timescale,
            Color = p54.Color
        },
        Seeds = v60,
        _effectiveElapsed = Graph.InitialEffectiveElapsed(p54.Timescale, v60.Timescale, p57),
        _gravity = p54.Gravity or 196.2,
        _friction = math.clamp(p54.Friction or 0.3, 0, 1),
        _sinkOut = p54.SinkOut ~= false,
        _inheritFloor = p54.InheritFloor == true
    };
    local v62 = nil;

    if p58 then
        local v63;

        if p58.EventOriginResolver then
            v63 = p58.EventOriginResolver();
        else
            v63 = nil;
        end;

        local v64 = v63 or p58.EventOriginCF;

        if v64 then
            v62 = p58.UseFullOrigin and v64 and v64 or CFrame.new(v64.Position) * p53.CFrame.Rotation;
        end;
    end;

    if not v62 and (p59 and p59.Parent) then
        v62 = PartConstants.resolveLinkCFrame(p59);
    end;

    u2.rollChunks(v61, p54, p56, v62 or p53.CFrame);

    return v61;
end;

return u2;