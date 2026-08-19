-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local AxisLinks = require(script.Parent.AxisLinks);
local Particles = require(script.Parent.Particles);
require(script.Parent.TypeRegistry);
local Events = require(script.Parent.Events);
local PartConstants = require(script.Parent.PartConstants);
local Pool = require(script.Parent.Pool);
local NestedEmit = require(script.Parent.NestedEmit);
local StaticPass = require(script.Parent.StaticPass);
local Turbulence = require(script.Parent.Turbulence);
local DirectionVectors = PartConstants.DirectionVectors;

return function(u1) -- Line: 19
    -- upvalues: Range (copy), DirectionVectors (copy), AxisLinks (copy), PartConstants (copy), Graph (copy), Pool (copy), Turbulence (copy), Particles (copy), StaticPass (copy), NestedEmit (copy), Events (copy)
    function u1.EmitModel(u2, p3, p4, p5) -- Line: 22
        -- upvalues: Range (ref), DirectionVectors (ref), AxisLinks (ref), PartConstants (ref), Graph (ref), Pool (ref), Turbulence (ref), Particles (ref), u1 (copy), StaticPass (ref), NestedEmit (ref)
        if not (p3 and p3.Parent) then
            return;
        end;

        local v6 = u2:GetData(p3);

        if not (v6 and v6.RenderTemplate) then
            return;
        end;

        local v7;

        if p5 and p5.IgnoreLink then
            v7 = nil;
        else
            v7 = p4 or v6.Link;
        end;

        local v8 = Range.RandomValueFromRange(v6.Lifetime);
        local v9 = v8 <= 0 and 0.001 or v8;
        local v10 = p3:GetPivot();
        local v11 = nil;

        if p5 then
            if p5.EventOriginResolver then
                v11 = p5.EventOriginResolver();
            end;

            v11 = v11 or p5.EventOriginCF;
        end;

        if v11 then
            if not (p5 and p5.UseFullOrigin) then
                v11 = CFrame.new(v11.Position) * v10.Rotation;
            end;
        else
            v11 = v10;
        end;

        local v12 = DirectionVectors[v6.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
        local v13 = v11[v12.vector] * v12.multiplier;
        local v14 = v6.DirMode or "RigidLocal";
        local v15 = AxisLinks.sampleRangeAxes(v6, v6.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, p5);
        local v16 = PartConstants.composeRotation(v6.RotOrder or "Global", v15.RotX, v15.RotY, v15.RotZ);
        local v17 = PartConstants.applyPositionOffset(v11 * v16, v6, v7, p3, Range, AxisLinks, p5);

        if v14 == "Global" then
            v17 = CFrame.new(v17.Position) * v16;
        end;

        if v14 == "Local" then
            v13 = v17[v12.vector] * v12.multiplier;
        elseif v14 == "Global" then
            v13 = CFrame.new()[v12.vector] * v12.multiplier;
        end;

        local v18, v19;

        if v6.ParticleData.SpreadAngle.X > 0 or v6.ParticleData.SpreadAngle.Y > 0 then
            v18 = (math.random() * 2 - 1) * v6.ParticleData.SpreadAngle.X;
            v19 = (math.random() * 2 - 1) * v6.ParticleData.SpreadAngle.Y;
        else
            v18 = 0;
            v19 = 0;
        end;

        local v20 = CFrame.Angles(math.rad(v18), math.rad(v19), 0);
        local LookVector = (CFrame.lookAt(Vector3.new(), v13) * v20).LookVector;
        local v21 = {
            RotSpeedX = Graph.GenerateSeed(v6.RotSpeedX),
            RotSpeedY = Graph.GenerateSeed(v6.RotSpeedY),
            RotSpeedZ = Graph.GenerateSeed(v6.RotSpeedZ),
            PosOffsetX = Graph.GenerateSeed(v6.PosOffsetX),
            PosOffsetY = Graph.GenerateSeed(v6.PosOffsetY),
            PosOffsetZ = Graph.GenerateSeed(v6.PosOffsetZ),
            Speed = Graph.GenerateSeed(v6.Speed),
            Scale = Graph.GenerateSeed(v6.Scale),
            Timescale = Graph.GenerateSeed(v6.Timescale)
        };
        AxisLinks.applyGraphAxisAliases(v6, v21, v6.AxisLinks);
        local InvertMotion = v6.InvertMotion;
        local v22, v23;

        if InvertMotion then
            v22, v23 = u2:PreSimulateForward(v6, v21, v17, LookVector, v20, v7, v9, nil, v17.Rotation * v16:Inverse());
        else
            v23 = nil;
            v22 = nil;
        end;

        local u24 = Pool.acquireOrCopyBare(v6.RenderTemplate, "Model", v6.Pool);
        u24.Archivable = false;
        local RenderTemplate = v6.RenderTemplate;

        if RenderTemplate and u24:GetAttribute("_pooledModelScale") == nil then
            local success, result = pcall(function() -- Line: 118
                -- upvalues: RenderTemplate (copy)
                return RenderTemplate:GetScale();
            end);

            if success and result then
                u24:SetAttribute("_pooledModelScale", result);
            end;
        end;

        local u25 = u24:GetAttribute("_pooledModelScale");

        if u25 then
            pcall(function() -- Line: 122
                -- upvalues: u24 (copy), u25 (copy)
                u24:ScaleTo(u25);
            end);
        end;

        local v26;

        if v7 then
            v26 = PartConstants.resolveLinkCFrame(v7);

            if v6.LinkMode == "Follow" or v6.LinkMode == "Pivot" then
                v26 = CFrame.new(v26.Position) or v26;
            end;
        else
            v26 = CFrame.new();
        end;

        if InvertMotion and v22 then
            v17 = v22[v23 or v6.TotalKeyFrames] or v22[0];
            u24:PivotTo(v26 * v17);
        else
            if v7 then
                v17 = v26:ToObjectSpace(v17) or v17;
            end;

            u24:PivotTo(v26 * v17);
        end;

        local v27 = {
            Type = "Model",
            VisualPart = u24,
            Link = v7,
            LinkMode = v6.LinkMode
        };

        if v6.LinkMode ~= "RigidLocal" or not (v7 and v26) then
            v26 = nil;
        end;

        v27._rigidLocalParentCF = v26;
        v27.Events = v6.Events;
        v27.StartTime = os.clock();
        v27.TotalKeyFrames = InvertMotion and v23 and v23 or math.max(1, v6.TotalKeyFrames);
        v27.CurrentStep = 0;
        v27.AccumulatedDT = 0;
        v27.LifeTime = v9;
        v27.PartLife = v6.PartLife;
        v27.CurrentPosition = u24:GetPivot().Position;
        v27.LocalCF = v17;
        v27.BaseDirection = LookVector;
        v27._accelVel = Vector3.new(0, 0, 0);
        v27.SpeedMultiplier = 1;
        v27._spinRate = Vector3.new(0, 0, 0);
        v27._spinAccumX = 0;
        v27._spinAccumY = 0;
        v27._spinAccumZ = 0;
        v27.EmissionDirection = v6.EmissionDirection;
        v27.SpreadRotation = v20;
        v27.Acceleration = v6.ParticleData.Acceleration;
        v27.Drag = v6.ParticleData.Drag;
        v27.VelocityVectored = v6.VelocityVectored;
        v27.InvertMotion = InvertMotion;
        v27.SimLocalCFrames = v22;
        v27.RotMode = v6.RotMode or "OverLife";
        v27.RotOrder = v6.RotOrder or "Global";
        v27.AccRotX = 0;
        v27.AccRotY = 0;
        v27.AccRotZ = 0;
        v27.Orientation = v6.Orientation;
        v27.ZOffset = v6.ZOffset;
        v27._localWorldCF = v17;
        v27.SpawnRotation = v17.Rotation;
        v27.SpawnEmitterRotation = v17.Rotation * v16:Inverse();
        v27.DisplacementMode = v6.DisplacementMode;
        v27._sleepRadius = 1;
        v27._prevWorldOff = Vector3.new(0, 0, 0);
        v27.HasPosOffsetGraphs = (v6.PosOffsetX ~= nil or v6.PosOffsetY ~= nil) and true or v6.PosOffsetZ ~= nil;
        v27.NeedsFullIteration = v6.VelocityVectored;
        local v28;

        if v6.RotMode == "Speed" then
            v28 = not v6.VelocityVectored;
        else
            v28 = false;
        end;

        v27.NeedsRotAccum = v28;
        v27.HasDrag = v6.ParticleData.Drag ~= 0;
        v27.HasAccel = v6.ParticleData.Acceleration.Magnitude > 0;
        v27.Graphs = {
            RotSpeedX = v6.RotSpeedX,
            RotSpeedY = v6.RotSpeedY,
            RotSpeedZ = v6.RotSpeedZ,
            PosOffsetX = v6.PosOffsetX,
            PosOffsetY = v6.PosOffsetY,
            PosOffsetZ = v6.PosOffsetZ,
            Speed = v6.Speed,
            Scale = v6.Scale,
            Timescale = v6.Timescale
        };
        v27.Seeds = v21;
        v27._effectiveElapsed = Graph.InitialEffectiveElapsed(v6.Timescale, v21.Timescale, v9);

        if v27.HasPosOffsetGraphs then
            local v29 = v27.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(0, v27.Graphs.PosOffsetX, v27.Seeds.PosOffsetX) or 0) or 0;
            local v30 = v27.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(0, v27.Graphs.PosOffsetY, v27.Seeds.PosOffsetY) or 0) or 0;
            local v31 = v27.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(0, v27.Graphs.PosOffsetZ, v27.Seeds.PosOffsetZ) or 0) or 0;
            local v32 = PartConstants.resolveDisplacement(Vector3.new(v29, v30, v31), v6.DisplacementMode or "Global", v27.SpawnRotation, v27.SpawnEmitterRotation);
            v27._prevWorldOff = v32;

            if v29 ~= 0 or (v30 ~= 0 or v31 ~= 0) then
                v27.LocalCF = v27.LocalCF + v32;
                v27.VisualPart:PivotTo(v27.VisualPart:GetPivot() + v32);
            end;
        end;

        Turbulence.buildInto(v27, v6);
        local v33 = {};

        for _, descendant in u24:GetDescendants() do
            if descendant:IsA("Beam") and not descendant:GetAttribute("Transformed") then
                table.insert(v33, descendant);
            end;
        end;

        if #v33 > 0 then
            v27._visualBeams = v33;
        end;

        if u2._parentScaleMap and u2._parentScaleMap[p3] then
            v27.ParentScale = u2._parentScaleMap[p3];
        end;

        u24:ScaleTo(math.max(0.001, Graph.QueryPointsWithTime(0, v27.Graphs.Scale, v27.Seeds.Scale)) * PartConstants.getParentScaleFactor(v27.ParentScale, v27.StartTime, Graph));

        for _, v in ipairs(v33) do
            if v.Segments < 20 then
                v.Segments = 20;
            end;
        end;

        u24.Parent = v6.EmitParent or u2:GetFolder();
        Pool.restoreTrails(u24, "Model");

        for _, descendant in u24:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;

        local v34 = u2:_makeAliveCheck();

        for _, descendant in u24:GetDescendants() do
            Particles.EnableEmitSingle(descendant, v34);
        end;

        v27._sourceItem = p3;
        u1._seedTsOverride(v27, p3);

        if v6.Pool ~= false then
            v27._sourceRT = v6.RenderTemplate;
            v27._poolKind = "Model";
        end;

        StaticPass.apply(v27);
        u2:_applyEmitVisualPasses(v27);
        u2:_registerEmit(v27, p5);
        v27._nestedAlive = { true };
        u2._parentScaleMap = u2._parentScaleMap or {};
        local u35 = {
            Graph = v27.Graphs.Scale,
            Seed = v27.Seeds.Scale,
            StaticValue = v27._staticScale or (v27.Graphs.Scale == nil and 1 or nil),
            TotalKeyFrames = v27.TotalKeyFrames,
            StartTime = v27.StartTime,
            LifeTime = v27.LifeTime,
            ScaleTextureLength = v6.ScaleTextureLength ~= false,
            ScaleMotion = v6.ScaleMotion ~= false,
            ScaleRotation = v6.ScaleRotation == true,
            Parent = v27.ParentScale
        };
        local u36 = {};
        NestedEmit.walk(u2, v6.RenderTemplate, u24, v27._nestedAlive, p5, function(p37) -- Line: 278
            -- upvalues: u2 (copy), u35 (copy), u36 (copy)
            u2._parentScaleMap[p37] = u35;
            u36[#u36 + 1] = p37;
        end);
        v27._scaleMapKeys = u36;
    end;

    function u1.EmitModelAnimate(p38, u39, p40, p41) -- Line: 286
        -- upvalues: Range (ref), DirectionVectors (ref), AxisLinks (ref), PartConstants (ref), Graph (ref), Turbulence (ref), Particles (ref), u1 (copy), StaticPass (ref), Events (ref)
        if not (u39 and u39.Parent) then
            return;
        end;

        local v42 = p38:GetData(u39);

        if not (v42 and v42.RenderTemplate) then
            return;
        end;

        local v43 = p40 or v42.Link;
        local v44 = Range.RandomValueFromRange(v42.Lifetime);
        local v45 = v44 <= 0 and 0.001 or v44;
        local RenderTemplate = v42.RenderTemplate;
        local v46 = RenderTemplate:GetPivot();
        local v47 = u39:GetPivot();
        local v48 = DirectionVectors[v42.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
        local v49 = v47[v48.vector] * v48.multiplier;
        local v50 = v42.DirMode or "RigidLocal";
        local v51 = AxisLinks.sampleRangeAxes(v42, v42.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, p41);
        local v52 = PartConstants.composeRotation(v42.RotOrder or "Global", v51.RotX, v51.RotY, v51.RotZ);
        local v53 = PartConstants.applyPositionOffset(v47 * v52, v42, v43, u39, Range, AxisLinks, p41);

        if v50 == "Global" then
            v53 = CFrame.new(v53.Position) * v52;
        end;

        if v50 == "Local" then
            v49 = v53[v48.vector] * v48.multiplier;
        elseif v50 == "Global" then
            v49 = CFrame.new()[v48.vector] * v48.multiplier;
        end;

        local v54, v55;

        if v42.ParticleData.SpreadAngle.X > 0 or v42.ParticleData.SpreadAngle.Y > 0 then
            v54 = (math.random() * 2 - 1) * v42.ParticleData.SpreadAngle.X;
            v55 = (math.random() * 2 - 1) * v42.ParticleData.SpreadAngle.Y;
        else
            v55 = 0;
            v54 = 0;
        end;

        local v56 = CFrame.Angles(math.rad(v54), math.rad(v55), 0);
        local LookVector = (CFrame.lookAt(Vector3.new(), v49) * v56).LookVector;
        local v57 = {
            RotSpeedX = Graph.GenerateSeed(v42.RotSpeedX),
            RotSpeedY = Graph.GenerateSeed(v42.RotSpeedY),
            RotSpeedZ = Graph.GenerateSeed(v42.RotSpeedZ),
            PosOffsetX = Graph.GenerateSeed(v42.PosOffsetX),
            PosOffsetY = Graph.GenerateSeed(v42.PosOffsetY),
            PosOffsetZ = Graph.GenerateSeed(v42.PosOffsetZ),
            Speed = Graph.GenerateSeed(v42.Speed),
            Scale = Graph.GenerateSeed(v42.Scale),
            Timescale = Graph.GenerateSeed(v42.Timescale)
        };
        AxisLinks.applyGraphAxisAliases(v42, v57, v42.AxisLinks);
        local InvertMotion = v42.InvertMotion;
        local v58, v59;

        if InvertMotion then
            v58, v59 = p38:PreSimulateForward(v42, v57, v53, LookVector, v56, v43, v45, nil, v53.Rotation * v52:Inverse());
        else
            v59 = nil;
            v58 = nil;
        end;

        local v60;

        if v43 then
            v60 = PartConstants.resolveLinkCFrame(v43);

            if v42.LinkMode == "Follow" or v42.LinkMode == "Pivot" then
                v60 = CFrame.new(v60.Position) or v60;
            end;
        else
            v60 = CFrame.new();
        end;

        if InvertMotion and v58 then
            v53 = v58[v59 or v42.TotalKeyFrames] or v58[0];
        elseif v43 then
            v53 = v60:ToObjectSpace(v53) or v53;
        end;

        RenderTemplate:PivotTo(v60 * v53);
        local v61 = {
            Type = "Model",
            VisualPart = RenderTemplate,
            Link = v43,
            LinkMode = v42.LinkMode
        };

        if v42.LinkMode ~= "RigidLocal" or not (v43 and v60) then
            v60 = nil;
        end;

        v61._rigidLocalParentCF = v60;
        v61.Events = v42.Events;
        v61.StartTime = os.clock();
        v61.TotalKeyFrames = InvertMotion and v59 and v59 or math.max(1, v42.TotalKeyFrames);
        v61.CurrentStep = 0;
        v61.AccumulatedDT = 0;
        v61.LifeTime = v45;
        v61.PartLife = v42.PartLife or 0;
        v61.CurrentPosition = RenderTemplate:GetPivot().Position;
        v61.LocalCF = v53;
        v61.BaseDirection = LookVector;
        v61._accelVel = Vector3.new(0, 0, 0);
        v61.SpeedMultiplier = 1;
        v61._spinRate = Vector3.new(0, 0, 0);
        v61._spinAccumX = 0;
        v61._spinAccumY = 0;
        v61._spinAccumZ = 0;
        v61.EmissionDirection = v42.EmissionDirection;
        v61.SpreadRotation = v56;
        v61.Acceleration = v42.ParticleData.Acceleration;
        v61.Drag = v42.ParticleData.Drag;
        v61.VelocityVectored = v42.VelocityVectored;
        v61.InvertMotion = InvertMotion;
        v61.SimLocalCFrames = v58;
        v61.RotMode = v42.RotMode or "OverLife";
        v61.RotOrder = v42.RotOrder or "Global";
        v61.AccRotX = 0;
        v61.AccRotY = 0;
        v61.AccRotZ = 0;
        v61.Orientation = v42.Orientation;
        v61.ZOffset = v42.ZOffset;
        v61._localWorldCF = v53;
        v61.SpawnRotation = v53.Rotation;
        v61.SpawnEmitterRotation = v53.Rotation * v52:Inverse();
        v61.DisplacementMode = v42.DisplacementMode;
        v61._sleepRadius = 1;
        v61._prevWorldOff = Vector3.new(0, 0, 0);
        v61.HasPosOffsetGraphs = (v42.PosOffsetX ~= nil or v42.PosOffsetY ~= nil) and true or v42.PosOffsetZ ~= nil;
        v61.NeedsFullIteration = v42.VelocityVectored;
        local v62;

        if v42.RotMode == "Speed" then
            v62 = not v42.VelocityVectored;
        else
            v62 = false;
        end;

        v61.NeedsRotAccum = v62;
        v61.HasDrag = v42.ParticleData.Drag ~= 0;
        v61.HasAccel = v42.ParticleData.Acceleration.Magnitude > 0;
        v61.Graphs = {
            RotSpeedX = v42.RotSpeedX,
            RotSpeedY = v42.RotSpeedY,
            RotSpeedZ = v42.RotSpeedZ,
            PosOffsetX = v42.PosOffsetX,
            PosOffsetY = v42.PosOffsetY,
            PosOffsetZ = v42.PosOffsetZ,
            Speed = v42.Speed,
            Scale = v42.Scale,
            Timescale = v42.Timescale
        };
        v61.Seeds = v57;
        v61._effectiveElapsed = Graph.InitialEffectiveElapsed(v42.Timescale, v57.Timescale, v45);
        v61.IsAnimate = true;
        v61.AnimateItem = u39;
        v61.InitialAnchorCF = v46;
        v61.InitialLocalCF = v53;
        local success, result = pcall(function() -- Line: 432
            -- upvalues: u39 (copy)
            return u39:GetScale();
        end);
        v61.InitialScale = success and result and result or 1;

        if v61.HasPosOffsetGraphs then
            local v63 = v61.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(0, v61.Graphs.PosOffsetX, v61.Seeds.PosOffsetX) or 0) or 0;
            local v64 = v61.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(0, v61.Graphs.PosOffsetY, v61.Seeds.PosOffsetY) or 0) or 0;
            local v65 = v61.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(0, v61.Graphs.PosOffsetZ, v61.Seeds.PosOffsetZ) or 0) or 0;
            local v66 = PartConstants.resolveDisplacement(Vector3.new(v63, v64, v65), v42.DisplacementMode or "Global", v61.SpawnRotation, v61.SpawnEmitterRotation);
            v61._prevWorldOff = v66;

            if v63 ~= 0 or (v64 ~= 0 or v65 ~= 0) then
                v61.LocalCF = v61.LocalCF + v66;
                v61.VisualPart:PivotTo(v61.VisualPart:GetPivot() + v66);
            end;
        end;

        Turbulence.buildInto(v61, v42);
        local v67 = {};

        for _, descendant in RenderTemplate:GetDescendants() do
            if descendant:IsA("Beam") and not descendant:GetAttribute("Transformed") then
                table.insert(v67, descendant);
            end;
        end;

        if #v67 > 0 then
            v61._visualBeams = v67;
        end;

        if p38._parentScaleMap and p38._parentScaleMap[u39] then
            v61.ParentScale = p38._parentScaleMap[u39];
        end;

        RenderTemplate:ScaleTo(math.max(0.001, Graph.QueryPointsWithTime(0, v61.Graphs.Scale, v61.Seeds.Scale)) * PartConstants.getParentScaleFactor(v61.ParentScale, v61.StartTime, Graph));

        for _, v in ipairs(v67) do
            if v.Segments < 20 then
                v.Segments = 20;
            end;
        end;

        local v68 = p38:_makeAliveCheck();

        for _, descendant in RenderTemplate:GetDescendants() do
            Particles.EnableEmitSingle(descendant, v68);
        end;

        v61._sourceItem = u39;
        u1._seedTsOverride(v61, u39);
        StaticPass.apply(v61);
        p38.ActiveAnimates[u39] = v61;
        p38:_applyEmitVisualPasses(v61);
        p38:_registerEmit(v61, p41);
        p38._parentScaleMap = p38._parentScaleMap or {};
        local v69 = {
            Graph = v61.Graphs.Scale,
            Seed = v61.Seeds.Scale,
            StaticValue = v61._staticScale or (v61.Graphs.Scale == nil and 1 or nil),
            TotalKeyFrames = v61.TotalKeyFrames,
            StartTime = v61.StartTime,
            LifeTime = v61.LifeTime,
            ScaleTextureLength = v42.ScaleTextureLength ~= false,
            ScaleMotion = v42.ScaleMotion ~= false,
            ScaleRotation = v42.ScaleRotation == true,
            Parent = v61.ParentScale
        };
        local v70 = {};

        for _, descendant in RenderTemplate:GetDescendants() do
            if descendant:GetAttribute("Transformed") then
                p38._parentScaleMap[descendant] = v69;
                v70[#v70 + 1] = descendant;
                p38:EnableEmit(descendant, descendant.Parent, Events.descendCtx(p41));
            end;
        end;

        v61._scaleMapKeys = v70;
    end;
end;