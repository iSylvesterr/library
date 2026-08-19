-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local Particles = require(script.Parent.Particles);
local PartConstants = require(script.Parent.PartConstants);
local AxisLinks = require(script.Parent.AxisLinks);
local Events = require(script.Parent.Events);
local StaticPass = require(script.Parent.StaticPass);
local DirectionVectors = PartConstants.DirectionVectors;
local shapeFunctions = PartConstants.shapeFunctions;

return function(u1) -- Line: 18
    -- upvalues: Range (copy), PartConstants (copy), DirectionVectors (copy), shapeFunctions (copy), AxisLinks (copy), Graph (copy), Particles (copy), StaticPass (copy), Events (copy)
    function u1.EmitPartAnimate(p2, p3, p4, p5) -- Line: 21
        -- upvalues: Range (ref), PartConstants (ref), DirectionVectors (ref), shapeFunctions (ref), AxisLinks (ref), Graph (ref), Particles (ref), u1 (copy), StaticPass (ref), Events (ref)
        if not (p3 and p3.Parent) then
            return;
        end;

        local v6 = p2:GetData(p3);

        if not (v6 and v6.RenderTemplate) then
            return;
        end;

        local v7 = p4 or v6.Link;
        local v8 = Range.RandomValueFromRange(v6.Lifetime);
        local v9 = v8 <= 0 and 0.001 or v8;
        local RenderTemplate = v6.RenderTemplate;
        local CFrame2 = RenderTemplate.CFrame;
        local v10;

        if v7 then
            local v11 = PartConstants.resolveLinkCFrame(v7);
            local Position = v11.Position;

            if v6.LinkMode == "Follow" then
                v10 = CFrame.new(Position) * p3.CFrame.Rotation;
            else
                v10 = CFrame.new(Position) * v11.Rotation * p3.CFrame.Rotation;
            end;
        else
            v10 = p3.CFrame;
        end;

        local v12 = DirectionVectors[v6.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
        local v13 = v10[v12.vector] * v12.multiplier;
        local v14 = Vector3.new();
        local v15 = nil;
        local v16;

        if v6.UseShape then
            local v17 = shapeFunctions[v6.ParticleData.Shape];

            if v17 then
                local v18;

                if v6.ShapePart then
                    v18 = v6.ShapePart.CFrame or v10;
                else
                    v18 = v10;
                end;

                local v19, v20, v21 = v17(v6.ShapePart or p3, v6.ParticleData);
                local ShapeInOut = v6.ParticleData.ShapeInOut;

                if ShapeInOut == Enum.ParticleEmitterShapeInOut.Inward then
                    v21 = -v21;
                elseif ShapeInOut == Enum.ParticleEmitterShapeInOut.InAndOut and math.random() < 0.5 then
                    v21 = -v21;
                end;

                v15 = (v18 - v18.Position):VectorToWorldSpace(v21);

                if v6.ParticleData.LookAtInitially then
                    local v22, v23, v24 = v10:ToEulerAnglesXYZ();
                    v16 = CFrame.new((v18 * CFrame.new(v19)).Position) * v20 * CFrame.Angles(v22, v23, v24);
                else
                    v16 = CFrame.new((v18 * CFrame.new(v19)).Position) * v10.Rotation;
                end;
            else
                v16 = CFrame.new((v10 * CFrame.new(v14)).Position) * v10.Rotation;
            end;
        else
            v16 = CFrame.new((v10 * CFrame.new(v14)).Position) * v10.Rotation;
        end;

        local v25 = v6.DirMode or "RigidLocal";
        local v26 = AxisLinks.sampleRangeAxes(v6, v6.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, p5);
        local v27 = PartConstants.composeRotation(v6.RotOrder or "Global", v26.RotX, v26.RotY, v26.RotZ);
        local v28 = PartConstants.applyPositionOffset(v16 * v27, v6, v7, p3, Range, AxisLinks, p5);

        if v25 == "Global" then
            v28 = CFrame.new(v28.Position) * v27;
        end;

        if v15 then
            v13 = v15;
        elseif v25 == "Local" then
            v13 = v28[v12.vector] * v12.multiplier;
        elseif v25 == "Global" then
            v13 = CFrame.new()[v12.vector] * v12.multiplier;
        end;

        local v29, v30;

        if v6.ParticleData.SpreadAngle.X > 0 or v6.ParticleData.SpreadAngle.Y > 0 then
            v29 = (math.random() * 2 - 1) * v6.ParticleData.SpreadAngle.X;
            v30 = (math.random() * 2 - 1) * v6.ParticleData.SpreadAngle.Y;
        else
            v29 = 0;
            v30 = 0;
        end;

        local v31 = CFrame.Angles(math.rad(v29), math.rad(v30), 0);
        local LookVector = (CFrame.lookAt(Vector3.new(), v13) * v31).LookVector;
        local v32 = {
            SizeX = Graph.GenerateSeed(v6.SizeX),
            SizeY = Graph.GenerateSeed(v6.SizeY),
            SizeZ = Graph.GenerateSeed(v6.SizeZ),
            RotSpeedX = Graph.GenerateSeed(v6.RotSpeedX),
            RotSpeedY = Graph.GenerateSeed(v6.RotSpeedY),
            RotSpeedZ = Graph.GenerateSeed(v6.RotSpeedZ),
            PosOffsetX = Graph.GenerateSeed(v6.PosOffsetX),
            PosOffsetY = Graph.GenerateSeed(v6.PosOffsetY),
            PosOffsetZ = Graph.GenerateSeed(v6.PosOffsetZ),
            Speed = Graph.GenerateSeed(v6.Speed),
            Brightness = Graph.GenerateSeed(v6.Brightness),
            Transparency = Graph.GenerateSeed(v6.Transparency),
            AccelStrength = Graph.GenerateSeed(v6.AccelStrength),
            Timescale = Graph.GenerateSeed(v6.Timescale)
        };
        AxisLinks.applyGraphAxisAliases(v6, v32, v6.AxisLinks);
        local InvertMotion = v6.InvertMotion;
        local v33, v34;

        if InvertMotion then
            v33, v34 = p2:PreSimulateForward(v6, v32, v28, LookVector, v31, v7, v9, nil, v28.Rotation * v27:Inverse());
        else
            v33 = nil;
            v34 = nil;
        end;

        local v35;

        if v7 then
            v35 = PartConstants.resolveLinkCFrame(v7);

            if v6.LinkMode == "Follow" or v6.LinkMode == "Pivot" then
                v35 = CFrame.new(v35.Position) or v35;
            end;
        else
            v35 = CFrame.new();
        end;

        if InvertMotion and v33 then
            v28 = v33[v34 or v6.TotalKeyFrames] or v33[0];
        elseif v7 then
            v28 = v35:ToObjectSpace(v28) or v28;
        end;

        RenderTemplate.CFrame = v35 * v28;
        local u36 = {
            Type = "Part",
            VisualPart = RenderTemplate,
            Link = v7,
            LinkMode = v6.LinkMode
        };

        if v6.LinkMode ~= "RigidLocal" or not (v7 and v35) then
            v35 = nil;
        end;

        u36._rigidLocalParentCF = v35;
        u36.Events = v6.Events;
        u36.SpecialMesh = RenderTemplate:FindFirstChildOfClass("SpecialMesh");
        u36.Decal = RenderTemplate:FindFirstChildOfClass("Decal");
        u36.SurfaceAppearance = RenderTemplate:FindFirstChildOfClass("SurfaceAppearance");
        local v37 = RenderTemplate:FindFirstChildOfClass("SurfaceAppearance");
        u36._initialSAColor = v37 and v37.Color or nil;
        local v38;

        if RenderTemplate:IsA("BasePart") then
            v38 = RenderTemplate.Color or nil;
        else
            v38 = nil;
        end;

        u36._initialPartColor = v38;
        u36.StartTime = os.clock();
        u36.TotalKeyFrames = InvertMotion and v34 and v34 or math.max(1, v6.TotalKeyFrames);
        u36.CurrentStep = 0;
        u36.AccumulatedDT = 0;
        u36.LifeTime = v9;
        u36.PartLife = v6.PartLife or 0;
        u36.CurrentPosition = RenderTemplate.Position;
        u36.LocalCF = v28;
        u36.BaseDirection = LookVector;
        u36._initialBaseDirection = LookVector;
        u36.EmissionDirection = v6.EmissionDirection;
        u36.SpreadRotation = v31;
        u36.Acceleration = v6.ParticleData.Acceleration;
        u36.Drag = v6.ParticleData.Drag;
        u36.VelocityVectored = v6.VelocityVectored;
        u36.InvertMotion = InvertMotion;
        u36.SimLocalCFrames = v33;
        u36.RotMode = v6.RotMode or "OverLife";
        u36.RotOrder = v6.RotOrder or "Global";
        u36.AccRotX = 0;
        u36.AccRotY = 0;
        u36.AccRotZ = 0;
        u36.Orientation = v6.Orientation;
        u36.ZOffset = v6.ZOffset;
        u36._localWorldCF = v28;
        u36.SpawnRotation = v28.Rotation;
        u36.SpawnEmitterRotation = v28.Rotation * v27:Inverse();
        u36.DisplacementMode = v6.DisplacementMode;
        u36._sleepRadius = RenderTemplate and RenderTemplate:IsA("BasePart") and (RenderTemplate.Size.Magnitude * 0.5 or 1) or 1;
        u36._prevWorldOff = Vector3.new(0, 0, 0);
        u36.HasPosOffsetGraphs = (v6.PosOffsetX ~= nil or v6.PosOffsetY ~= nil) and true or v6.PosOffsetZ ~= nil;
        u36.NeedsFullIteration = v6.VelocityVectored;
        local v39;

        if v6.RotMode == "Speed" then
            v39 = not v6.VelocityVectored;
        else
            v39 = false;
        end;

        u36.NeedsRotAccum = v39;
        u36.HasDrag = v6.ParticleData.Drag ~= 0;
        u36.HasAccel = v6.ParticleData.Acceleration.Magnitude > 0;
        u36.HasDecal = RenderTemplate:FindFirstChildOfClass("Decal") ~= nil;
        local v40;

        if v6.AccelerationTowardsInstance == true and (v6.AccelTarget ~= nil and v6.AccelStrength ~= nil) then
            v40 = not v6.InvertMotion;
        else
            v40 = false;
        end;

        u36.HasTargetAccel = v40;
        u36.AccelTarget = v6.AccelTarget;
        u36.TargetVel = Vector3.new(0, 0, 0);
        u36.Graphs = {
            SizeX = v6.SizeX,
            SizeY = v6.SizeY,
            SizeZ = v6.SizeZ,
            RotSpeedX = v6.RotSpeedX,
            RotSpeedY = v6.RotSpeedY,
            RotSpeedZ = v6.RotSpeedZ,
            PosOffsetX = v6.PosOffsetX,
            PosOffsetY = v6.PosOffsetY,
            PosOffsetZ = v6.PosOffsetZ,
            Speed = v6.Speed,
            Brightness = v6.Brightness,
            Transparency = v6.Transparency,
            Color = v6.Color,
            AccelStrength = v6.AccelStrength,
            Timescale = v6.Timescale
        };
        u36.Seeds = v32;
        u36._effectiveElapsed = Graph.InitialEffectiveElapsed(v6.Timescale, v32.Timescale, v9);
        u36.IsAnimate = true;
        u36.AnimateItem = p3;
        u36.InitialAnchorCF = CFrame2;
        u36.InitialLocalCF = v28;

        if u36.HasPosOffsetGraphs then
            local v41 = u36.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(0, u36.Graphs.PosOffsetX, u36.Seeds.PosOffsetX) or 0) or 0;
            local v42 = u36.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(0, u36.Graphs.PosOffsetY, u36.Seeds.PosOffsetY) or 0) or 0;
            local v43 = u36.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(0, u36.Graphs.PosOffsetZ, u36.Seeds.PosOffsetZ) or 0) or 0;
            local v44 = PartConstants.resolveDisplacement(Vector3.new(v41, v42, v43), v6.DisplacementMode or "Global", u36.SpawnRotation, u36.SpawnEmitterRotation);
            u36._prevWorldOff = v44;

            if v41 ~= 0 or (v42 ~= 0 or v43 ~= 0) then
                u36.LocalCF = u36.LocalCF + v44;
                u36.VisualPart.CFrame = u36.VisualPart.CFrame + v44;
            end;
        end;

        local v45 = Graph.QueryPointsWithTime(0, u36.Graphs.SizeX, u36.Seeds.SizeX);
        local v46 = Graph.QueryPointsWithTime(0, u36.Graphs.SizeY, u36.Seeds.SizeY);
        local v47 = Vector3.new(v45, v46, Graph.QueryPointsWithTime(0, u36.Graphs.SizeZ, u36.Seeds.SizeZ));
        local v48 = Graph.QueryPointsWithTime(0, u36.Graphs.Transparency, u36.Seeds.Transparency);
        local u49 = Graph.QueryColorPointWithTime(0, u36.Graphs.Color);
        local u50 = Graph.QueryPointsWithTime(0, u36.Graphs.Brightness, u36.Seeds.Brightness);

        if u36.SpecialMesh then
            u36.SpecialMesh.Scale = v47;
        else
            u36.VisualPart.Size = v47;
        end;

        if u36.SurfaceAppearance then
            u36.VisualPart.Transparency = v48;
            u36.VisualPart.Color = Color3.fromRGB(u49.R * 255, u49.G * 255, u49.B * 255);
            u36.SurfaceAppearance.Color = Color3.fromRGB(u49.R * 255, u49.G * 255, u49.B * 255);
            pcall(function() -- Line: 250
                -- upvalues: u36 (copy), u49 (copy), u50 (copy)
                u36.SurfaceAppearance.EmissiveTint = Color3.new(u49.R * u50, u49.G * u50, u49.B * u50);
            end);
        elseif u36.Decal then
            u36.Decal.Transparency = v48;
            u36.Decal.Color3 = Color3.fromRGB(u49.R * 255 * u50, u49.G * 255 * u50, u49.B * 255 * u50);
        else
            u36.VisualPart.Transparency = v48;
            u36.VisualPart.Color = Color3.fromRGB(u49.R * 255, u49.G * 255, u49.B * 255);
        end;

        local v51 = p2:_makeAliveCheck();

        for _, child in RenderTemplate:GetChildren() do
            if child:IsA("Attachment") then
                Particles.EnableEmitChildrenAndRepeatForAttachments(child, v51);
            end;

            Particles.EnableEmitSingle(child, v51);
        end;

        if p2._parentScaleMap and p2._parentScaleMap[p3] then
            u36.ParentScale = p2._parentScaleMap[p3];
        end;

        u36._sourceItem = p3;
        u1._seedTsOverride(u36, p3);
        StaticPass.apply(u36);
        p2.ActiveAnimates[p3] = u36;
        p2:_applyEmitVisualPasses(u36);
        p2:_registerEmit(u36, p5);

        for _, descendant in RenderTemplate:GetDescendants() do
            if descendant:GetAttribute("Transformed") then
                p2:EnableEmit(descendant, descendant.Parent, Events.descendCtx(p5));
            end;
        end;
    end;

    function u1.EmitAttachmentAnimate(p52, p53, p54, p55) -- Line: 286
        -- upvalues: Range (ref), DirectionVectors (ref), AxisLinks (ref), PartConstants (ref), Graph (ref), u1 (copy), StaticPass (ref), Particles (ref), Events (ref)
        if not (p53 and p53.Parent) then
            return;
        end;

        local v56 = p52:GetData(p53);

        if not (v56 and v56.RenderTemplate) then
            return;
        end;

        local v57 = p54 or v56.Link;
        local v58 = Range.RandomValueFromRange(v56.Lifetime);
        local v59 = v58 <= 0 and 0.001 or v58;
        local RenderTemplate = v56.RenderTemplate;
        local CFrame2 = RenderTemplate.CFrame;
        local v60 = CFrame.new();
        local v61 = DirectionVectors[v56.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
        local v62 = v56.DirMode or "RigidLocal";
        local v63 = AxisLinks.sampleRangeAxes(v56, v56.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, p55);
        local v64 = PartConstants.composeRotation(v56.RotOrder or "Global", v63.RotX, v63.RotY, v63.RotZ);
        local v65 = v60 * v64;
        local v66;

        if v62 == "Local" then
            v66 = v65[v61.vector] * v61.multiplier;
        elseif v62 == "Global" then
            local v67 = CFrame.new()[v61.vector] * v61.multiplier;
            v66 = p53.WorldCFrame:VectorToObjectSpace(v67);
        else
            v66 = v60[v61.vector] * v61.multiplier;
        end;

        local v68 = PartConstants.applyPositionOffset(v65, v56, v57, p53, Range, AxisLinks, p55, p53.WorldCFrame);

        if v62 == "Global" then
            v68 = CFrame.new(v68.Position) * p53.WorldCFrame.Rotation:Inverse() * v64;
        end;

        local v69, v70;

        if v56.ParticleData.SpreadAngle.X > 0 or v56.ParticleData.SpreadAngle.Y > 0 then
            v69 = (math.random() * 2 - 1) * v56.ParticleData.SpreadAngle.X;
            v70 = (math.random() * 2 - 1) * v56.ParticleData.SpreadAngle.Y;
        else
            v70 = 0;
            v69 = 0;
        end;

        local v71 = CFrame.Angles(math.rad(v69), math.rad(v70), 0);
        local LookVector = (CFrame.lookAt(Vector3.new(), v66) * v71).LookVector;
        local v72 = {
            Speed = Graph.GenerateSeed(v56.Speed),
            RotSpeedX = Graph.GenerateSeed(v56.RotSpeedX),
            RotSpeedY = Graph.GenerateSeed(v56.RotSpeedY),
            RotSpeedZ = Graph.GenerateSeed(v56.RotSpeedZ),
            PosOffsetX = Graph.GenerateSeed(v56.PosOffsetX),
            PosOffsetY = Graph.GenerateSeed(v56.PosOffsetY),
            PosOffsetZ = Graph.GenerateSeed(v56.PosOffsetZ),
            Timescale = Graph.GenerateSeed(v56.Timescale)
        };
        AxisLinks.applyGraphAxisAliases(v56, v72, v56.AxisLinks);
        local InvertMotion = v56.InvertMotion;
        local v73, v74;

        if InvertMotion then
            v73, v74 = p52:PreSimulateAttachmentForward(v56, v72, v68, LookVector, v71, v59, nil, v68.Rotation * v64:Inverse());
        else
            v73 = nil;
            v74 = nil;
        end;

        if InvertMotion and v73 then
            v68 = v73[v74 or v56.TotalKeyFrames] or v73[0];
        end;

        RenderTemplate.CFrame = v68;
        local v75 = {
            Type = "Attachment",
            VisualPart = RenderTemplate,
            Link = v57,
            LinkMode = v56.LinkMode
        };
        local v76;

        if v56.LinkMode == "RigidLocal" and v57 then
            v76 = PartConstants.resolveLinkCFrame(v57) or nil;
        else
            v76 = nil;
        end;

        v75._rigidLocalParentCF = v76;
        v75.Events = v56.Events;
        v75.StartTime = os.clock();
        v75.TotalKeyFrames = InvertMotion and v74 and v74 or math.max(1, v56.TotalKeyFrames);
        v75.CurrentStep = 0;
        v75.AccumulatedDT = 0;
        v75.LifeTime = v59;
        v75.PartLife = v56.PartLife or 0;
        v75.LocalCF = v68;
        v75._localWorldCF = v68;
        v75.BaseDirection = LookVector;
        v75._initialBaseDirection = LookVector;
        v75.EmissionDirection = v56.EmissionDirection;
        v75.SpreadRotation = v71;
        v75.Acceleration = v56.ParticleData.Acceleration;
        v75.Drag = v56.ParticleData.Drag;
        v75.VelocityVectored = v56.VelocityVectored;
        v75.InvertMotion = InvertMotion;
        v75.SimLocalCFrames = v73;
        v75.RotMode = v56.RotMode or "OverLife";
        v75.RotOrder = v56.RotOrder or "Global";
        v75.AccRotX = 0;
        v75.AccRotY = 0;
        v75.AccRotZ = 0;
        v75.Orientation = v56.Orientation;
        v75.ZOffset = v56.ZOffset;
        v75.NeedsFullIteration = v56.VelocityVectored;
        local v77;

        if v56.RotMode == "Speed" then
            v77 = not v56.VelocityVectored;
        else
            v77 = false;
        end;

        v75.NeedsRotAccum = v77;
        v75.HasDrag = v56.ParticleData.Drag ~= 0;
        v75.HasAccel = v56.ParticleData.Acceleration.Magnitude > 0;
        v75.SpawnRotation = v68.Rotation;
        v75.SpawnEmitterRotation = v68.Rotation * v64:Inverse();
        v75.DisplacementMode = v56.DisplacementMode;
        v75._sleepRadius = visualPart and (visualPart:IsA("BasePart") and visualPart.Size.Magnitude * 0.5) or 1;
        v75._prevWorldOff = Vector3.new(0, 0, 0);
        v75.HasPosOffsetGraphs = (v56.PosOffsetX ~= nil or v56.PosOffsetY ~= nil) and true or v56.PosOffsetZ ~= nil;
        v75.Graphs = {
            Speed = v56.Speed,
            RotSpeedX = v56.RotSpeedX,
            RotSpeedY = v56.RotSpeedY,
            RotSpeedZ = v56.RotSpeedZ,
            PosOffsetX = v56.PosOffsetX,
            PosOffsetY = v56.PosOffsetY,
            PosOffsetZ = v56.PosOffsetZ,
            Timescale = v56.Timescale
        };
        v75.Seeds = v72;
        v75._effectiveElapsed = Graph.InitialEffectiveElapsed(v56.Timescale, v72.Timescale, v59);
        v75.IsAnimate = true;
        v75.AnimateItem = p53;
        v75.InitialAnchorCF = CFrame2;
        v75.InitialLocalCF = v68;

        if v75.HasPosOffsetGraphs then
            local v78 = v75.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(0, v75.Graphs.PosOffsetX, v75.Seeds.PosOffsetX) or 0) or 0;
            local v79 = v75.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(0, v75.Graphs.PosOffsetY, v75.Seeds.PosOffsetY) or 0) or 0;
            local v80 = v75.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(0, v75.Graphs.PosOffsetZ, v75.Seeds.PosOffsetZ) or 0) or 0;
            local v81 = PartConstants.resolveDisplacement(Vector3.new(v78, v79, v80), v56.DisplacementMode or "Global", v75.SpawnRotation, v75.SpawnEmitterRotation);
            v75._prevWorldOff = v81;

            if v78 ~= 0 or (v79 ~= 0 or v80 ~= 0) then
                v75.LocalCF = v75.LocalCF + v81;
                v75.VisualPart.CFrame = v75.VisualPart.CFrame + v81;
            end;
        end;

        v75._sourceItem = p53;
        u1._seedTsOverride(v75, p53);
        StaticPass.apply(v75);
        p52.ActiveAnimates[p53] = v75;
        p52:_applyEmitVisualPasses(v75);
        p52:_registerEmit(v75, p55);
        local v82 = p52:_makeAliveCheck();

        for _, child in RenderTemplate:GetChildren() do
            if child:IsA("Attachment") then
                Particles.EnableEmitChildrenAndRepeatForAttachments(child, v82);
            end;

            Particles.EnableEmitSingle(child, v82);
        end;

        for _, descendant in RenderTemplate:GetDescendants() do
            if descendant:GetAttribute("Transformed") then
                p52:EnableEmit(descendant, descendant.Parent, Events.descendCtx(p55));
            end;
        end;
    end;

    function u1.EmitBeamAnimate(p83, p84, p85, p86) -- Line: 455
        -- upvalues: Graph (ref), Range (ref), u1 (copy)
        if not (p84 and p84.Parent) then
            return;
        end;

        local v87 = p83:GetData(p84);

        if not (v87 and v87.RenderTemplate) then
            return;
        end;

        local RenderTemplate = v87.RenderTemplate;
        local v88 = {
            Brightness = RenderTemplate.Brightness,
            CurveSize0 = RenderTemplate.CurveSize0,
            CurveSize1 = RenderTemplate.CurveSize1,
            Width0 = RenderTemplate.Width0,
            Width1 = RenderTemplate.Width1,
            LightEmission = RenderTemplate.LightEmission,
            LightInfluence = RenderTemplate.LightInfluence,
            Segments = RenderTemplate.Segments,
            TextureLength = RenderTemplate.TextureLength,
            TextureSpeed = RenderTemplate.TextureSpeed,
            Transparency = RenderTemplate.Transparency,
            Color = RenderTemplate.Color,
            FaceCamera = RenderTemplate.FaceCamera,
            Enabled = RenderTemplate.Enabled
        };

        if v87.FaceCamera ~= nil then
            RenderTemplate.FaceCamera = v87.FaceCamera;
        end;

        local v89 = {};

        for i, v in pairs(v87.BeamProps) do
            if v then
                if Graph.IsStatic(v) then
                    RenderTemplate[i] = Graph.GetStaticValue(v, RenderTemplate[i]);
                else
                    local v90 = Graph.GenerateSeed(v);
                    v89[i] = {
                        Sequence = v,
                        Seed = v90
                    };

                    if i ~= "TextureSpeed" then
                        local v91 = Graph.QueryPointsWithTime(0, v, v90);

                        if i == "Segments" then
                            local v92 = math.round(v91);
                            v91 = math.max(20, v92);
                        end;

                        RenderTemplate[i] = v91;
                    end;
                end;
            end;
        end;

        if v89.TextureSpeed then
            RenderTemplate.TextureSpeed = 0;
        end;

        local v93, v94 = Graph.CollectGraphStates(v87.GraphBlender);
        local v95 = {};

        for i = 1, #v93 - 1 do
            v95[i] = Graph.PrecomputeMergedTimes(v93[i].Graph, v93[i + 1].Graph);
        end;

        local v96 = {};

        for i = 1, #v94 - 1 do
            v96[i] = Graph.PrecomputeMergedColorTimes(v94[i].Graph, v94[i + 1].Graph);
        end;

        if #v93 > 0 then
            RenderTemplate.Transparency = v93[1].Graph;
        end;

        if #v94 > 0 then
            RenderTemplate.Color = v94[1].Graph;
        end;

        RenderTemplate.Enabled = true;
        local v97 = Range.RandomValueFromRange(v87.Lifetime);
        local v98 = v97 <= 0 and 0.001 or v97;
        local v99 = Graph.GenerateSeed(v87.BeamTimescale);
        local v100 = {
            Type = "Beam",
            CurrentStep = 0,
            IsAnimate = true,
            VisualPart = RenderTemplate,
            Link = p85,
            Events = v87.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v87.TotalKeyFrames),
            LifeTime = v98,
            PartLife = v87.PartLife or 0,
            AnimatedProps = v89,
            TransStates = v93,
            ColorStates = v94,
            TransMergedTimes = v95,
            ColorMergedTimes = v96,
            BeamSnapshot = v88,
            Graphs = {
                Timescale = v87.BeamTimescale
            },
            Seeds = {
                Timescale = v99
            },
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v87.BeamTimescale, v99, v98),
            AnimateItem = p84
        };

        if p83._parentScaleMap and p83._parentScaleMap[p84] then
            v100.ParentScale = p83._parentScaleMap[p84];
            v100._baseWidth0 = RenderTemplate.Width0;
            v100._baseWidth1 = RenderTemplate.Width1;
            v100._baseCurveSize0 = RenderTemplate.CurveSize0;
            v100._baseCurveSize1 = RenderTemplate.CurveSize1;
            v100._baseTextureLength = RenderTemplate.TextureLength;
            v100._baseSegments = RenderTemplate.Segments;
        end;

        v100._sourceItem = p84;
        u1._seedTsOverride(v100, p84);
        p83.ActiveAnimates[p84] = v100;
        p83:_registerEmit(v100, p86);
    end;

    function u1._refreshAnimateNonSpatial(p101, p102, p103) -- Line: 562
        -- upvalues: Graph (ref)
        if not p103 then
            return;
        end;

        if p103.EmissionDirection then
            p102.EmissionDirection = p103.EmissionDirection;
        end;

        if p103.Orientation then
            p102.Orientation = p103.Orientation;
        end;

        if p103.ZOffset ~= nil then
            p102.ZOffset = p103.ZOffset;
        end;

        if p103.RotOrder then
            p102.RotOrder = p103.RotOrder;
        end;

        if p103.PartLife ~= nil then
            p102.PartLife = p103.PartLife;
        end;

        local v104 = p103.Timescale or p103.BeamTimescale or (p103.AtmTimescale or p103.PLTimescale);

        if v104 and p102.Graphs then
            p102.Graphs.Timescale = v104;
            p102.Seeds.Timescale = Graph.GenerateSeed(v104);
        end;

        if p103.ParticleData and p103.ParticleData.SpreadAngle then
            local SpreadAngle = p103.ParticleData.SpreadAngle;
            local v105, v106;

            if SpreadAngle.X > 0 or SpreadAngle.Y > 0 then
                v105 = (math.random() * 2 - 1) * SpreadAngle.X;
                v106 = (math.random() * 2 - 1) * SpreadAngle.Y;
            else
                v105 = 0;
                v106 = 0;
            end;

            p102.SpreadRotation = CFrame.Angles(math.rad(v105), math.rad(v106), 0);
        end;
    end;
end;