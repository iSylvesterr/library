-- Decompiled with Potassium's decompiler.

local TypeRegistry = require(script.Parent.TypeRegistry);
require(script.Parent.PartConstants);

return function(u1) -- Line: 10
    -- upvalues: TypeRegistry (copy)
    if not u1.TransformCompleted then
        u1.TransformCompleted = Instance.new("BindableEvent");
    end;

    function u1.Transform(p2, u3) -- Line: 19
        -- upvalues: TypeRegistry (ref), u1 (copy)
        if u3:GetAttribute("Transformed") then
            return;
        end;

        local v4 = TypeRegistry.getTypeFor(u3);

        if not v4 then
            if u3:IsA("BasePart") and (u3:GetAttribute("IsLightning") and TypeRegistry.Types.Lightning) then
                v4 = TypeRegistry.Types.Lightning;
            elseif u3:IsA("BasePart") and (u3:GetAttribute("IsCameraShake") and TypeRegistry.Types.CameraShake) then
                v4 = TypeRegistry.Types.CameraShake;
            elseif u3:IsA("BasePart") and (u3:GetAttribute("IsRocks") and TypeRegistry.Types.Rocks) then
                v4 = TypeRegistry.Types.Rocks;
            else
                if not (u3:IsA("BasePart") and (u3:GetAttribute("IsRope") and TypeRegistry.Types.Rope)) then
                    return;
                end;

                v4 = TypeRegistry.Types.Rope;
            end;
        end;

        local v5 = v4 == TypeRegistry.Types.Lightning;
        local v6 = v4 == TypeRegistry.Types.CameraShake;
        local v7 = v4 == TypeRegistry.Types.Rocks;
        local v8 = v4 == TypeRegistry.Types.Rope;

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

        local v9 = TypeRegistry.createConfig(u3, v4);
        local v10 = u3:Clone();
        v10.Name = "RenderTemplate";

        for _, child in v10:GetChildren() do
            if not (child:GetAttribute("Transformed") or child:IsA("Attachment")) then
                if child.Name == TypeRegistry.CONFIG_NAME or (child.Name == "EmitParent" or (child.Name == "Link" or (child.Name == "AccelTarget" or (child.Name == "Target" or child.Name == "ImageFlipbooks")))) then
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
            v10:SetAttribute(v, nil);
        end;

        if v10:IsA("BasePart") then
            v10.Anchored = true;
            v10.CanCollide = false;
            v10.CanQuery = false;
            v10.CanTouch = false;
            v10.CastShadow = false;
            v10.Massless = true;
            v10.Locked = true;
            v10.Transparency = 1;

            for _, child in ipairs(v10:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 1;
                end;
            end;
        end;

        if v10:IsA("Attachment") then
            v10.CFrame = CFrame.new();
        end;

        for _, descendant in ipairs(v10:GetDescendants()) do
            if (descendant:IsA("ParticleEmitter") or descendant:IsA("Trail")) and not descendant:GetAttribute("Transformed") then
                descendant.Enabled = false;
            end;
        end;

        v10.Parent = u3;

        if u3:IsA("BasePart") and not (u3:IsA("Terrain") or v6) then
            local Size = u3.Size;
            local v11 = u3:FindFirstChildWhichIsA("SpecialMesh");

            if v11 then
                Size = v11.Scale;
            end;

            local Color = u3.Color;
            local Transparency = u3.Transparency;

            if u3:FindFirstChildWhichIsA("SurfaceAppearance") == nil then
                local v12 = u3:FindFirstChildWhichIsA("Decal");

                if v12 then
                    Color = v12.Color3;
                    Transparency = v12.Transparency;
                end;
            end;

            if v5 or v8 then
                local new = NumberSequence.new;
                local v13 = math.min(u3.Size.X, u3.Size.Y);
                v9:SetAttribute("Thickness", new((math.max(0.05, v13))));
            elseif not v7 then
                v9:SetAttribute("SizeX", NumberSequence.new(Size.X));
                v9:SetAttribute("SizeY", NumberSequence.new(Size.Y));
                v9:SetAttribute("SizeZ", NumberSequence.new(Size.Z));
            end;

            v9:SetAttribute("Color", ColorSequence.new(Color));
            v9:SetAttribute("Transparency", NumberSequence.new(Transparency));
        end;

        if u3:IsA("BasePart") then
            for _, child in ipairs(u3:GetChildren()) do
                if child ~= v10 and (child:IsA("SpecialMesh") or (child:IsA("Decal") or child:IsA("Texture"))) then
                    child:Destroy();
                end;
            end;

            u3.Transparency = 1;

            if v7 then
                u3.CanCollide = false;
            end;
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
            v9:SetAttribute("Shadows", u3.Shadows);
        end;

        if u3:IsA("BlurEffect") then
            v9:SetAttribute("BlurSize", NumberSequence.new(u3.Size));
        elseif u3:IsA("BloomEffect") then
            v9:SetAttribute("BloomIntensity", NumberSequence.new(u3.Intensity));
            v9:SetAttribute("BloomSize", NumberSequence.new(u3.Size));
            v9:SetAttribute("BloomThreshold", NumberSequence.new(u3.Threshold));
        elseif u3:IsA("ColorCorrectionEffect") then
            v9:SetAttribute("CCBrightness", NumberSequence.new(u3.Brightness));
            v9:SetAttribute("CCContrast", NumberSequence.new(u3.Contrast));
            v9:SetAttribute("CCSaturation", NumberSequence.new(u3.Saturation));
            v9:SetAttribute("CCTintColor", ColorSequence.new(u3.TintColor));
        elseif u3:IsA("Atmosphere") then
            v9:SetAttribute("AtmDensity", NumberSequence.new(u3.Density));
            v9:SetAttribute("AtmOffset", NumberSequence.new(u3.Offset));
            v9:SetAttribute("AtmGlare", NumberSequence.new(u3.Glare));
            v9:SetAttribute("AtmHaze", NumberSequence.new(u3.Haze));
            v9:SetAttribute("AtmColor", ColorSequence.new(u3.Color));
            v9:SetAttribute("AtmDecay", ColorSequence.new(u3.Decay));
        elseif u3:IsA("Highlight") then
            v9:SetAttribute("HLFillColor", ColorSequence.new(u3.FillColor));
            v9:SetAttribute("HLFillTransparency", NumberSequence.new(u3.FillTransparency));
            v9:SetAttribute("HLOutlineColor", ColorSequence.new(u3.OutlineColor));
            v9:SetAttribute("HLOutlineTransparency", NumberSequence.new(u3.OutlineTransparency));
            v9:SetAttribute("HLDepthMode", u3.DepthMode.Name);

            if not u3:FindFirstChild("Adornee") then
                local ObjectValue = Instance.new("ObjectValue");
                ObjectValue.Name = "Adornee";
                ObjectValue.Value = nil;
                ObjectValue.Parent = u3;
            end;
        end;

        if v10:IsA("PostProcessEffect") then
            v10.Enabled = false;
        end;

        if u3:IsA("ImageLabel") then
            if v10:IsA("ImageLabel") then
                v10.Visible = false;
            end;

            if u3.BackgroundTransparency == 0 then
                u3.BackgroundTransparency = 1;
            end;

            v9:SetAttribute("Image", u3.Image);
            v9:SetAttribute("Position", u3.Position);
            v9:SetAttribute("ImgSize", u3.Size);
            v9:SetAttribute("AnchorPoint", u3.AnchorPoint);
            v9:SetAttribute("ZIndex", u3.ZIndex);
            v9:SetAttribute("ScaleType", u3.ScaleType.Name);
            v9:SetAttribute("ResampleMode", u3.ResampleMode.Name);

            if not u3:FindFirstChild("ImageFlipbooks") then
                local Folder = Instance.new("Folder");
                Folder.Name = "ImageFlipbooks";
                Folder.Parent = u3;
            end;
        end;

        if u3:IsA("BasePart") and not (u3:IsA("Terrain") or (v5 or (v6 or (v7 or (v8 or u3:FindFirstChild("MeshFlipbooks")))))) then
            local Folder = Instance.new("Folder");
            Folder.Name = "MeshFlipbooks";
            Folder.Parent = u3;
        end;

        if u3:IsA("Trail") then
            u3.Enabled = false;

            if v10:IsA("Trail") then
                v10.Enabled = false;
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

            if v10:IsA("Beam") then
                v10.Enabled = false;
                v10.LightInfluence = 0;
            end;

            if not u3:FindFirstChild("BeamFlipbooks") then
                local Folder = Instance.new("Folder");
                Folder.Name = "BeamFlipbooks";
                Folder.Parent = u3;
            end;

            v9:SetAttribute("BeamBrightness", NumberSequence.new(u3.Brightness));
            v9:SetAttribute("CurveSize0", NumberSequence.new(u3.CurveSize0));
            v9:SetAttribute("CurveSize1", NumberSequence.new(u3.CurveSize1));
            v9:SetAttribute("Width0", NumberSequence.new(u3.Width0));
            v9:SetAttribute("Width1", NumberSequence.new(u3.Width1));
            v9:SetAttribute("LightEmission", NumberSequence.new(u3.LightEmission));
            v9:SetAttribute("BeamLightInfluence", NumberSequence.new(0));
            v9:SetAttribute("Segments", NumberSequence.new(u3.Segments));
            v9:SetAttribute("TextureLength", NumberSequence.new(u3.TextureLength));
            v9:SetAttribute("TextureSpeed", NumberSequence.new(u3.TextureSpeed));
            v9:SetAttribute("FaceCamera", u3.FaceCamera);
            v9:SetAttribute("ZOffset", u3.ZOffset);
            v9:SetAttribute("BeamTextureMode", u3.TextureMode.Name);
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

        if (u3:IsA("BasePart") or u3:IsA("Attachment")) and not (v5 or (v6 or (v7 or (v8 or u3:FindFirstChild("Link"))))) then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "Link";
            ObjectValue.Parent = u3;
        end;

        if u3:IsA("BasePart") and not (v5 or (v6 or (v7 or (v8 or u3:FindFirstChild("AccelTarget"))))) then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "AccelTarget";
            ObjectValue.Value = nil;
            ObjectValue.Parent = u3;
        end;

        if u3:IsA("BasePart") and not (v6 or (v7 or (v8 or u3:FindFirstChild("ShapePart")))) then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "ShapePart";
            ObjectValue.Value = u3;
            ObjectValue.Parent = u3;
        end;

        if (v5 or v8) and not u3:FindFirstChild("Target") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "Target";
            ObjectValue.Value = nil;
            ObjectValue.Parent = u3;
        end;

        u3:SetAttribute("Transformed", true);
        u3:SetAttribute("Qwinkle", true);
        u3:SetAttribute("_EvenCycleId", game:GetService("HttpService"):GenerateGUID(false));
        u3:SetAttribute("EmitCount", (u3:IsA("Beam") or (v5 or (v6 or (v7 or v8)))) and 1 or 0);
        u3:SetAttribute("EmitDuration", 0);
        u3:SetAttribute("EmitDelay", 0);
        u3:SetAttribute("IsEmitter", true);

        if u3:IsA("BasePart") or (u3:IsA("Beam") or (u3:IsA("Trail") or u3:IsA("ImageLabel"))) then
            u3:SetAttribute("PreloadTexture", false);
        end;

        u3:SetAttribute("EmissionMode", u3:IsA("Atmosphere") and "Animate" or "Emit");
        u3:SetAttribute("AnimateLoop", false);

        if u3:IsA("BasePart") and not (v5 or (v6 or (v7 or v8))) or (u3:IsA("Beam") or (u3:IsA("Attachment") or u3:IsA("Model"))) then
            u3:SetAttribute("LinkMode", "Follow");
            u3:SetAttribute("LinkSource", "None");
        end;

        pcall(function() -- Line: 343
            -- upvalues: u1 (ref), u3 (copy)
            u1.TransformCompleted:Fire(u3);
        end);
    end;

    function u1.TransformModel(p14, u15, p16) -- Line: 350
        -- upvalues: TypeRegistry (ref), u1 (copy)
        if u15:GetAttribute("Transformed") then
            return;
        end;

        TypeRegistry.createConfig(u15, p16);
        local v17 = u15:Clone();
        v17.Name = "RenderTemplate";

        for _, child in v17:GetChildren() do
            if child.Name == TypeRegistry.CONFIG_NAME or (child.Name == "EmitParent" or (child.Name == "Link" or child.Name == "AccelTarget")) then
                child:Destroy();
            end;
        end;

        for _, v in ipairs({ "Transformed", "Qwinkle", "IsEmitter", "EmitCount", "EmitDuration", "EmitDelay", "EmissionMode", "AnimateLoop" }) do
            v17:SetAttribute(v, nil);
        end;

        for _, descendant in v17:GetDescendants() do
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

        v17.Parent = u15;

        for _, descendant in ipairs(u15:GetDescendants()) do
            if not descendant:IsDescendantOf(v17) then
                if descendant:IsA("BasePart") then
                    descendant.Transparency = 1;
                elseif descendant:IsA("SpecialMesh") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
                    descendant:Destroy();
                end;
            end;
        end;

        if not u15:FindFirstChild("EmitParent") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "EmitParent";
            ObjectValue.Value = nil;
            ObjectValue.Parent = u15;
        end;

        if not u15:FindFirstChild("Link") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "Link";
            ObjectValue.Parent = u15;
        end;

        u15:SetAttribute("Transformed", true);
        u15:SetAttribute("Qwinkle", true);
        u15:SetAttribute("EmitCount", 0);
        u15:SetAttribute("EmitDuration", 0);
        u15:SetAttribute("EmitDelay", 0);
        u15:SetAttribute("IsEmitter", true);
        u15:SetAttribute("PreloadTexture", false);
        u15:SetAttribute("EmissionMode", "Emit");
        u15:SetAttribute("AnimateLoop", false);
        u15:SetAttribute("LinkMode", "Follow");
        u15:SetAttribute("LinkSource", "None");
        pcall(function() -- Line: 413
            -- upvalues: u1 (ref), u15 (copy)
            u1.TransformCompleted:Fire(u15);
        end);
    end;
end;