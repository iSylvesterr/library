-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local AxisLinks = require(script.Parent.AxisLinks);
local Particles = require(script.Parent.Particles);
local Flipbook = require(script.Parent.Flipbook);
require(script.Parent.Events);
local PartConstants = require(script.Parent.PartConstants);
local Pool = require(script.Parent.Pool);
local NestedEmit = require(script.Parent.NestedEmit);
local StaticPass = require(script.Parent.StaticPass);
local DirectionVectors = PartConstants.DirectionVectors;
local shapeFunctions = PartConstants.shapeFunctions;

local function _findBasePartAncestor(p1) -- Line: 23
    local Parent = p1.Parent;

    while Parent do
        if Parent:IsA("BasePart") then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

return function(u2) -- Line: 32
    -- upvalues: Range (copy), PartConstants (copy), DirectionVectors (copy), shapeFunctions (copy), AxisLinks (copy), Graph (copy), Pool (copy), Particles (copy), StaticPass (copy), Flipbook (copy), NestedEmit (copy)
    function u2.EmitPart(p3, p4, p5, p6) -- Line: 38
        -- upvalues: Range (ref), PartConstants (ref), DirectionVectors (ref), shapeFunctions (ref), AxisLinks (ref), Graph (ref), Pool (ref), Particles (ref), u2 (copy), StaticPass (ref), Flipbook (ref), NestedEmit (ref)
        if not (p4 and p4.Parent) then
            return;
        end;

        local v7 = p3:GetData(p4);

        if not (v7 and v7.RenderTemplate) then
            return;
        end;

        local v8;

        if p6 and p6.IgnoreLink then
            v8 = nil;
        else
            v8 = p5 or v7.Link;
        end;

        local v9 = Range.RandomValueFromRange(v7.Lifetime);
        local v10 = v9 <= 0 and 0.001 or v9;
        local v11 = nil;

        if p6 then
            if p6.EventOriginResolver then
                v11 = p6.EventOriginResolver();
            end;

            v11 = v11 or p6.EventOriginCF;
        end;

        if v11 then
            if not (p6 and p6.UseFullOrigin) then
                v11 = CFrame.new(v11.Position) * p4.CFrame.Rotation;
            end;
        elseif v8 then
            local v12 = PartConstants.resolveLinkCFrame(v8);
            local Position = v12.Position;

            if v7.LinkMode == "Follow" then
                v11 = CFrame.new(Position) * p4.CFrame.Rotation;
            else
                v11 = CFrame.new(Position) * v12.Rotation * p4.CFrame.Rotation;
            end;
        else
            v11 = p4.CFrame;
        end;

        local v13 = DirectionVectors[v7.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
        local v14 = v11[v13.vector] * v13.multiplier;
        local v15 = Vector3.new();
        local v16 = nil;
        local v17;

        if v7.UseShape then
            local v18 = shapeFunctions[v7.ParticleData.Shape];

            if v18 then
                local v19;

                if v7.ShapePart then
                    v19 = v7.ShapePart.CFrame or v11;
                else
                    v19 = v11;
                end;

                local v20, v21, v22 = v18(v7.ShapePart or p4, v7.ParticleData);
                local ShapeInOut = v7.ParticleData.ShapeInOut;

                if ShapeInOut == Enum.ParticleEmitterShapeInOut.Inward then
                    v22 = -v22;
                elseif ShapeInOut == Enum.ParticleEmitterShapeInOut.InAndOut and math.random() < 0.5 then
                    v22 = -v22;
                end;

                v16 = (v19 - v19.Position):VectorToWorldSpace(v22);

                if v7.ParticleData.LookAtInitially then
                    local v23, v24, v25 = v11:ToEulerAnglesXYZ();
                    v17 = CFrame.new((v19 * CFrame.new(v20)).Position) * v21 * CFrame.Angles(v23, v24, v25);
                else
                    v17 = CFrame.new((v19 * CFrame.new(v20)).Position) * v11.Rotation;
                end;
            else
                v17 = CFrame.new((v11 * CFrame.new(v15)).Position) * v11.Rotation;
            end;
        else
            v17 = CFrame.new((v11 * CFrame.new(v15)).Position) * v11.Rotation;
        end;

        local v26 = v7.DirMode or "RigidLocal";
        local v27 = AxisLinks.sampleRangeAxes(v7, v7.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, p6);
        local v28 = PartConstants.composeRotation(v7.RotOrder or "Global", v27.RotX, v27.RotY, v27.RotZ);
        local v29 = 1;
        local v30 = p3._parentScaleMap and p3._parentScaleMap[p4];

        if v30 and v30.ScaleMotion ~= false then
            v29 = PartConstants.getParentScaleFactor(v30, os.clock(), Graph);
        end;

        local v31 = PartConstants.applyPositionOffset(v17 * v28, v7, v8, p4, Range, AxisLinks, p6, nil, v29);

        if v26 == "Global" then
            v31 = CFrame.new(v31.Position) * v28;
        end;

        if v16 then
            v14 = v16;
        elseif v26 == "Local" then
            v14 = v31[v13.vector] * v13.multiplier;
        elseif v26 == "Global" then
            v14 = CFrame.new()[v13.vector] * v13.multiplier;
        end;

        local v32, v33;

        if v7.ParticleData.SpreadAngle.X > 0 or v7.ParticleData.SpreadAngle.Y > 0 then
            v32 = (math.random() * 2 - 1) * v7.ParticleData.SpreadAngle.X;
            v33 = (math.random() * 2 - 1) * v7.ParticleData.SpreadAngle.Y;
        else
            v32 = 0;
            v33 = 0;
        end;

        local v34 = CFrame.Angles(math.rad(v32), math.rad(v33), 0);
        local LookVector = (CFrame.lookAt(Vector3.new(), v14) * v34).LookVector;
        local v35 = {
            SizeX = Graph.GenerateSeed(v7.SizeX),
            SizeY = Graph.GenerateSeed(v7.SizeY),
            SizeZ = Graph.GenerateSeed(v7.SizeZ),
            RotSpeedX = Graph.GenerateSeed(v7.RotSpeedX),
            RotSpeedY = Graph.GenerateSeed(v7.RotSpeedY),
            RotSpeedZ = Graph.GenerateSeed(v7.RotSpeedZ),
            PosOffsetX = Graph.GenerateSeed(v7.PosOffsetX),
            PosOffsetY = Graph.GenerateSeed(v7.PosOffsetY),
            PosOffsetZ = Graph.GenerateSeed(v7.PosOffsetZ),
            Speed = Graph.GenerateSeed(v7.Speed),
            Brightness = Graph.GenerateSeed(v7.Brightness),
            Transparency = Graph.GenerateSeed(v7.Transparency),
            AccelStrength = Graph.GenerateSeed(v7.AccelStrength),
            Timescale = Graph.GenerateSeed(v7.Timescale)
        };
        AxisLinks.applyGraphAxisAliases(v7, v35, v7.AxisLinks);
        local InvertMotion = v7.InvertMotion;
        local v36, v37;

        if InvertMotion then
            v36, v37 = p3:PreSimulateForward(v7, v35, v31, LookVector, v34, v8, v10, nil, v31.Rotation * v28:Inverse());
        else
            v36 = nil;
            v37 = nil;
        end;

        local v38 = Pool.acquireOrCopyBare(v7.RenderTemplate, "Part", v7.Pool);
        v38.Archivable = false;
        local v39;

        if v8 then
            v39 = PartConstants.resolveLinkCFrame(v8);

            if v7.LinkMode == "Follow" or v7.LinkMode == "Pivot" then
                v39 = CFrame.new(v39.Position) or v39;
            end;
        else
            v39 = CFrame.new();
        end;

        if InvertMotion and v36 then
            v31 = v36[v37 or v7.TotalKeyFrames] or v36[0];
            v38.CFrame = v39 * v31;
        else
            if v8 then
                v31 = v39:ToObjectSpace(v31) or v31;
            end;

            v38.CFrame = v39 * v31;
        end;

        local u40 = {
            Type = "Part",
            VisualPart = v38,
            Link = v8,
            LinkMode = v7.LinkMode
        };

        if v7.LinkMode ~= "RigidLocal" or not (v8 and v39) then
            v39 = nil;
        end;

        u40._rigidLocalParentCF = v39;
        u40.Events = v7.Events;
        u40.SpecialMesh = v38:FindFirstChildOfClass("SpecialMesh");
        u40.Decal = v38:FindFirstChildOfClass("Decal");
        u40.SurfaceAppearance = v38:FindFirstChildOfClass("SurfaceAppearance");
        u40.StartTime = os.clock();
        u40.TotalKeyFrames = InvertMotion and v37 and v37 or math.max(1, v7.TotalKeyFrames);
        u40.CurrentStep = 0;
        u40.AccumulatedDT = 0;
        u40.LifeTime = v10;
        u40.PartLife = v7.PartLife;
        u40.CurrentPosition = v38.Position;
        u40.LocalCF = v31;
        u40.BaseDirection = LookVector;
        u40._accelVel = Vector3.new(0, 0, 0);
        u40.SpeedMultiplier = 1;
        u40._spinRate = Vector3.new(0, 0, 0);
        u40._spinAccumX = 0;
        u40._spinAccumY = 0;
        u40._spinAccumZ = 0;
        u40.EmissionDirection = v7.EmissionDirection;
        u40.SpreadRotation = v34;
        u40.Acceleration = v7.ParticleData.Acceleration;
        u40.Drag = v7.ParticleData.Drag;
        u40.VelocityVectored = v7.VelocityVectored;
        u40.InvertMotion = InvertMotion;
        u40.SimLocalCFrames = v36;
        u40.RotMode = v7.RotMode or "OverLife";
        u40.RotOrder = v7.RotOrder or "Global";
        u40.AccRotX = 0;
        u40.AccRotY = 0;
        u40.AccRotZ = 0;
        u40.Orientation = v7.Orientation;
        u40.ZOffset = v7.ZOffset;
        u40._localWorldCF = v31;
        u40.SpawnRotation = v31.Rotation;
        u40.SpawnEmitterRotation = v31.Rotation * v28:Inverse();
        u40.DisplacementMode = v7.DisplacementMode;
        u40._sleepRadius = v38 and v38:IsA("BasePart") and (v38.Size.Magnitude * 0.5 or 1) or 1;
        u40._prevWorldOff = Vector3.new(0, 0, 0);
        u40.HasPosOffsetGraphs = (v7.PosOffsetX ~= nil or v7.PosOffsetY ~= nil) and true or v7.PosOffsetZ ~= nil;
        local v41;

        if v7.AccelerationTowardsInstance == true and (v7.AccelTarget ~= nil and v7.AccelStrength ~= nil) then
            v41 = not v7.InvertMotion;
        else
            v41 = false;
        end;

        u40.HasTargetAccel = v41;
        u40.AccelTarget = v7.AccelTarget;
        u40.TargetVel = Vector3.new(0, 0, 0);
        u40.NeedsFullIteration = v7.VelocityVectored;
        local v42;

        if v7.RotMode == "Speed" then
            v42 = not v7.VelocityVectored;
        else
            v42 = false;
        end;

        u40.NeedsRotAccum = v42;
        u40.HasDrag = v7.ParticleData.Drag ~= 0;
        u40.HasAccel = v7.ParticleData.Acceleration.Magnitude > 0;
        u40.HasDecal = v38:FindFirstChildOfClass("Decal") ~= nil;
        u40.Graphs = {
            SizeX = v7.SizeX,
            SizeY = v7.SizeY,
            SizeZ = v7.SizeZ,
            RotSpeedX = v7.RotSpeedX,
            RotSpeedY = v7.RotSpeedY,
            RotSpeedZ = v7.RotSpeedZ,
            PosOffsetX = v7.PosOffsetX,
            PosOffsetY = v7.PosOffsetY,
            PosOffsetZ = v7.PosOffsetZ,
            Speed = v7.Speed,
            Brightness = v7.Brightness,
            Transparency = v7.Transparency,
            Color = v7.Color,
            AccelStrength = v7.AccelStrength,
            Timescale = v7.Timescale
        };
        u40.Seeds = v35;
        u40._effectiveElapsed = Graph.InitialEffectiveElapsed(v7.Timescale, v35.Timescale, v10);

        if u40.HasPosOffsetGraphs then
            local v43 = u40.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(0, u40.Graphs.PosOffsetX, u40.Seeds.PosOffsetX) or 0) or 0;
            local v44 = u40.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(0, u40.Graphs.PosOffsetY, u40.Seeds.PosOffsetY) or 0) or 0;
            local v45 = u40.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(0, u40.Graphs.PosOffsetZ, u40.Seeds.PosOffsetZ) or 0) or 0;
            local v46 = PartConstants.resolveDisplacement(Vector3.new(v43, v44, v45), v7.DisplacementMode or "Global", u40.SpawnRotation, u40.SpawnEmitterRotation);
            u40._prevWorldOff = v46;

            if v43 ~= 0 or (v44 ~= 0 or v45 ~= 0) then
                u40.LocalCF = u40.LocalCF + v46;
                u40.VisualPart.CFrame = u40.VisualPart.CFrame + v46;
            end;
        end;

        local v47 = Graph.QueryPointsWithTime(0, u40.Graphs.SizeX, u40.Seeds.SizeX);
        local v48 = Graph.QueryPointsWithTime(0, u40.Graphs.SizeY, u40.Seeds.SizeY);
        local v49 = Vector3.new(v47, v48, Graph.QueryPointsWithTime(0, u40.Graphs.SizeZ, u40.Seeds.SizeZ));
        local v50 = Graph.QueryPointsWithTime(0, u40.Graphs.Transparency, u40.Seeds.Transparency);
        local u51 = Graph.QueryColorPointWithTime(0, u40.Graphs.Color);
        local u52 = Graph.QueryPointsWithTime(0, u40.Graphs.Brightness, u40.Seeds.Brightness);

        if u40.SpecialMesh then
            u40.SpecialMesh.Scale = v49;
        else
            u40.VisualPart.Size = v49;
        end;

        if u40.SurfaceAppearance then
            u40.VisualPart.Transparency = v50;
            u40.VisualPart.Color = Color3.fromRGB(u51.R * 255, u51.G * 255, u51.B * 255);
            u40.SurfaceAppearance.Color = Color3.fromRGB(u51.R * 255, u51.G * 255, u51.B * 255);
            pcall(function() -- Line: 323
                -- upvalues: u40 (copy), u51 (copy), u52 (copy)
                u40.SurfaceAppearance.EmissiveTint = Color3.new(u51.R * u52, u51.G * u52, u51.B * u52);
            end);
        elseif u40.Decal then
            u40.Decal.Transparency = v50;
            u40.Decal.Color3 = Color3.fromRGB(u51.R * 255 * u52, u51.G * 255 * u52, u51.B * 255 * u52);
        else
            u40.VisualPart.Transparency = v50;
            u40.VisualPart.Color = Color3.fromRGB(u51.R * 255, u51.G * 255, u51.B * 255);
        end;

        for _, descendant in v38:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;

        v38.Parent = v7.EmitParent or p3:GetFolder();

        for _, descendant in v38:GetDescendants() do
            if descendant:IsA("Trail") and not descendant:GetAttribute("Transformed") then
                local Parent = descendant.Parent;
                local v53 = false;

                while Parent and Parent ~= v38 do
                    if Parent:GetAttribute("Transformed") then
                        v53 = true;
                        break;
                    end;

                    Parent = Parent.Parent;
                end;

                if not v53 and descendant:GetAttribute("EmitDuration") ~= nil then
                    if descendant.Enabled ~= true then
                        descendant.Enabled = true;
                    end;

                    if descendant:GetAttribute("_pooledTrailEnabled") ~= nil then
                        descendant:SetAttribute("_pooledTrailEnabled", true);
                    end;
                end;
            end;
        end;

        Pool.restoreTrails(v38, "Part");
        local v54 = p3:_makeAliveCheck();

        for _, child in v38:GetChildren() do
            if child:IsA("Attachment") then
                Particles.EnableEmitChildrenAndRepeatForAttachments(child, v54);
            end;

            Particles.EnableEmitSingle(child, v54);
        end;

        if p3._parentScaleMap and p3._parentScaleMap[p4] then
            u40.ParentScale = p3._parentScaleMap[p4];
        end;

        u40._sourceItem = p4;
        u2._seedTsOverride(u40, p4);

        if v7.Pool ~= false then
            u40._sourceRT = v7.RenderTemplate;
            u40._poolKind = "Part";
        end;

        StaticPass.apply(u40);
        p3:_applyEmitVisualPasses(u40);
        p3:_registerEmit(u40, p6);

        if v7.CachedMeshTextures and #v7.CachedMeshTextures > 0 then
            local v55 = u40.SurfaceAppearance or u40.Decal;

            if not v55 then
                if v38:IsA("MeshPart") then
                    v55 = v38;
                end;
            end;

            if v55 then
                Flipbook.Flip(u40, v7.ParticleData, v7.CachedMeshTextures, v55, v10);
            end;
        end;

        u40._nestedAlive = { true };
        NestedEmit.walkWithScale(p3, v7.RenderTemplate, v38, u40._nestedAlive, p6, u40.ParentScale, u40);
    end;

    function u2.EmitAttachment(p56, p57, p58, p59) -- Line: 408
        -- upvalues: Range (ref), PartConstants (ref), DirectionVectors (ref), AxisLinks (ref), Graph (ref), Pool (ref), u2 (copy), StaticPass (ref), Particles (ref), NestedEmit (ref)
        if not (p57 and p57.Parent) then
            return;
        end;

        local v60 = p56:GetData(p57);

        if not (v60 and v60.RenderTemplate) then
            return;
        end;

        local v61;

        if p59 and p59.IgnoreLink then
            v61 = nil;
        else
            v61 = p58 or v60.Link;
        end;

        local v62 = Range.RandomValueFromRange(v60.Lifetime);
        local v63 = v62 <= 0 and 0.001 or v62;
        local WorldCFrame = p57.WorldCFrame;
        local v64 = nil;

        if p59 then
            if p59.EventOriginResolver then
                v64 = p59.EventOriginResolver();
            end;

            v64 = v64 or p59.EventOriginCF;
        end;

        if v64 then
            if not (p59 and p59.UseFullOrigin) then
                v64 = CFrame.new(v64.Position) * WorldCFrame.Rotation;
            end;
        elseif v61 then
            local v65 = PartConstants.resolveLinkCFrame(v61);

            if v60.LinkMode == "Follow" then
                v64 = CFrame.new(v65.Position) * WorldCFrame.Rotation;
            else
                v64 = CFrame.new(v65.Position) * v65.Rotation * WorldCFrame.Rotation;
            end;
        else
            v64 = WorldCFrame;
        end;

        local EmitParent = v60.EmitParent;

        if not EmitParent then
            EmitParent = p57.Parent;

            while true do
                if not EmitParent then
                    EmitParent = nil;
                    break;
                end;

                if EmitParent:IsA("BasePart") then
                    break;
                end;

                EmitParent = EmitParent.Parent;
            end;

            if not EmitParent then
                EmitParent = p56:GetFolder();
            end;
        end;

        local v66 = EmitParent and EmitParent:IsA("BasePart") and EmitParent.CFrame or CFrame.new();
        local v67 = v66:ToObjectSpace(v64);
        local v68 = DirectionVectors[v60.EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
        local v69 = v60.DirMode or "RigidLocal";
        local v70 = AxisLinks.sampleRangeAxes(v60, v60.AxisLinks, { "RotX", "RotY", "RotZ" }, Range, p59);
        local v71 = PartConstants.composeRotation(v60.RotOrder or "Global", v70.RotX, v70.RotY, v70.RotZ);
        local v72 = v67 * v71;
        local v73;

        if v69 == "Local" then
            v73 = v72[v68.vector] * v68.multiplier;
        elseif v69 == "Global" then
            v73 = CFrame.new()[v68.vector] * v68.multiplier;

            if EmitParent and EmitParent:IsA("BasePart") then
                v73 = EmitParent.CFrame:VectorToObjectSpace(v73);
            end;
        else
            v73 = v67[v68.vector] * v68.multiplier;
        end;

        local v74 = 1;
        local v75 = p56._parentScaleMap and p56._parentScaleMap[p57];

        if v75 and v75.ScaleMotion ~= false then
            v74 = PartConstants.getParentScaleFactor(v75, os.clock(), Graph);
        end;

        local v76 = PartConstants.applyPositionOffset(v72, v60, v61, p57, Range, AxisLinks, p59, v66, v74);

        if v69 == "Global" then
            if EmitParent and EmitParent:IsA("BasePart") then
                v76 = CFrame.new(v76.Position) * EmitParent.CFrame.Rotation:Inverse() * v71;
            else
                v76 = CFrame.new(v76.Position) * v71;
            end;
        end;

        local v77, v78;

        if v60.ParticleData.SpreadAngle.X > 0 or v60.ParticleData.SpreadAngle.Y > 0 then
            v77 = (math.random() * 2 - 1) * v60.ParticleData.SpreadAngle.X;
            v78 = (math.random() * 2 - 1) * v60.ParticleData.SpreadAngle.Y;
        else
            v77 = 0;
            v78 = 0;
        end;

        local v79 = CFrame.Angles(math.rad(v77), math.rad(v78), 0);
        local LookVector = (CFrame.lookAt(Vector3.new(), v73) * v79).LookVector;
        local v80 = {
            Speed = Graph.GenerateSeed(v60.Speed),
            RotSpeedX = Graph.GenerateSeed(v60.RotSpeedX),
            RotSpeedY = Graph.GenerateSeed(v60.RotSpeedY),
            RotSpeedZ = Graph.GenerateSeed(v60.RotSpeedZ),
            PosOffsetX = Graph.GenerateSeed(v60.PosOffsetX),
            PosOffsetY = Graph.GenerateSeed(v60.PosOffsetY),
            PosOffsetZ = Graph.GenerateSeed(v60.PosOffsetZ),
            Timescale = Graph.GenerateSeed(v60.Timescale)
        };
        AxisLinks.applyGraphAxisAliases(v60, v80, v60.AxisLinks);
        local InvertMotion = v60.InvertMotion;
        local v81, v82;

        if InvertMotion then
            v81, v82 = p56:PreSimulateAttachmentForward(v60, v80, v76, LookVector, v79, v63, nil, v76.Rotation * v71:Inverse());
        else
            v81 = nil;
            v82 = nil;
        end;

        local v83 = Pool.acquireOrCopyBare(v60.RenderTemplate, "Attachment", v60.Pool);
        v83.Archivable = false;

        if InvertMotion and v81 then
            v76 = v81[v82 or v60.TotalKeyFrames] or v81[0];
        end;

        v83.CFrame = v76;
        v83.Parent = EmitParent;
        Pool.restoreTrails(v83, "Attachment");

        if v61 then
            local v84 = PartConstants.resolveLinkCFrame(v61);
            local v85 = (EmitParent and (EmitParent:IsA("BasePart") and EmitParent.CFrame) or CFrame.new()):ToObjectSpace(v84);

            if v60.LinkMode == "Follow" or v60.LinkMode == "Pivot" then
                v85 = CFrame.new(v85.Position);
            end;

            v76 = v85:ToObjectSpace(v76);
        end;

        local v86;

        if v60.LinkMode == "RigidLocal" and v61 then
            v86 = PartConstants.resolveLinkCFrame(v61);
        else
            v86 = nil;
        end;

        local v87 = {
            Type = "Attachment",
            VisualPart = v83,
            Link = v61,
            LinkMode = v60.LinkMode,
            _rigidLocalParentCF = v86,
            Events = v60.Events,
            StartTime = os.clock(),
            TotalKeyFrames = InvertMotion and v82 and v82 or math.max(1, v60.TotalKeyFrames),
            CurrentStep = 0,
            AccumulatedDT = 0,
            LifeTime = v63,
            PartLife = v60.PartLife,
            LocalCF = v76,
            _localWorldCF = v76,
            BaseDirection = LookVector,
            _accelVel = Vector3.new(0, 0, 0),
            SpeedMultiplier = 1,
            _spinRate = Vector3.new(0, 0, 0),
            _spinAccumX = 0,
            _spinAccumY = 0,
            _spinAccumZ = 0,
            EmissionDirection = v60.EmissionDirection,
            SpreadRotation = v79,
            Acceleration = v60.ParticleData.Acceleration,
            Drag = v60.ParticleData.Drag,
            VelocityVectored = v60.VelocityVectored,
            InvertMotion = InvertMotion,
            SimLocalCFrames = v81,
            RotMode = v60.RotMode or "OverLife",
            RotOrder = v60.RotOrder or "Global",
            AccRotX = 0,
            AccRotY = 0,
            AccRotZ = 0,
            Orientation = v60.Orientation,
            ZOffset = v60.ZOffset,
            SpawnRotation = v76.Rotation,
            SpawnEmitterRotation = v76.Rotation * v71:Inverse(),
            DisplacementMode = v60.DisplacementMode,
            _sleepRadius = 1,
            _prevWorldOff = Vector3.new(0, 0, 0),
            HasPosOffsetGraphs = (v60.PosOffsetX ~= nil or v60.PosOffsetY ~= nil) and true or v60.PosOffsetZ ~= nil,
            NeedsFullIteration = v60.VelocityVectored
        };
        local v88;

        if v60.RotMode == "Speed" then
            v88 = not v60.VelocityVectored;
        else
            v88 = false;
        end;

        v87.NeedsRotAccum = v88;
        v87.HasDrag = v60.ParticleData.Drag ~= 0;
        v87.HasAccel = v60.ParticleData.Acceleration.Magnitude > 0;
        v87.Graphs = {
            Speed = v60.Speed,
            RotSpeedX = v60.RotSpeedX,
            RotSpeedY = v60.RotSpeedY,
            RotSpeedZ = v60.RotSpeedZ,
            PosOffsetX = v60.PosOffsetX,
            PosOffsetY = v60.PosOffsetY,
            PosOffsetZ = v60.PosOffsetZ,
            Timescale = v60.Timescale
        };
        v87.Seeds = v80;
        v87._effectiveElapsed = Graph.InitialEffectiveElapsed(v60.Timescale, v80.Timescale, v63);

        if v87.HasPosOffsetGraphs then
            local v89 = v87.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(0, v87.Graphs.PosOffsetX, v87.Seeds.PosOffsetX) or 0) or 0;
            local v90 = v87.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(0, v87.Graphs.PosOffsetY, v87.Seeds.PosOffsetY) or 0) or 0;
            local v91 = v87.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(0, v87.Graphs.PosOffsetZ, v87.Seeds.PosOffsetZ) or 0) or 0;
            local v92 = PartConstants.resolveDisplacement(Vector3.new(v89, v90, v91), v60.DisplacementMode or "Global", v87.SpawnRotation, v87.SpawnEmitterRotation);
            v87._prevWorldOff = v92;

            if v89 ~= 0 or (v90 ~= 0 or v91 ~= 0) then
                v87.LocalCF = v87.LocalCF + v92;
                v87.VisualPart.CFrame = v87.VisualPart.CFrame + v92;
            end;
        end;

        v87._sourceItem = p57;
        u2._seedTsOverride(v87, p57);

        if p56._parentScaleMap and p56._parentScaleMap[p57] then
            v87.ParentScale = p56._parentScaleMap[p57];
        end;

        if v60.Pool ~= false then
            v87._sourceRT = v60.RenderTemplate;
            v87._poolKind = "Attachment";
        end;

        StaticPass.apply(v87);
        p56:_applyEmitVisualPasses(v87);
        p56:_registerEmit(v87, p59);

        for _, descendant in v83:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;

        local v93 = p56:_makeAliveCheck();

        for _, child in v83:GetChildren() do
            if child:IsA("Attachment") then
                Particles.EnableEmitChildrenAndRepeatForAttachments(child, v93);
            end;

            Particles.EnableEmitSingle(child, v93);
        end;

        v87._nestedAlive = { true };
        NestedEmit.walkWithScale(p56, v60.RenderTemplate, v83, v87._nestedAlive, p59, v87.ParentScale, v87);
    end;

    function u2.EmitBeam(p94, p95, p96, p97) -- Line: 679
        -- upvalues: Pool (ref), Graph (ref), Range (ref), u2 (copy), Flipbook (ref)
        if not (p95 and p95.Parent) then
            return;
        end;

        local v98 = p94:GetData(p95);

        if not (v98 and v98.RenderTemplate) then
            return;
        end;

        local v99 = Pool.acquireOrClone(v98.RenderTemplate, "Beam", v98.Pool);
        v99.Archivable = false;
        v99.Enabled = true;

        if v98.FaceCamera ~= nil then
            v99.FaceCamera = v98.FaceCamera;
        end;

        if v98.ZOffset ~= nil then
            v99.ZOffset = v98.ZOffset;
        end;

        if v98.TextureMode ~= nil then
            v99.TextureMode = v98.TextureMode;
        end;

        if p97 and p97._parentCloneMap then
            local _parentCloneMap = p97._parentCloneMap;

            if v99.Attachment0 and _parentCloneMap[v99.Attachment0] then
                v99.Attachment0 = _parentCloneMap[v99.Attachment0];
            end;

            if v99.Attachment1 and _parentCloneMap[v99.Attachment1] then
                v99.Attachment1 = _parentCloneMap[v99.Attachment1];
            end;
        end;

        local v100 = {};

        for i, v in pairs(v98.BeamProps) do
            if v then
                if Graph.IsStatic(v) then
                    v99[i] = Graph.GetStaticValue(v, v99[i]);
                else
                    local v101 = Graph.GenerateSeed(v);
                    v100[i] = {
                        Sequence = v,
                        Seed = v101
                    };

                    if i ~= "TextureSpeed" then
                        local v102 = Graph.QueryPointsWithTime(0, v, v101);

                        if i == "Segments" then
                            local v103 = math.round(v102);
                            v102 = math.max(20, v103);
                        end;

                        v99[i] = v102;
                    end;
                end;
            end;
        end;

        if v100.TextureSpeed then
            v99.TextureSpeed = 0;
        end;

        local v104, v105 = Graph.CollectGraphStates(v98.GraphBlender);
        local v106 = {};

        for i = 1, #v104 - 1 do
            v106[i] = Graph.PrecomputeMergedTimes(v104[i].Graph, v104[i + 1].Graph);
        end;

        local v107 = {};

        for i = 1, #v105 - 1 do
            v107[i] = Graph.PrecomputeMergedColorTimes(v105[i].Graph, v105[i + 1].Graph);
        end;

        if #v104 > 0 then
            v99.Transparency = v104[1].Graph;
        end;

        if #v105 > 0 then
            v99.Color = v105[1].Graph;
        end;

        v99.Parent = v98.EmitParent or p94:GetFolder();
        local v108 = Range.RandomValueFromRange(v98.Lifetime);
        local v109 = v108 <= 0 and 0.001 or v108;
        local v110 = Graph.GenerateSeed(v98.BeamTimescale);
        local v111 = {
            Type = "Beam",
            CurrentStep = 0,
            VisualPart = v99,
            Link = p96,
            Events = v98.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, v98.TotalKeyFrames),
            LifeTime = v109,
            PartLife = v98.PartLife or 0,
            AnimatedProps = v100,
            TransStates = v104,
            ColorStates = v105,
            TransMergedTimes = v106,
            ColorMergedTimes = v107,
            Graphs = {
                Timescale = v98.BeamTimescale
            },
            Seeds = {
                Timescale = v110
            },
            _effectiveElapsed = Graph.InitialEffectiveElapsed(v98.BeamTimescale, v110, v109)
        };

        if p94._parentScaleMap and p94._parentScaleMap[p95] then
            v111.ParentScale = p94._parentScaleMap[p95];
            v111._baseWidth0 = v99.Width0;
            v111._baseWidth1 = v99.Width1;
            v111._baseCurveSize0 = v99.CurveSize0;
            v111._baseCurveSize1 = v99.CurveSize1;
            v111._baseTextureLength = v99.TextureLength;
            v111._baseSegments = v99.Segments;
        end;

        v111._sourceItem = p95;
        u2._seedTsOverride(v111, p95);

        if v98.Pool ~= false then
            v111._sourceRT = v98.RenderTemplate;
            v111._poolKind = "Beam";
        end;

        p94:_registerEmit(v111, p97);

        if v98.CachedBeamTextures and (#v98.CachedBeamTextures > 0 and v98.FlipbookParticle) then
            Flipbook.FlipBeam(v111, v98.FlipbookParticle, v98.CachedBeamTextures, v99, v109);
        end;
    end;
end;