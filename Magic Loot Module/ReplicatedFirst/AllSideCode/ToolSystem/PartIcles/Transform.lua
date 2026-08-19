-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local TypeRegistry = require(script.Parent.TypeRegistry);
local PartConstants = require(script.Parent.PartConstants);
local DirectionVectors = PartConstants.DirectionVectors;

return function(u1) -- Line: 13
    -- upvalues: TypeRegistry (copy), PartConstants (copy), Graph (copy), DirectionVectors (copy)
    if not u1.TransformCompleted then
        u1.TransformCompleted = Instance.new("BindableEvent");
    end;

    function u1.Transform(p2, u3) -- Line: 22
        -- upvalues: TypeRegistry (ref), u1 (copy)
        if u3:GetAttribute("Transformed") then
            return;
        end;

        local v4 = TypeRegistry.getTypeFor(u3);

        if not v4 then
            return;
        end;

        if v4.directAccess then
            if u3:IsA("Trail") and TypeRegistry.Types.TrailEmitter then
                v4 = TypeRegistry.Types.TrailEmitter;
            else
                if not (u3:IsA("Beam") and TypeRegistry.Types.Beam) then
                    return;
                end;

                v4 = TypeRegistry.Types.Beam;
            end;
        end;

        if u3:IsA("Model") then
            return p2:TransformModel(u3, v4);
        end;

        local v5 = TypeRegistry.createConfig(u3, v4);
        local v6 = u3:Clone();
        v6.Name = "RenderTemplate";

        for _, child in v6:GetChildren() do
            if not (child:GetAttribute("Transformed") or child:IsA("Attachment")) then
                if child.Name == TypeRegistry.CONFIG_NAME or (child.Name == "EmitParent" or (child.Name == "Link" or (child.Name == "AccelTarget" or child.Name == "ImageFlipbooks"))) then
                    child:Destroy();
                elseif u3:IsA("PointLight") or u3:IsA("Highlight") then
                    child:Destroy();
                elseif u3:IsA("Attachment") then
                    if child.Name == "MeshFlipbooks" or (child.Name == "BeamFlipbooks" or child.Name == "GraphBlender") then
                        child:Destroy();
                    end;
                elseif u3:IsA("ImageLabel") then
                    if not child:IsA("UIComponent") then
                        child:Destroy();
                    end;
                elseif not (child:IsA("SpecialMesh") or (child:IsA("Decal") or (child:IsA("Texture") or child:IsA("SurfaceAppearance")))) then
                    child:Destroy();
                end;
            end;
        end;

        for _, v in ipairs({ "Transformed", "Qwinkle", "IsEmitter", "EmitCount", "EmitDuration", "EmitDelay", "EmissionMode", "AnimateLoop", "PreloadTexture", "LinkMode", "LinkSource" }) do
            v6:SetAttribute(v, nil);
        end;

        if v6:IsA("BasePart") then
            v6.Anchored = true;
            v6.CanCollide = false;
            v6.CanQuery = false;
            v6.CanTouch = false;
            v6.CastShadow = false;
            v6.Massless = true;
            v6.Locked = true;
            v6.Transparency = 1;

            for _, child in ipairs(v6:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 1;
                end;
            end;
        end;

        if v6:IsA("Attachment") then
            v6.CFrame = CFrame.new();
        end;

        for _, descendant in ipairs(v6:GetDescendants()) do
            if (descendant:IsA("ParticleEmitter") or descendant:IsA("Trail")) and not descendant:GetAttribute("Transformed") then
                descendant.Enabled = false;
            end;
        end;

        v6.Parent = u3;

        if u3:IsA("BasePart") and not u3:IsA("Terrain") then
            local Size = u3.Size;
            local v7 = u3:FindFirstChildWhichIsA("SpecialMesh");

            if v7 then
                Size = v7.Scale;
            end;

            local Color = u3.Color;
            local Transparency = u3.Transparency;

            if u3:FindFirstChildWhichIsA("SurfaceAppearance") == nil then
                local v8 = u3:FindFirstChildWhichIsA("Decal");

                if v8 then
                    Color = v8.Color3;
                    Transparency = v8.Transparency;
                end;
            end;

            v5:SetAttribute("SizeX", NumberSequence.new(Size.X));
            v5:SetAttribute("SizeY", NumberSequence.new(Size.Y));
            v5:SetAttribute("SizeZ", NumberSequence.new(Size.Z));
            v5:SetAttribute("Color", ColorSequence.new(Color));
            v5:SetAttribute("Transparency", NumberSequence.new(Transparency));
        end;

        if u3:IsA("BasePart") then
            for _, child in ipairs(u3:GetChildren()) do
                if child ~= v6 and (child:IsA("SpecialMesh") or (child:IsA("Decal") or child:IsA("Texture"))) then
                    child:Destroy();
                end;
            end;

            u3.Transparency = 1;
        elseif u3:IsA("PointLight") then
            u3.Enabled = false;
        elseif u3:IsA("Highlight") then
            u3.Enabled = false;
        elseif u3:IsA("PostProcessEffect") then
            u3.Enabled = false;
        elseif u3:IsA("ImageLabel") then
            u3.Visible = false;
        end;

        if u3:IsA("PointLight") then
            v5:SetAttribute("Shadows", u3.Shadows);
        end;

        if u3:IsA("BlurEffect") then
            v5:SetAttribute("BlurSize", NumberSequence.new(u3.Size));
        elseif u3:IsA("BloomEffect") then
            v5:SetAttribute("BloomIntensity", NumberSequence.new(u3.Intensity));
            v5:SetAttribute("BloomSize", NumberSequence.new(u3.Size));
            v5:SetAttribute("BloomThreshold", NumberSequence.new(u3.Threshold));
        elseif u3:IsA("ColorCorrectionEffect") then
            v5:SetAttribute("CCBrightness", NumberSequence.new(u3.Brightness));
            v5:SetAttribute("CCContrast", NumberSequence.new(u3.Contrast));
            v5:SetAttribute("CCSaturation", NumberSequence.new(u3.Saturation));
            v5:SetAttribute("CCTintColor", ColorSequence.new(u3.TintColor));
        elseif u3:IsA("Atmosphere") then
            v5:SetAttribute("AtmDensity", NumberSequence.new(u3.Density));
            v5:SetAttribute("AtmOffset", NumberSequence.new(u3.Offset));
            v5:SetAttribute("AtmGlare", NumberSequence.new(u3.Glare));
            v5:SetAttribute("AtmHaze", NumberSequence.new(u3.Haze));
            v5:SetAttribute("AtmColor", ColorSequence.new(u3.Color));
            v5:SetAttribute("AtmDecay", ColorSequence.new(u3.Decay));
        elseif u3:IsA("Highlight") then
            v5:SetAttribute("HLFillColor", ColorSequence.new(u3.FillColor));
            v5:SetAttribute("HLFillTransparency", NumberSequence.new(u3.FillTransparency));
            v5:SetAttribute("HLOutlineColor", ColorSequence.new(u3.OutlineColor));
            v5:SetAttribute("HLOutlineTransparency", NumberSequence.new(u3.OutlineTransparency));
            v5:SetAttribute("HLDepthMode", u3.DepthMode.Name);

            if not u3:FindFirstChild("Adornee") then
                local ObjectValue = Instance.new("ObjectValue");
                ObjectValue.Name = "Adornee";
                ObjectValue.Value = nil;
                ObjectValue.Parent = u3;
            end;
        end;

        if v6:IsA("PostProcessEffect") then
            v6.Enabled = false;
        end;

        if u3:IsA("ImageLabel") then
            if v6:IsA("ImageLabel") then
                v6.Visible = false;
            end;

            if u3.BackgroundTransparency == 0 then
                u3.BackgroundTransparency = 1;
            end;

            v5:SetAttribute("Image", u3.Image);
            v5:SetAttribute("Position", u3.Position);
            v5:SetAttribute("ImgSize", u3.Size);
            v5:SetAttribute("AnchorPoint", u3.AnchorPoint);
            v5:SetAttribute("ZIndex", u3.ZIndex);
            v5:SetAttribute("ScaleType", u3.ScaleType.Name);
            v5:SetAttribute("ResampleMode", u3.ResampleMode.Name);

            if not u3:FindFirstChild("ImageFlipbooks") then
                local Folder = Instance.new("Folder");
                Folder.Name = "ImageFlipbooks";
                Folder.Parent = u3;
            end;
        end;

        if u3:IsA("BasePart") and not (u3:IsA("Terrain") or u3:FindFirstChild("MeshFlipbooks")) then
            local Folder = Instance.new("Folder");
            Folder.Name = "MeshFlipbooks";
            Folder.Parent = u3;
        end;

        if u3:IsA("Trail") then
            u3.Enabled = false;

            if v6:IsA("Trail") then
                v6.Enabled = false;
            end;

            if not u3:FindFirstChild("GraphBlender") then
                local Folder = Instance.new("Folder");
                Folder.Name = "GraphBlender";
                local Configuration = Instance.new("Configuration");
                Configuration.Name = "1";
                Configuration:SetAttribute("Time", 0);
                Configuration:SetAttribute("Width", u3.WidthScale or NumberSequence.new(1));
                Configuration:SetAttribute("Transparency", u3.Transparency or NumberSequence.new(0));
                Configuration:SetAttribute("Color", u3.Color or ColorSequence.new(Color3.new(1, 1, 1)));
                Configuration:SetAttribute("_AutoTime", true);
                Configuration.Parent = Folder;
                Folder.Parent = u3;
            end;

            if not u3:FindFirstChild("TrailFlipbooks") then
                local Folder = Instance.new("Folder");
                Folder.Name = "TrailFlipbooks";
                Folder.Parent = u3;
            end;
        end;

        if u3:IsA("Beam") then
            u3.Enabled = false;
            u3.LightInfluence = 0;

            if v6:IsA("Beam") then
                v6.Enabled = false;
                v6.LightInfluence = 0;
            end;

            if not u3:FindFirstChild("BeamFlipbooks") then
                local Folder = Instance.new("Folder");
                Folder.Name = "BeamFlipbooks";
                Folder.Parent = u3;
            end;

            v5:SetAttribute("BeamBrightness", NumberSequence.new(u3.Brightness));
            v5:SetAttribute("CurveSize0", NumberSequence.new(u3.CurveSize0));
            v5:SetAttribute("CurveSize1", NumberSequence.new(u3.CurveSize1));
            v5:SetAttribute("Width0", NumberSequence.new(u3.Width0));
            v5:SetAttribute("Width1", NumberSequence.new(u3.Width1));
            v5:SetAttribute("LightEmission", NumberSequence.new(u3.LightEmission));
            v5:SetAttribute("BeamLightInfluence", NumberSequence.new(0));
            v5:SetAttribute("Segments", NumberSequence.new(u3.Segments));
            v5:SetAttribute("TextureLength", NumberSequence.new(u3.TextureLength));
            v5:SetAttribute("TextureSpeed", NumberSequence.new(u3.TextureSpeed));
            v5:SetAttribute("FaceCamera", u3.FaceCamera);
            v5:SetAttribute("ZOffset", u3.ZOffset);
            v5:SetAttribute("BeamTextureMode", u3.TextureMode.Name);
            local Folder = Instance.new("Folder");
            Folder.Name = "GraphBlender";
            local Configuration = Instance.new("Configuration");
            Configuration.Name = "1";
            Configuration:SetAttribute("Time", 0);
            Configuration:SetAttribute("Transparency", u3.Transparency);
            Configuration:SetAttribute("Color", u3.Color);
            Configuration:SetAttribute("_AutoTime", true);
            Configuration.Parent = Folder;
            Folder.Parent = u3;
        end;

        if not u3:FindFirstChild("EmitParent") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "EmitParent";
            ObjectValue.Value = nil;
            ObjectValue.Parent = u3;
        end;

        if (u3:IsA("BasePart") or u3:IsA("Attachment")) and not u3:FindFirstChild("Link") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "Link";
            ObjectValue.Parent = u3;
        end;

        if u3:IsA("BasePart") and not u3:FindFirstChild("AccelTarget") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "AccelTarget";
            ObjectValue.Value = nil;
            ObjectValue.Parent = u3;
        end;

        if u3:IsA("BasePart") and not u3:FindFirstChild("ShapePart") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "ShapePart";
            ObjectValue.Value = u3;
            ObjectValue.Parent = u3;
        end;

        u3:SetAttribute("Transformed", true);
        u3:SetAttribute("Qwinkle", true);
        u3:SetAttribute("_EvenCycleId", game:GetService("HttpService"):GenerateGUID(false));
        u3:SetAttribute("EmitCount", u3:IsA("Beam") and 1 or 0);
        u3:SetAttribute("EmitDuration", 0);
        u3:SetAttribute("EmitDelay", 0);
        u3:SetAttribute("IsEmitter", true);

        if u3:IsA("BasePart") or (u3:IsA("Beam") or (u3:IsA("Trail") or u3:IsA("ImageLabel"))) then
            u3:SetAttribute("PreloadTexture", false);
        end;

        u3:SetAttribute("EmissionMode", u3:IsA("Atmosphere") and "Animate" or "Emit");
        u3:SetAttribute("AnimateLoop", false);

        if u3:IsA("BasePart") or (u3:IsA("Beam") or (u3:IsA("Attachment") or u3:IsA("Model"))) then
            u3:SetAttribute("LinkMode", "Follow");
            u3:SetAttribute("LinkSource", "None");
        end;

        pcall(function() -- Line: 308
            -- upvalues: u1 (ref), u3 (copy)
            u1.TransformCompleted:Fire(u3);
        end);
    end;

    function u1.PreSimulateForward(p9, p10, p11, p12, p13, p14, p15, p16, p17, p18) -- Line: 315
        -- upvalues: PartConstants (ref), Graph (ref), DirectionVectors (ref)
        local v19 = p10.LinkMode or "Follow";
        local v20;

        if p15 then
            v20 = PartConstants.resolveLinkCFrame(p15);

            if v19 == "Follow" or v19 == "Pivot" then
                v20 = CFrame.new(v20.Position);
            end;
        else
            v20 = CFrame.new();
        end;

        local v21;

        if v19 == "Weld" or (v19 == "WeldWithoutRotation" or v19 == "RigidLocal") then
            v21 = p15 ~= nil;
        else
            v21 = false;
        end;

        local v22 = math.max(1, p10.TotalKeyFrames);

        if not p17 or p17 >= v22 then
            p17 = p10.InvertMotion and v22 > 500 and 500 or v22;
        end;

        local v23 = p16 / p17;
        local Position = p12.Position;
        local v24 = v20:ToObjectSpace(p12);
        local EmissionDirection = p10.EmissionDirection;
        local v25 = p10.RotMode or "OverLife";
        local v26 = 0;
        local v27 = 0;
        local v28 = 0;
        local v29;

        if p10.AccelerationTowardsInstance == true and (p10.AccelTarget ~= nil and p10.AccelStrength ~= nil) then
            v29 = not p10.InvertMotion;
        else
            v29 = false;
        end;

        local v30 = nil;

        if v29 then
            local AccelTarget = p10.AccelTarget;

            if AccelTarget:IsA("Bone") then
                v30 = AccelTarget.TransformedWorldCFrame.Position;
            elseif AccelTarget:IsA("BasePart") then
                v30 = AccelTarget.Position;
            elseif AccelTarget:IsA("Attachment") then
                v30 = AccelTarget.WorldPosition;
            elseif AccelTarget:IsA("Model") then
                local success, result = pcall(AccelTarget.GetPivot, AccelTarget);

                if success and result then
                    v30 = result.Position;
                end;
            end;

            if not v30 then
                v29 = false;
            end;
        end;

        local v31 = p11.AccelStrength or {};
        local v32 = (p10.PosOffsetX ~= nil or p10.PosOffsetY ~= nil) and true or p10.PosOffsetZ ~= nil;
        local v33 = v21 and v20:ToObjectSpace(p12).Rotation or p12.Rotation;
        local v34 = { v20:ToObjectSpace(p12) };
        local v35 = Vector3.new(0, 0, 0);
        local v36 = Vector3.new(0, 0, 0);

        for i = 1, p17 do
            local v37 = i / p17;
            local v38 = v37 * p16;
            local v39 = (p13 * (Graph.QueryPointsWithTime(v37, p10.Speed, p11.Speed) * math.exp(-p10.ParticleData.Drag * v38)) + p10.ParticleData.Acceleration * v38) * v23;

            if v29 then
                local v40 = v30 - Position;
                local Magnitude = v40.Magnitude;

                if Magnitude > 0.0001 then
                    local v41 = Graph.QueryPointsWithTime(v37, p10.AccelStrength, v31);

                    if v41 and v41 ~= 0 then
                        v36 = v36 + v40 * (v41 * v23 / Magnitude);
                        v39 = v39 + v36 * v23;
                    end;
                end;
            end;

            local v42, v43;

            if v32 then
                local v44 = p10.PosOffsetX and (Graph.QueryPointsWithTime(v37, p10.PosOffsetX, p11.PosOffsetX) or 0) or 0;
                local v45 = p10.PosOffsetY and (Graph.QueryPointsWithTime(v37, p10.PosOffsetY, p11.PosOffsetY) or 0) or 0;
                local v46 = p10.PosOffsetZ and (Graph.QueryPointsWithTime(v37, p10.PosOffsetZ, p11.PosOffsetZ) or 0) or 0;
                v42 = PartConstants.resolveDisplacement(Vector3.new(v44, v45, v46), p10.DisplacementMode or "Global", v33, p18 or v33);
                v43 = v42 - v35;
            else
                v42 = v35;
                v43 = Vector3.new(0, 0, 0);
            end;

            local v47;

            if v21 then
                v47 = (p10.DisplacementMode or "Global") == "Local";
            else
                v47 = v21;
            end;

            if v21 then
                v39 = v20:VectorToObjectSpace(v39) or v39;
            end;

            if v21 and not v47 then
                v43 = v20:VectorToObjectSpace(v43) or v43;
            end;

            v24 = CFrame.new(v39 + v43) * v24;
            local v48 = Graph.QueryPointsWithTime(v37, p10.RotSpeedX, p11.RotSpeedX);
            local v49 = Graph.QueryPointsWithTime(v37, p10.RotSpeedY, p11.RotSpeedY);
            local v50 = Graph.QueryPointsWithTime(v37, p10.RotSpeedZ, p11.RotSpeedZ);
            local v51 = p10.RotOrder or "Global";
            local v52;

            if v25 == "Speed" then
                v26 = v26 + v48 * v23;
                v27 = v27 + v49 * v23;
                v28 = v28 + v50 * v23;
                v52 = PartConstants.composeRotation(v51, v26, v27, v28);
            else
                v52 = PartConstants.composeRotation(v51, v48, v49, v50);
            end;

            local v53 = v20 * v24 * v52;
            Position = v53.Position;

            if p10.VelocityVectored then
                local v54 = DirectionVectors[EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
                p13 = (v53 * p14)[v54.vector] * v54.multiplier;
            end;

            v34[i] = v20:ToObjectSpace(v53);
            v35 = v42;
        end;

        return v34, p17;
    end;

    function u1.PreSimulateAttachmentForward(p55, p56, p57, p58, p59, p60, p61, p62, p63) -- Line: 446
        -- upvalues: Graph (ref), PartConstants (ref), DirectionVectors (ref)
        local v64 = math.max(1, p56.TotalKeyFrames);

        if not p62 or p62 >= v64 then
            p62 = p56.InvertMotion and v64 > 500 and 500 or v64;
        end;

        local v65 = p61 / p62;
        local EmissionDirection = p56.EmissionDirection;
        local v66 = p56.RotMode or "OverLife";
        local v67 = (p56.PosOffsetX ~= nil or p56.PosOffsetY ~= nil) and true or p56.PosOffsetZ ~= nil;
        local Rotation = p58.Rotation;
        local v68 = { p58 };
        local v69 = 0;
        local v70 = 0;
        local v71 = 0;
        local v72 = Vector3.new(0, 0, 0);

        for i = 1, p62 do
            local v73 = i / p62;
            local v74 = v73 * p61;
            local v75 = (p59 * (Graph.QueryPointsWithTime(v73, p56.Speed, p57.Speed) * math.exp(-p56.ParticleData.Drag * v74)) + p56.ParticleData.Acceleration * v74) * v65;
            local v76;

            if v67 then
                local v77 = p56.PosOffsetX and (Graph.QueryPointsWithTime(v73, p56.PosOffsetX, p57.PosOffsetX) or 0) or 0;
                local v78 = p56.PosOffsetY and (Graph.QueryPointsWithTime(v73, p56.PosOffsetY, p57.PosOffsetY) or 0) or 0;
                local v79 = p56.PosOffsetZ and (Graph.QueryPointsWithTime(v73, p56.PosOffsetZ, p57.PosOffsetZ) or 0) or 0;
                v76 = PartConstants.resolveDisplacement(Vector3.new(v77, v78, v79), p56.DisplacementMode or "Global", Rotation, p63 or Rotation);
                v75 = v75 + (v76 - v72);
            else
                v76 = v72;
            end;

            p58 = CFrame.new(v75) * p58;
            local v80 = Graph.QueryPointsWithTime(v73, p56.RotSpeedX, p57.RotSpeedX);
            local v81 = Graph.QueryPointsWithTime(v73, p56.RotSpeedY, p57.RotSpeedY);
            local v82 = Graph.QueryPointsWithTime(v73, p56.RotSpeedZ, p57.RotSpeedZ);
            local v83 = p56.RotOrder or "Global";
            local v84;

            if v66 == "Speed" then
                v69 = v69 + v80 * v65;
                v70 = v70 + v81 * v65;
                v71 = v71 + v82 * v65;
                v84 = PartConstants.composeRotation(v83, v69, v70, v71);
            else
                v84 = PartConstants.composeRotation(v83, v80, v81, v82);
            end;

            local v85 = p58 * v84;

            if p56.VelocityVectored then
                local v86 = DirectionVectors[EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
                p59 = (v85 * p60)[v86.vector] * v86.multiplier;
            end;

            v68[i] = v85;
            v72 = v76;
        end;

        return v68, p62;
    end;

    function u1.TransformModel(p87, u88, p89) -- Line: 527
        -- upvalues: TypeRegistry (ref), u1 (copy)
        if u88:GetAttribute("Transformed") then
            return;
        end;

        TypeRegistry.createConfig(u88, p89);
        local v90 = u88:Clone();
        v90.Name = "RenderTemplate";

        for _, child in v90:GetChildren() do
            if child.Name == TypeRegistry.CONFIG_NAME or (child.Name == "EmitParent" or (child.Name == "Link" or child.Name == "AccelTarget")) then
                child:Destroy();
            end;
        end;

        for _, v in ipairs({ "Transformed", "Qwinkle", "IsEmitter", "EmitCount", "EmitDuration", "EmitDelay", "EmissionMode", "AnimateLoop" }) do
            v90:SetAttribute(v, nil);
        end;

        for _, descendant in v90:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.CastShadow = false;
                descendant.Massless = true;
                descendant.Locked = true;
            elseif (descendant:IsA("ParticleEmitter") or descendant:IsA("Trail")) and not descendant:GetAttribute("Transformed") then
                descendant.Enabled = false;
            end;
        end;

        v90.Parent = u88;

        for _, descendant in ipairs(u88:GetDescendants()) do
            if not descendant:IsDescendantOf(v90) then
                if descendant:IsA("BasePart") then
                    descendant.Transparency = 1;
                elseif descendant:IsA("SpecialMesh") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
                    descendant:Destroy();
                end;
            end;
        end;

        if not u88:FindFirstChild("EmitParent") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "EmitParent";
            ObjectValue.Value = nil;
            ObjectValue.Parent = u88;
        end;

        if not u88:FindFirstChild("Link") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "Link";
            ObjectValue.Parent = u88;
        end;

        u88:SetAttribute("Transformed", true);
        u88:SetAttribute("Qwinkle", true);
        u88:SetAttribute("EmitCount", 0);
        u88:SetAttribute("EmitDuration", 0);
        u88:SetAttribute("EmitDelay", 0);
        u88:SetAttribute("IsEmitter", true);
        u88:SetAttribute("PreloadTexture", false);
        u88:SetAttribute("EmissionMode", "Emit");
        u88:SetAttribute("AnimateLoop", false);
        u88:SetAttribute("LinkMode", "Follow");
        u88:SetAttribute("LinkSource", "None");
        pcall(function() -- Line: 590
            -- upvalues: u1 (ref), u88 (copy)
            u1.TransformCompleted:Fire(u88);
        end);
    end;
end;