-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Parent.Graph);
local Range = require(script.Parent.Parent.Range);
local PartConstants = require(script.Parent.Parent.PartConstants);
local Turbulence = require(script.Parent.Parent.Turbulence);
local AxisLinks = require(script.Parent.Parent.AxisLinks);
local Anchors = require(script.Parent.Anchors);
local DirectionVectors = PartConstants.DirectionVectors;
local u1 = {};

local function liveGraph(p2) -- Line: 20
    -- upvalues: Graph (copy)
    if not p2 then
        return nil;
    end;

    if Graph.IsStatic(p2) and Graph.GetStaticValue(p2, 0) == 0 then
        return nil;
    end;

    return p2;
end;

function u1.readRopeParams(p3, p4, p5, p6) -- Line: 28
    -- upvalues: Range (copy), Graph (copy), Turbulence (copy), AxisLinks (copy), PartConstants (copy), Anchors (copy), DirectionVectors (copy)
    p3._pinMode = p4.PinMode or "BothEnds";
    p3._target = p4.Target;
    p3._pinStart = true;
    p3._pinEnd = p3._pinMode == "BothEnds" and p4.Target ~= nil and true or p3._pinMode == "Launch";
    local v7 = Range.RandomValueFromRange(p4.SegmentCount) + 0.5;
    local v8 = math.floor(v7);
    p3._segCount = math.clamp(v8, 2, p5.segCap);
    local v9 = math.floor((p4.Stiffness or 4) + 0.5);
    p3._stiffness = math.clamp(v9, 1, 10);
    p3._bendStiffness = math.clamp(p4.BendStiffness or 0, 0, 1);
    p3._damping = math.clamp(p4.Damping or 0.03, 0, 0.5);
    p3._gravity = p4.Gravity or Vector3.new(0, -40, 0);
    p3._windAmp = Range.RandomValueFromRange(p4.WindAmplitude);
    p3._windFreq = p4.WindFrequency or 2;
    p3._growIn = math.clamp(p4.GrowIn or 0, 0, 0.9);
    p3._deathMode = p4.DeathMode or "None";
    p3._deathWindow = math.clamp(p4.DeathWindow or 0.2, 0.05, 0.9);
    local ThicknessProfile = p4.ThicknessProfile;
    local v10 = not ThicknessProfile or Graph.IsStatic(ThicknessProfile);
    local v11;

    if v10 then
        v11 = nil;
    else
        v11 = Graph.GenerateSeed(ThicknessProfile) or nil;
    end;

    for i = 1, p5.segCap do
        if v10 then
            p5.widthScale[i] = ThicknessProfile and (Graph.GetStaticValue(ThicknessProfile, 1) or 1) or 1;
        else
            local widthScale = p5.widthScale;
            local v12 = Graph.QueryPointsWithTime((i - 0.5) / p5.segCap, ThicknessProfile, v11);
            widthScale[i] = math.max(v12, 0.05);
        end;
    end;

    p3._motionTarget = p4.MotionTarget or "Start";
    p3._dispMode = p4.DisplacementMode or "Global";
    local PosOffsetX = p4.PosOffsetX;

    if PosOffsetX then
        if Graph.IsStatic(PosOffsetX) and Graph.GetStaticValue(PosOffsetX, 0) == 0 then
            PosOffsetX = nil;
        end;
    else
        PosOffsetX = nil;
    end;

    local PosOffsetY = p4.PosOffsetY;

    if PosOffsetY then
        if Graph.IsStatic(PosOffsetY) and Graph.GetStaticValue(PosOffsetY, 0) == 0 then
            PosOffsetY = nil;
        end;
    else
        PosOffsetY = nil;
    end;

    local PosOffsetZ = p4.PosOffsetZ;

    if PosOffsetZ then
        if Graph.IsStatic(PosOffsetZ) and Graph.GetStaticValue(PosOffsetZ, 0) == 0 then
            PosOffsetZ = nil;
        end;
    else
        PosOffsetZ = nil;
    end;

    p3.Graphs.PosOffsetX = PosOffsetX;
    p3.Graphs.PosOffsetY = PosOffsetY;
    p3.Graphs.PosOffsetZ = PosOffsetZ;
    p3._hasDisp = (PosOffsetX or (PosOffsetY or PosOffsetZ)) ~= nil;

    if PosOffsetX then
        p3.Seeds.PosOffsetX = p3.Seeds.PosOffsetX or Graph.GenerateSeed(PosOffsetX);
    end;

    if PosOffsetY then
        p3.Seeds.PosOffsetY = p3.Seeds.PosOffsetY or Graph.GenerateSeed(PosOffsetY);
    end;

    if PosOffsetZ then
        p3.Seeds.PosOffsetZ = p3.Seeds.PosOffsetZ or Graph.GenerateSeed(PosOffsetZ);
    end;

    local v13 = Turbulence.isLive(p4.Turbulence);
    p3.Graphs.Turbulence = v13;
    p3._hasTurb = v13 ~= nil;

    if v13 then
        p3.Seeds.Turbulence = p3.Seeds.Turbulence or Graph.GenerateSeed(v13);
        p3._turbFreq = p4.TurbulenceFrequency or 1;
        p3._turbSeed = p3._turbSeed or math.random() * 997 + 0.5;
    end;

    local v14 = AxisLinks.sampleRangeAxes(p4, p4.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, p6);
    local u15 = PartConstants.composeRotation(p4.RotOrder or "Global", v14.RotX or 0, v14.RotY or 0, v14.RotZ or 0);
    p3._spawnRot = u15;
    local v16 = AxisLinks.sampleRangeAxes(p4, p4.AxisLinks, { "PosX", "PosY", "PosZ" }, Range, p6);
    p3._spawnOff = Vector3.new(v16.PosX or 0, v16.PosY or 0, v16.PosZ or 0);
    p3._spawnOffMode = p4.PosMode or "Local";
    p3._spawnTarget = p4.SpawnTarget or "Start";
    local u17 = Anchors.resolveStart(p3);
    local u18 = p4.SpreadAngle or Vector2.new(0, 0);

    local function composeDir(p19) -- Line: 102
        -- upvalues: DirectionVectors (ref), u15 (copy), u18 (copy), u17 (copy)
        local v20 = DirectionVectors[p19] or DirectionVectors[Enum.NormalId.Front];
        local v21 = CFrame.new()[v20.vector] * v20.multiplier;
        local v22 = CFrame.lookAt(Vector3.new(0, 0, 0), v21) * u15;

        if u18.X > 0 or u18.Y > 0 then
            local Angles = CFrame.Angles;
            local v23 = (math.random() * 2 - 1) * u18.X;
            local v24 = math.rad(v23);
            local v25 = (math.random() * 2 - 1) * u18.Y;
            v22 = v22 * Angles(v24, math.rad(v25), 0);
        end;

        return u17.Rotation:VectorToWorldSpace(v22.LookVector);
    end;

    p3._motionDir = composeDir(p4.EmissionDirection);
    p3._speedDir = composeDir(p4.MotionDirection or p4.EmissionDirection);
    local Speed = p4.Speed;

    if Speed then
        if Graph.IsStatic(Speed) and Graph.GetStaticValue(Speed, 0) == 0 then
            Speed = nil;
        end;
    else
        Speed = nil;
    end;

    p3.Graphs.Speed = Speed;

    if Speed then
        p3.Seeds.Speed = p3.Seeds.Speed or Graph.GenerateSeed(Speed);
    end;

    p3._accel = p4.Acceleration or Vector3.new(0, 0, 0);
    p3._drag = p4.Drag or 0;
    p3._hasMotion = Speed ~= nil and true or p3._accel.Magnitude > 0;
    p3._motionOffset = Vector3.new(0, 0, 0);
    p3._motionAccelVel = Vector3.new(0, 0, 0);

    if p3._pinMode == "Launch" then
        local v26 = Range.RandomValueFromRange(p4.LaunchSpeed);
        local v27 = math.max(v26, 1);
        p3._launchOrigin = u17.Position;
        p3._launchT = nil;
        local v28 = nil;

        if p4.Target then
            local success, result = pcall(PartConstants.resolveLinkCFrame, p4.Target);

            if success and result then
                v28 = result.Position;
            end;
        end;

        if v28 then
            local v29 = v28 - u17.Position;
            local v30 = math.max(v29.Magnitude / v27, 0.05);
            p3._launchVel = v29 * (1 / v30) - p3._gravity * (v30 * 0.5);
            p3._launchT = v30;
        else
            p3._launchVel = p3._motionDir * v27;
        end;
    end;

    local v31 = Range.RandomValueFromRange(p4.RopeLength);

    if v31 <= 0 then
        local v32 = math.max(p4.Slack or 1.2, 1);
        local v33 = 10;

        if (p3._pinMode == "BothEnds" or p3._pinMode == "Launch") and p4.Target then
            local success, result = pcall(PartConstants.resolveLinkCFrame, p4.Target);

            if success and result then
                v33 = math.max((result.Position - u17.Position).Magnitude, 1);
            end;
        end;

        v31 = v33 * v32;
    end;

    p3._restLen = math.max(v31 / p3._segCount, 0.05);
end;

function u1.build(p34, p35, p36, p37, p38, p39, p40) -- Line: 169
    -- upvalues: Graph (copy), u1 (copy)
    local v41 = {
        Brightness = Graph.GenerateSeed(p35.Brightness),
        Transparency = Graph.GenerateSeed(p35.Transparency),
        Thickness = Graph.GenerateSeed(p35.Thickness),
        Timescale = Graph.GenerateSeed(p35.Timescale)
    };
    local v42 = {
        Type = "Rope",
        CurrentStep = 0,
        _accum = 0,
        _windPhase = 0,
        VisualPart = p36,
        _rig = p37,
        Events = p35.Events,
        StartTime = os.clock(),
        TotalKeyFrames = math.max(1, p35.TotalKeyFrames),
        LifeTime = p38,
        PartLife = p35.PartLife or 0,
        _sourceItem = p34,
        Graphs = {
            Color = p35.Color,
            Brightness = p35.Brightness,
            Transparency = p35.Transparency,
            Thickness = p35.Thickness,
            Timescale = p35.Timescale
        },
        Seeds = v41,
        _effectiveElapsed = Graph.InitialEffectiveElapsed(p35.Timescale, v41.Timescale, p38),
        _parentLink = p40,
        _windSeedA = math.random() * 1000,
        _windSeedB = 500 + math.random() * 1000
    };

    if p39 then
        local v43;

        if p39.EventOriginResolver then
            v43 = p39.EventOriginResolver();
        else
            v43 = nil;
        end;

        local v44 = v43 or p39.EventOriginCF;

        if v44 then
            v42._startCFOverride = p39.UseFullOrigin and v44 and v44 or CFrame.new(v44.Position) * p34.CFrame.Rotation;
        end;
    end;

    u1.readRopeParams(v42, p35, p37, p39);
    v42._launchArrived = false;
    v42._released = false;

    return v42;
end;

return u1;