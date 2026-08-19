-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Parent.Graph);
local Range = require(script.Parent.Parent.Range);
local AxisLinks = require(script.Parent.Parent.AxisLinks);
local PartConstants = require(script.Parent.Parent.PartConstants);
local Turbulence = require(script.Parent.Parent.Turbulence);
local Endpoints = require(script.Parent.Endpoints);
local DirectionVectors = PartConstants.DirectionVectors;
local u4 = {
    liveGraph = function(p1) -- Line: 22, Name: liveGraph
        -- upvalues: Graph (copy)
        if not p1 then
            return nil;
        end;

        if Graph.IsStatic(p1) and Graph.GetStaticValue(p1, 0) == 0 then
            return nil;
        end;

        return p1;
    end,

    liveColor = function(p2) -- Line: 30, Name: liveColor
        if not p2 or typeof(p2) ~= "ColorSequence" then
            return nil;
        end;

        local Keypoints = p2.Keypoints;

        if #Keypoints <= 1 then
            local v3 = Keypoints[1] and Keypoints[1].Value;

            if not v3 or v3.R > 0.999 and (v3.G > 0.999 and v3.B > 0.999) then
                return nil;
            end;
        end;

        return p2;
    end
};

function u4.build(p5, p6, p7, p8, p9, p10) -- Line: 40
    -- upvalues: u4 (copy), Turbulence (copy), Graph (copy), AxisLinks (copy), Range (copy), DirectionVectors (copy), PartConstants (copy), Endpoints (copy)
    p6.Speed = u4.liveGraph(p6.Speed);
    p6.PosOffsetX = u4.liveGraph(p6.PosOffsetX);
    p6.PosOffsetY = u4.liveGraph(p6.PosOffsetY);
    p6.PosOffsetZ = u4.liveGraph(p6.PosOffsetZ);
    p6.Turbulence = Turbulence.isLive(p6.Turbulence);
    local v11 = {
        Brightness = Graph.GenerateSeed(p6.Brightness),
        Transparency = Graph.GenerateSeed(p6.Transparency),
        Thickness = Graph.GenerateSeed(p6.Thickness),
        Timescale = Graph.GenerateSeed(p6.Timescale),
        Speed = Graph.GenerateSeed(p6.Speed),
        PosOffsetX = Graph.GenerateSeed(p6.PosOffsetX),
        PosOffsetY = Graph.GenerateSeed(p6.PosOffsetY),
        PosOffsetZ = Graph.GenerateSeed(p6.PosOffsetZ),
        Turbulence = Graph.GenerateSeed(p6.Turbulence)
    };
    AxisLinks.applyGraphAxisAliases(p6, v11, p6.AxisLinks);
    local v12 = p6.Acceleration or Vector3.new(0, 0, 0);
    local v13 = {
        Type = "Lightning",
        VisualPart = p7,
        _rig = p8,
        Events = p6.Events,
        StartTime = os.clock(),
        TotalKeyFrames = math.max(1, p6.TotalKeyFrames),
        CurrentStep = 0,
        LifeTime = p9,
        PartLife = p6.PartLife or 0,
        _sourceItem = p5,
        Graphs = {
            Color = p6.Color,
            Gradient = u4.liveColor(p6.Gradient),
            Brightness = p6.Brightness,
            Transparency = p6.Transparency,
            Thickness = p6.Thickness,
            Timescale = p6.Timescale,
            Speed = p6.Speed,
            PosOffsetX = p6.PosOffsetX,
            PosOffsetY = p6.PosOffsetY,
            PosOffsetZ = p6.PosOffsetZ,
            Turbulence = p6.Turbulence
        },
        Seeds = v11,
        _effectiveElapsed = Graph.InitialEffectiveElapsed(p6.Timescale, v11.Timescale, p9),
        _endpointMode = p6.TargetMode == "Seek" and "Seek" or (p6.TargetMode == "Point" and (p6.Target and p6.Target.Parent) and "Point" or "Directional"),
        _target = p6.Target
    };
    local v14 = Range.RandomValueFromRange(p6.SeekRadius);
    v13._seekRadius = math.max(v14, 1);
    v13._seekRetarget = p6.SeekRetarget == true;
    v13._seekBias = math.clamp(p6.SeekBias or 0, 0, 1);
    v13._retargetSpeed = math.max(p6.RetargetSpeed or 0, 0);
    v13._ownsOnHit = true;
    v13._length = math.max(0.1, Range.RandomValueFromRange(p6.Length));
    local v15 = Range.RandomValueFromRange(p6.SegmentCount) + 0.5;
    local v16 = math.floor(v15);
    v13._segCount = math.clamp(v16, 2, p8.mainSegs);
    v13._amplitude = Range.RandomValueFromRange(p6.Amplitude);
    v13._decay = Range.RandomValueFromRange(p6.AmplitudeDecay);
    v13._forkChance = Range.RandomValueFromRange(p6.ForkChance);
    local v17 = Range.RandomValueFromRange(p6.ForkDepth) + 0.5;
    v13._forkDepth = math.floor(v17);
    v13._forkLenScale = Range.RandomValueFromRange(p6.ForkLengthScale);
    v13._sag = Range.RandomValueFromRange(p6.Sag);
    v13._sagShape = Range.RandomValueFromRange(p6.SagShape);
    v13._shapeMode = p6.ShapeMode or "Jitter";
    v13._scrollSpeed = Range.RandomValueFromRange(p6.ScrollSpeed);
    v13._waves = math.max(0.25, Range.RandomValueFromRange(p6.Waves));
    v13._scrollPhase = 0;
    v13._noiseSeedA = math.random() * 1000;
    v13._noiseSeedB = 500 + math.random() * 1000;
    v13._jitterAccum = 0;
    v13._lSpeed = p6.GrowthSpeed or 0;
    v13._growReversed = (p6.GrowthSpeed or 0) < 0;
    v13._tipDist = 0;
    v13._revealPtr = 0;
    v13._nestedAlive = { true };
    v13._accel = v12;
    v13._drag = p6.Drag or 0;
    v13._dispMode = p6.DisplacementMode or "Global";
    v13._motionOffset = Vector3.new(0, 0, 0);
    v13._motionAccelVel = Vector3.new(0, 0, 0);
    v13._hasMotion = p6.Speed ~= nil and true or v12.Magnitude > 0;
    v13._hasDisp = (p6.PosOffsetX ~= nil or p6.PosOffsetY ~= nil) and true or p6.PosOffsetZ ~= nil;
    v13._hasTurb = p6.Turbulence ~= nil;
    v13._turbFreq = p6.TurbulenceFrequency or 1;
    v13._turbSeed = math.random() * 997 + 0.5;
    v13._turbRaw = nil;
    local v18 = Range.RandomValueFromRange(p6.JitterRate);
    v13._jitterInterval = v18 > 0 and 1 / v18 or (1 / 0);
    local v19 = DirectionVectors[p6.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
    local v20 = CFrame.new()[v19.vector] * v19.multiplier;
    local v21 = p6.SpreadAngle or Vector2.new(0, 0);
    local v22 = AxisLinks.sampleRangeAxes(p6, p6.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, p10);
    local v23 = PartConstants.composeRotation(p6.RotOrder or "Global", v22.RotX or 0, v22.RotY or 0, v22.RotZ or 0);
    local v24 = CFrame.lookAt(Vector3.new(0, 0, 0), v20);

    if p6.DirMode == "Local" then
        v24 = v24 * v23;
    end;

    if v21.X > 0 or v21.Y > 0 then
        local Angles = CFrame.Angles;
        local v25 = (math.random() * 2 - 1) * v21.X;
        local v26 = math.rad(v25);
        local v27 = (math.random() * 2 - 1) * v21.Y;
        v24 = v24 * Angles(v26, math.rad(v27), 0);
    end;

    v13._dirLocalVec = v24.LookVector;
    v13._dirGlobal = p6.DirMode == "Global";
    v13._originRot = v23;
    local v28 = AxisLinks.sampleRangeAxes(p6, p6.AxisLinks, { "PosX", "PosY", "PosZ" }, Range, p10);
    local v29 = v28.PosX or 0;
    local v30 = v28.PosY or 0;
    local v31 = v28.PosZ or 0;

    if v29 == 0 and (v30 == 0 and v31 == 0) then
        v13._originOffset = nil;
    else
        v13._originOffset = Vector3.new(v29, v30, v31);
        v13._originOffsetGlobal = p6.PosMode == "Global";
    end;

    Endpoints.sampleShape(v13, p6, p5);

    return v13;
end;

return u4;