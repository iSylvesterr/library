-- Decompiled with Potassium's decompiler.

local Flipbook = require(script.Parent.Flipbook);
local TypeRegistry = require(script.Parent.TypeRegistry);
local AxisLinks = require(script.Parent.AxisLinks);
local EventsSchema = require(script.Parent.EventsSchema);
local GetDataRig = require(script.Parent.GetDataRig);

local function safeEnum(u1, u2, p3) -- Line: 13
    if not u2 then
        return p3;
    end;

    local success, result = pcall(function() -- Line: 15
        -- upvalues: u1 (copy), u2 (copy)
        return u1[u2];
    end);

    if success then
        p3 = result or p3;
    end;

    return p3;
end;

local function readAxisLinks(p4) -- Line: 20
    -- upvalues: AxisLinks (copy)
    local v5 = {
        SizeX = p4:GetAttribute("SizeXLinkedTo"),
        SizeY = p4:GetAttribute("SizeYLinkedTo"),
        SizeZ = p4:GetAttribute("SizeZLinkedTo"),
        RotSpeedX = p4:GetAttribute("RotSpeedXLinkedTo"),
        RotSpeedY = p4:GetAttribute("RotSpeedYLinkedTo"),
        RotSpeedZ = p4:GetAttribute("RotSpeedZLinkedTo"),
        PosOffsetX = p4:GetAttribute("PosOffsetXLinkedTo"),
        PosOffsetY = p4:GetAttribute("PosOffsetYLinkedTo"),
        PosOffsetZ = p4:GetAttribute("PosOffsetZLinkedTo"),
        RotX = p4:GetAttribute("RotXLinkedTo"),
        RotY = p4:GetAttribute("RotYLinkedTo"),
        RotZ = p4:GetAttribute("RotZLinkedTo"),
        PosX = p4:GetAttribute("PosXLinkedTo"),
        PosY = p4:GetAttribute("PosYLinkedTo"),
        PosZ = p4:GetAttribute("PosZLinkedTo")
    };

    return AxisLinks.sanitize(v5);
end;

return function(p6) -- Line: 31
    -- upvalues: TypeRegistry (copy), EventsSchema (copy), readAxisLinks (copy), GetDataRig (copy), safeEnum (copy), Flipbook (copy)
    function p6.GetData(p7, p8) -- Line: 35
        -- upvalues: TypeRegistry (ref), EventsSchema (ref), readAxisLinks (ref), GetDataRig (ref), safeEnum (ref), Flipbook (ref)
        local v9 = {};
        local u10 = TypeRegistry.getConfig(p8);

        if not u10 then
            return nil;
        end;

        local EmitParent = p8:FindFirstChild("EmitParent");
        v9.EmitParent = EmitParent and (EmitParent:IsA("ObjectValue") and EmitParent.Value) or nil;
        local Link = p8:FindFirstChild("Link");
        local v11 = Link and (Link:IsA("ObjectValue") and Link.Value) or nil;
        local v12 = p8:GetAttribute("LinkSource") or (v11 and "Object" or "None");

        if v12 == "Camera" then
            v9.Link = workspace.CurrentCamera;
        elseif v12 == "Object" then
            v9.Link = v11;
        else
            v9.Link = nil;
        end;

        v9.LinkMode = p8:GetAttribute("LinkMode") or "Follow";
        v9.RenderTemplate = p8:FindFirstChild("RenderTemplate");
        v9.Events = EventsSchema.readEnabled(p8);
        local v13 = u10:GetAttribute("TotalKeyFrames") or 0;
        v9.TotalKeyFrames = v13 > 0 and v13 and v13 or 100;

        function v9.CheckEnabled() -- Line: 66
            -- upvalues: u10 (copy)
            local v14;

            if u10.Parent == nil then
                v14 = false;
            else
                v14 = u10:GetAttribute("Enabled") == true;
            end;

            return v14;
        end;

        if p8:IsA("Model") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.DirMode = u10:GetAttribute("DirMode") or (u10:GetAttribute("VelocityVectored") and "Local" or "RigidLocal");
            v9.VelocityVectored = v9.DirMode == "Local";
            v9.InvertMotion = u10:GetAttribute("InvertMotion") or false;
            v9.RotMode = u10:GetAttribute("RotMode") or "OverLife";
            v9.RotOrder = u10:GetAttribute("RotOrder") or "Global";
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            local NormalId = Enum.NormalId;
            local u15 = u10:GetAttribute("EmissionDirection");
            local Top = Enum.NormalId.Top;

            if u15 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: NormalId (copy), u15 (copy)
                    return NormalId[u15];
                end);

                if success then
                    Top = result or Top;
                end;
            end;

            v9.EmissionDirection = Top;
            v9.ParticleData = {
                SpreadAngle = u10:GetAttribute("SpreadAngle") or Vector2.new(0, 0),
                Acceleration = u10:GetAttribute("Acceleration") or Vector3.new(0, 0, 0),
                Drag = u10:GetAttribute("Drag") or 0
            };
            v9.Speed = u10:GetAttribute("Speed");
            v9.Scale = u10:GetAttribute("Scale");
            v9.Timescale = u10:GetAttribute("Timescale");
            v9.RotX = u10:GetAttribute("RotX") or NumberRange.new(0);
            v9.RotY = u10:GetAttribute("RotY") or NumberRange.new(0);
            v9.RotZ = u10:GetAttribute("RotZ") or NumberRange.new(0);
            v9.RotXEven = u10:GetAttribute("RotXEven") == true;
            v9.RotYEven = u10:GetAttribute("RotYEven") == true;
            v9.RotZEven = u10:GetAttribute("RotZEven") == true;
            v9.PosX = u10:GetAttribute("PosX") or NumberRange.new(0);
            v9.PosY = u10:GetAttribute("PosY") or NumberRange.new(0);
            v9.PosZ = u10:GetAttribute("PosZ") or NumberRange.new(0);
            v9.PosXEven = u10:GetAttribute("PosXEven") == true;
            v9.PosYEven = u10:GetAttribute("PosYEven") == true;
            v9.PosZEven = u10:GetAttribute("PosZEven") == true;
            v9.PosMode = u10:GetAttribute("PosMode") or "Local";
            v9.DisplacementMode = u10:GetAttribute("DisplacementMode") or "Global";
            v9.RotSpeedX = u10:GetAttribute("RotSpeedX");
            v9.RotSpeedY = u10:GetAttribute("RotSpeedY");
            v9.RotSpeedZ = u10:GetAttribute("RotSpeedZ");
            v9.PosOffsetX = u10:GetAttribute("PosOffsetX");
            v9.PosOffsetY = u10:GetAttribute("PosOffsetY");
            v9.PosOffsetZ = u10:GetAttribute("PosOffsetZ");
            v9.Turbulence = u10:GetAttribute("Turbulence");
            v9.TurbulenceFrequency = u10:GetAttribute("TurbulenceFrequency") or 1;
            v9.Orientation = u10:GetAttribute("Orientation") or "None";
            v9.ZOffset = u10:GetAttribute("ZOffset") or 0;
            v9.AxisLinks = readAxisLinks(u10);
            v9.Pool = u10:GetAttribute("Pool");
            v9.ScaleTextureLength = u10:GetAttribute("ScaleTextureLength");
            v9.ScaleMotion = u10:GetAttribute("ScaleMotion") ~= false;
            v9.ScaleRotation = u10:GetAttribute("ScaleRotation") == true;

            return v9;
        end;

        if p8:IsA("BlurEffect") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.BlurSize = u10:GetAttribute("BlurSize");
            v9.Timescale = u10:GetAttribute("Timescale");

            return v9;
        end;

        if p8:IsA("BloomEffect") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.BloomIntensity = u10:GetAttribute("BloomIntensity");
            v9.BloomSize = u10:GetAttribute("BloomSize");
            v9.BloomThreshold = u10:GetAttribute("BloomThreshold");
            v9.Timescale = u10:GetAttribute("Timescale");

            return v9;
        end;

        if p8:IsA("ColorCorrectionEffect") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.CCBrightness = u10:GetAttribute("CCBrightness");
            v9.CCContrast = u10:GetAttribute("CCContrast");
            v9.CCSaturation = u10:GetAttribute("CCSaturation");
            v9.CCTintColor = u10:GetAttribute("CCTintColor");
            v9.Timescale = u10:GetAttribute("Timescale");

            return v9;
        end;

        if p8:IsA("Atmosphere") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.AtmDensity = u10:GetAttribute("AtmDensity");
            v9.AtmOffset = u10:GetAttribute("AtmOffset");
            v9.AtmGlare = u10:GetAttribute("AtmGlare");
            v9.AtmHaze = u10:GetAttribute("AtmHaze");
            v9.AtmColor = u10:GetAttribute("AtmColor");
            v9.AtmDecay = u10:GetAttribute("AtmDecay");
            v9.AtmTimescale = u10:GetAttribute("AtmTimescale");

            return v9;
        end;

        if p8:IsA("ImageLabel") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.ImageTransparency = u10:GetAttribute("ImageTransparency");
            v9.BackgroundTransparency = u10:GetAttribute("BackgroundTransparency");
            v9.ImgSpeed = u10:GetAttribute("ImgSpeed");
            v9.SizeScaleX = u10:GetAttribute("SizeScaleX");
            v9.SizeScaleY = u10:GetAttribute("SizeScaleY");
            v9.ImgRotRange = u10:GetAttribute("ImgRotRange") or NumberRange.new(0);
            v9.ImgRotSpeed = u10:GetAttribute("ImgRotSpeed");
            v9.ImgRotMode = u10:GetAttribute("ImgRotMode") or "OverLife";
            v9.ImageColor3 = u10:GetAttribute("ImageColor3");
            v9.BackgroundColor3 = u10:GetAttribute("BackgroundColor3");
            v9.Image = u10:GetAttribute("Image") or "";
            v9.ImgPosition = u10:GetAttribute("Position") or UDim2.fromScale(0.5, 0.5);
            v9.ImgSizeUDim = u10:GetAttribute("ImgSize") or UDim2.fromOffset(100, 100);
            v9.ImgAnchorPoint = u10:GetAttribute("AnchorPoint") or Vector2.new(0.5, 0.5);
            v9.ImgZIndex = u10:GetAttribute("ZIndex") or 1;
            local ScaleType = Enum.ScaleType;
            local u16 = u10:GetAttribute("ScaleType");
            local Stretch = Enum.ScaleType.Stretch;

            if u16 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: ScaleType (copy), u16 (copy)
                    return ScaleType[u16];
                end);

                if success then
                    Stretch = result or Stretch;
                end;
            end;

            v9.ImgScaleType = Stretch;
            local ResamplerMode = Enum.ResamplerMode;
            local u17 = u10:GetAttribute("ResampleMode");
            local Default = Enum.ResamplerMode.Default;

            if u17 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: ResamplerMode (copy), u17 (copy)
                    return ResamplerMode[u17];
                end);

                if success then
                    Default = result or Default;
                end;
            end;

            v9.ImgResampleMode = Default;
            v9.ImgEmissionAngle = u10:GetAttribute("EmissionAngle") or 90;
            v9.ImgSpreadAngle = u10:GetAttribute("ImgSpreadAngle") or 0;
            v9.ImgAcceleration = u10:GetAttribute("ImgAcceleration") or Vector2.new(0, 0);
            v9.ImgDrag = u10:GetAttribute("ImgDrag") or 0;
            v9.ImgInvertMotion = u10:GetAttribute("ImgInvertMotion") or false;
            v9.ImgFlipbookSource = u10:GetAttribute("ImgFlipbookSource") or "Decals";
            local ParticleFlipbookMode = Enum.ParticleFlipbookMode;
            local u18 = u10:GetAttribute("ImgFlipbookMode");
            local Loop = Enum.ParticleFlipbookMode.Loop;

            if u18 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: ParticleFlipbookMode (copy), u18 (copy)
                    return ParticleFlipbookMode[u18];
                end);

                if success then
                    Loop = result or Loop;
                end;
            end;

            v9.ImgFlipbookMode = Loop;
            v9.ImgFlipbookStartRandom = u10:GetAttribute("ImgFlipbookStartRandom") or false;
            v9.ImgGridCols = u10:GetAttribute("GridCols") or 8;
            v9.ImgGridRows = u10:GetAttribute("GridRows") or 1;
            v9.ImgFlipbookFramerate = u10:GetAttribute("ImgFlipbookFramerate") or NumberRange.new(10);
            v9.ImgFlipbookReverse = u10:GetAttribute("ImgFlipbookReverse") or false;
            local v19 = u10:GetAttribute("_SheetSize");
            local v20 = u10:GetAttribute("_SheetAsset");
            local v21;

            if type(v9.Image) == "string" then
                v21 = v9.Image:match("rbxassetid://(%d+)") or (v9.Image:match("^(%d+)$") or nil);
            else
                v21 = nil;
            end;

            if typeof(v19) == "Vector2" and (v20 and v20 == v21) then
                v9.SheetSize = v19;
            end;

            v9.ImageFlipbooks = p8:FindFirstChild("ImageFlipbooks");
            v9.ImgTimescale = u10:GetAttribute("ImgTimescale");
            v9.Pool = u10:GetAttribute("Pool");

            return v9;
        end;

        if p8:IsA("PointLight") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.PLRange = u10:GetAttribute("PLRange");
            v9.PLBrightness = u10:GetAttribute("PLBrightness");
            v9.PLColor = u10:GetAttribute("PLColor");
            v9.PLTimescale = u10:GetAttribute("PLTimescale");
            v9.Shadows = u10:GetAttribute("Shadows");
            v9.Pool = u10:GetAttribute("Pool");

            return v9;
        end;

        if p8:IsA("Highlight") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.HLFillColor = u10:GetAttribute("HLFillColor");
            v9.HLFillTransparency = u10:GetAttribute("HLFillTransparency");
            v9.HLOutlineColor = u10:GetAttribute("HLOutlineColor");
            v9.HLOutlineTransparency = u10:GetAttribute("HLOutlineTransparency");
            v9.HLTimescale = u10:GetAttribute("HLTimescale");
            local HighlightDepthMode = Enum.HighlightDepthMode;
            local u22 = u10:GetAttribute("HLDepthMode");
            local AlwaysOnTop = Enum.HighlightDepthMode.AlwaysOnTop;

            if u22 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: HighlightDepthMode (copy), u22 (copy)
                    return HighlightDepthMode[u22];
                end);

                if success then
                    AlwaysOnTop = result or AlwaysOnTop;
                end;
            end;

            v9.HLDepthMode = AlwaysOnTop;
            local Adornee = p8:FindFirstChild("Adornee");
            v9.Adornee = Adornee and (Adornee:IsA("ObjectValue") and Adornee.Value) or nil;
            v9.Pool = u10:GetAttribute("Pool");

            return v9;
        end;

        if p8:IsA("Trail") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(2);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.TEmitTimescale = u10:GetAttribute("TEmitTimescale");
            v9.TEmitBrightness = u10:GetAttribute("TEmitBrightness");
            v9.TEmitLightEmission = u10:GetAttribute("TEmitLightEmission");
            v9.TEmitLightInfluence = u10:GetAttribute("TEmitLightInfluence");
            v9.TEmitTextureLength = u10:GetAttribute("TEmitTextureLength");
            v9.TEmitMinLength = u10:GetAttribute("TEmitMinLength");
            v9.TEmitMaxLength = u10:GetAttribute("TEmitMaxLength");
            v9.TrailLife = u10:GetAttribute("TEmitTrailLife") or NumberRange.new(2);
            local ParticleFlipbookMode = Enum.ParticleFlipbookMode;
            local u23 = u10:GetAttribute("TEmitFlipbookMode");
            local OneShot = Enum.ParticleFlipbookMode.OneShot;

            if u23 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: ParticleFlipbookMode (copy), u23 (copy)
                    return ParticleFlipbookMode[u23];
                end);

                if success then
                    OneShot = result or OneShot;
                end;
            end;

            v9.TrailFlipbookMode = OneShot;
            v9.TrailFlipbookFramerate = u10:GetAttribute("TEmitFlipbookFramerate") or NumberRange.new(30);
            v9.TrailFlipbookStartRandom = u10:GetAttribute("TEmitFlipbookStartRandom");
            v9.TrailFlipbookReverse = u10:GetAttribute("TEmitFlipbookReverse");
            v9.TrailFlipbooks = p8:FindFirstChild("TrailFlipbooks");
            v9.GraphBlender = p8:FindFirstChild("GraphBlender");
            v9.Pool = u10:GetAttribute("Pool");

            return v9;
        end;

        if p8:IsA("Attachment") then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;
            v9.DirMode = u10:GetAttribute("DirMode") or (u10:GetAttribute("VelocityVectored") and "Local" or "RigidLocal");
            v9.VelocityVectored = v9.DirMode == "Local";
            v9.InvertMotion = u10:GetAttribute("InvertMotion") or false;
            v9.RotMode = u10:GetAttribute("RotMode") or "OverLife";
            v9.RotOrder = u10:GetAttribute("RotOrder") or "Global";
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            local NormalId = Enum.NormalId;
            local u24 = u10:GetAttribute("EmissionDirection");
            local Top = Enum.NormalId.Top;

            if u24 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: NormalId (copy), u24 (copy)
                    return NormalId[u24];
                end);

                if success then
                    Top = result or Top;
                end;
            end;

            v9.EmissionDirection = Top;
            v9.ParticleData = {
                SpreadAngle = u10:GetAttribute("SpreadAngle") or Vector2.new(0, 0),
                Acceleration = u10:GetAttribute("Acceleration") or Vector3.new(0, 0, 0),
                Drag = u10:GetAttribute("Drag") or 0
            };
            v9.Speed = u10:GetAttribute("Speed");
            v9.Timescale = u10:GetAttribute("Timescale");
            v9.RotX = u10:GetAttribute("RotX") or NumberRange.new(0);
            v9.RotY = u10:GetAttribute("RotY") or NumberRange.new(0);
            v9.RotZ = u10:GetAttribute("RotZ") or NumberRange.new(0);
            v9.RotXEven = u10:GetAttribute("RotXEven") == true;
            v9.RotYEven = u10:GetAttribute("RotYEven") == true;
            v9.RotZEven = u10:GetAttribute("RotZEven") == true;
            v9.PosX = u10:GetAttribute("PosX") or NumberRange.new(0);
            v9.PosY = u10:GetAttribute("PosY") or NumberRange.new(0);
            v9.PosZ = u10:GetAttribute("PosZ") or NumberRange.new(0);
            v9.PosXEven = u10:GetAttribute("PosXEven") == true;
            v9.PosYEven = u10:GetAttribute("PosYEven") == true;
            v9.PosZEven = u10:GetAttribute("PosZEven") == true;
            v9.PosMode = u10:GetAttribute("PosMode") or "Local";
            v9.DisplacementMode = u10:GetAttribute("DisplacementMode") or "Global";
            v9.RotSpeedX = u10:GetAttribute("RotSpeedX");
            v9.RotSpeedY = u10:GetAttribute("RotSpeedY");
            v9.RotSpeedZ = u10:GetAttribute("RotSpeedZ");
            v9.PosOffsetX = u10:GetAttribute("PosOffsetX");
            v9.PosOffsetY = u10:GetAttribute("PosOffsetY");
            v9.PosOffsetZ = u10:GetAttribute("PosOffsetZ");
            v9.Turbulence = u10:GetAttribute("Turbulence");
            v9.TurbulenceFrequency = u10:GetAttribute("TurbulenceFrequency") or 1;
            v9.Orientation = u10:GetAttribute("Orientation") or "None";
            v9.ZOffset = u10:GetAttribute("ZOffset") or 0;
            v9.AxisLinks = readAxisLinks(u10);
            v9.Pool = u10:GetAttribute("Pool");

            return v9;
        end;

        if p8:IsA("BasePart") and p8:GetAttribute("IsRocks") == true then
            return GetDataRig.readRocks(v9, p8, u10, safeEnum);
        end;

        if p8:IsA("BasePart") and p8:GetAttribute("IsRope") == true then
            v9.AxisLinks = readAxisLinks(u10);

            return GetDataRig.readRope(v9, p8, u10, safeEnum);
        end;

        if p8:IsA("BasePart") and p8:GetAttribute("IsCameraShake") == true then
            v9.PartLife = 0;
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(0.5);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.ShakeAmplitude = u10:GetAttribute("ShakeAmplitude");
            v9.ShakeRotAmplitude = u10:GetAttribute("ShakeRotAmplitude");
            v9.ShakeFrequency = u10:GetAttribute("ShakeFrequency") or 10;
            v9.ShakeFalloff = u10:GetAttribute("ShakeFalloff") or 0;
            v9.Timescale = u10:GetAttribute("Timescale");

            return v9;
        end;

        if not p8:IsA("BasePart") or p8:GetAttribute("IsLightning") ~= true then
            v9.PartLife = u10:GetAttribute("PartLife") or 0;

            if p8:IsA("Beam") then
                v9.GraphBlender = p8:FindFirstChild("GraphBlender");
                v9.Lifetime = u10:GetAttribute("BeamLifetime") or NumberRange.new(1);
                v9.Rate = u10:GetAttribute("Rate") or 10;
                v9.BeamFlipbooks = p8:FindFirstChild("BeamFlipbooks");
                local v25 = {};
                local ParticleFlipbookMode = Enum.ParticleFlipbookMode;
                local u26 = u10:GetAttribute("BeamFlipbookMode");
                local v27;

                if u26 then
                    local success, result = pcall(function() -- Line: 15
                        -- upvalues: ParticleFlipbookMode (copy), u26 (copy)
                        return ParticleFlipbookMode[u26];
                    end);
                    v27 = success and result and result or nil;
                else
                    v27 = nil;
                end;

                v25.FlipbookMode = v27;
                v25.FlipbookFramerate = u10:GetAttribute("BeamFlipbookFramerate") or nil;
                v25.FlipbookStartRandom = u10:GetAttribute("BeamFlipbookStartRandom") or false;
                v25.FlipbookReverse = u10:GetAttribute("BeamFlipbookReverse") or false;
                v9.FlipbookParticle = v25;

                if v9.BeamFlipbooks then
                    v9.CachedBeamTextures = Flipbook.GetSortedBeamTextures(v9.BeamFlipbooks);
                end;

                v9.FaceCamera = u10:GetAttribute("FaceCamera");
                v9.ZOffset = u10:GetAttribute("ZOffset");
                local TextureMode = Enum.TextureMode;
                local u28 = u10:GetAttribute("BeamTextureMode");
                local v29;

                if u28 then
                    local success, result = pcall(function() -- Line: 15
                        -- upvalues: TextureMode (copy), u28 (copy)
                        return TextureMode[u28];
                    end);
                    v29 = success and result and result or nil;
                else
                    v29 = nil;
                end;

                v9.TextureMode = v29;
                v9.BeamProps = {
                    Brightness = u10:GetAttribute("BeamBrightness"),
                    CurveSize0 = u10:GetAttribute("CurveSize0"),
                    CurveSize1 = u10:GetAttribute("CurveSize1"),
                    Width0 = u10:GetAttribute("Width0"),
                    Width1 = u10:GetAttribute("Width1"),
                    LightEmission = u10:GetAttribute("LightEmission"),
                    LightInfluence = u10:GetAttribute("BeamLightInfluence"),
                    Segments = u10:GetAttribute("Segments"),
                    TextureLength = u10:GetAttribute("TextureLength"),
                    TextureSpeed = u10:GetAttribute("TextureSpeed")
                };
                v9.BeamTimescale = u10:GetAttribute("BeamTimescale");
                v9.Pool = u10:GetAttribute("Pool");

                return v9;
            end;

            v9.MeshFlipbooks = p8:FindFirstChild("MeshFlipbooks");

            if v9.MeshFlipbooks then
                v9.CachedMeshTextures = Flipbook.GetSortedTextures(v9.MeshFlipbooks);
            end;

            v9.DirMode = u10:GetAttribute("DirMode") or (u10:GetAttribute("VelocityVectored") and "Local" or "RigidLocal");
            v9.VelocityVectored = v9.DirMode == "Local";
            v9.InvertMotion = u10:GetAttribute("InvertMotion") or false;
            v9.RotMode = u10:GetAttribute("RotMode") or "OverLife";
            v9.RotOrder = u10:GetAttribute("RotOrder") or "Global";
            v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
            v9.Rate = u10:GetAttribute("Rate") or 10;
            v9.AccelerationTowardsInstance = u10:GetAttribute("AccelerationTowardsInstance") or false;
            v9.AccelStrength = u10:GetAttribute("AccelStrength") or NumberSequence.new(0);
            local AccelTarget = p8:FindFirstChild("AccelTarget");
            local v30 = AccelTarget and (AccelTarget:IsA("ObjectValue") and AccelTarget.Value) or nil;

            if v30 and (v30:IsA("BasePart") or (v30:IsA("Attachment") or (v30:IsA("Camera") or (v30:IsA("Model") or v30:IsA("Bone"))))) then
                v9.AccelTarget = v30;
            else
                v9.AccelTarget = nil;
            end;

            local ShapePart = p8:FindFirstChild("ShapePart");
            local v31 = ShapePart and (ShapePart:IsA("ObjectValue") and ShapePart.Value) or nil;

            if v31 and (v31:IsA("BasePart") and v31.Parent) then
                v9.ShapePart = v31;
            else
                v9.ShapePart = nil;
            end;

            local ParticleEmitterShape = Enum.ParticleEmitterShape;
            local u32 = u10:GetAttribute("Shape");
            local Box = Enum.ParticleEmitterShape.Box;

            if u32 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: ParticleEmitterShape (copy), u32 (copy)
                    return ParticleEmitterShape[u32];
                end);

                if success then
                    Box = result or Box;
                end;
            end;

            v9.Shape = Box;
            local ParticleEmitterShapeInOut = Enum.ParticleEmitterShapeInOut;
            local u33 = u10:GetAttribute("ShapeInOut");
            local Outward = Enum.ParticleEmitterShapeInOut.Outward;

            if u33 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: ParticleEmitterShapeInOut (copy), u33 (copy)
                    return ParticleEmitterShapeInOut[u33];
                end);

                if success then
                    Outward = result or Outward;
                end;
            end;

            v9.ShapeInOut = Outward;
            local NormalId = Enum.NormalId;
            local u34 = u10:GetAttribute("EmissionDirection");
            local Top = Enum.NormalId.Top;

            if u34 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: NormalId (copy), u34 (copy)
                    return NormalId[u34];
                end);

                if success then
                    Top = result or Top;
                end;
            end;

            v9.EmissionDirection = Top;
            v9.UseShape = u10:GetAttribute("UseShape") == true;
            v9.LookAtInitially = u10:GetAttribute("LookAtInitially") == true;
            local v35 = {
                Shape = v9.Shape,
                ShapeInOut = v9.ShapeInOut
            };
            local v36 = u10:GetAttribute("ShapePartial") or 0;
            v35.ShapePartial = math.clamp(v36, 0, 1);
            v35.UseShape = v9.UseShape;
            v35.LookAtInitially = v9.LookAtInitially;
            v35.EmissionDirection = v9.EmissionDirection;
            v35.SpreadAngle = u10:GetAttribute("SpreadAngle") or Vector2.new(0, 0);
            v35.Acceleration = u10:GetAttribute("Acceleration") or Vector3.new(0, 0, 0);
            v35.Drag = u10:GetAttribute("Drag") or 0;
            local ParticleFlipbookMode = Enum.ParticleFlipbookMode;
            local u37 = u10:GetAttribute("FlipbookMode");
            local v38;

            if u37 then
                local success, result = pcall(function() -- Line: 15
                    -- upvalues: ParticleFlipbookMode (copy), u37 (copy)
                    return ParticleFlipbookMode[u37];
                end);
                v38 = success and result and result or nil;
            else
                v38 = nil;
            end;

            v35.FlipbookMode = v38;
            v35.FlipbookFramerate = u10:GetAttribute("FlipbookFramerate") or nil;
            v35.FlipbookStartRandom = u10:GetAttribute("FlipbookStartRandom") or false;
            v35.FlipbookReverse = u10:GetAttribute("FlipbookReverse") or false;
            v9.ParticleData = v35;
            v9.Transparency = u10:GetAttribute("Transparency");
            v9.Color = u10:GetAttribute("Color");
            v9.Speed = u10:GetAttribute("Speed");
            v9.Brightness = u10:GetAttribute("Brightness");
            v9.Timescale = u10:GetAttribute("Timescale");
            v9.AxisLinks = readAxisLinks(u10);
            v9.SizeX = u10:GetAttribute("SizeX");
            v9.SizeY = u10:GetAttribute("SizeY");
            v9.SizeZ = u10:GetAttribute("SizeZ");
            v9.RotX = u10:GetAttribute("RotX") or NumberRange.new(0);
            v9.RotY = u10:GetAttribute("RotY") or NumberRange.new(0);
            v9.RotZ = u10:GetAttribute("RotZ") or NumberRange.new(0);
            v9.RotXEven = u10:GetAttribute("RotXEven") == true;
            v9.RotYEven = u10:GetAttribute("RotYEven") == true;
            v9.RotZEven = u10:GetAttribute("RotZEven") == true;
            v9.PosX = u10:GetAttribute("PosX") or NumberRange.new(0);
            v9.PosY = u10:GetAttribute("PosY") or NumberRange.new(0);
            v9.PosZ = u10:GetAttribute("PosZ") or NumberRange.new(0);
            v9.PosXEven = u10:GetAttribute("PosXEven") == true;
            v9.PosYEven = u10:GetAttribute("PosYEven") == true;
            v9.PosZEven = u10:GetAttribute("PosZEven") == true;
            v9.PosMode = u10:GetAttribute("PosMode") or "Local";
            v9.DisplacementMode = u10:GetAttribute("DisplacementMode") or "Global";
            v9.RotSpeedX = u10:GetAttribute("RotSpeedX");
            v9.RotSpeedY = u10:GetAttribute("RotSpeedY");
            v9.RotSpeedZ = u10:GetAttribute("RotSpeedZ");
            v9.PosOffsetX = u10:GetAttribute("PosOffsetX");
            v9.PosOffsetY = u10:GetAttribute("PosOffsetY");
            v9.PosOffsetZ = u10:GetAttribute("PosOffsetZ");
            v9.Turbulence = u10:GetAttribute("Turbulence");
            v9.TurbulenceFrequency = u10:GetAttribute("TurbulenceFrequency") or 1;
            v9.Orientation = u10:GetAttribute("Orientation") or "None";
            v9.ZOffset = u10:GetAttribute("ZOffset") or 0;
            v9.Pool = u10:GetAttribute("Pool");

            return v9;
        end;

        v9.PartLife = u10:GetAttribute("PartLife") or 0;
        v9.Lifetime = u10:GetAttribute("Lifetime") or NumberRange.new(1);
        v9.Rate = u10:GetAttribute("Rate") or 10;
        v9.TargetMode = u10:GetAttribute("TargetMode") or "Directional";
        local Target = p8:FindFirstChild("Target");
        v9.Target = Target and (Target:IsA("ObjectValue") and Target.Value) or nil;
        v9.Length = u10:GetAttribute("Length") or NumberRange.new(20);
        v9.GrowthSpeed = u10:GetAttribute("GrowthSpeed") or 0;
        v9.SpreadAngle = u10:GetAttribute("SpreadAngle") or Vector2.new(0, 0);
        local NormalId = Enum.NormalId;
        local u39 = u10:GetAttribute("EmissionDirection");
        local Top = Enum.NormalId.Top;

        if u39 then
            local success, result = pcall(function() -- Line: 15
                -- upvalues: NormalId (copy), u39 (copy)
                return NormalId[u39];
            end);

            if success then
                Top = result or Top;
            end;
        end;

        v9.EmissionDirection = Top;

        local function asRange(p40, p41) -- Line: 387
            if typeof(p40) == "NumberRange" then
                return p40;
            end;

            if typeof(p40) == "number" then
                return NumberRange.new(p40);
            end;

            return p41;
        end;

        local v42 = u10:GetAttribute("SegmentCount");
        local v43 = NumberRange.new(12);

        if typeof(v42) == "NumberRange" then
            v43 = v42;
        elseif typeof(v42) == "number" then
            v43 = NumberRange.new(v42);
        end;

        v9.SegmentCount = v43;
        local v44 = u10:GetAttribute("Amplitude");
        local v45 = NumberRange.new(0.15);

        if typeof(v44) == "NumberRange" then
            v45 = v44;
        elseif typeof(v44) == "number" then
            v45 = NumberRange.new(v44);
        end;

        v9.Amplitude = v45;
        local v46 = u10:GetAttribute("AmplitudeDecay");
        local v47 = NumberRange.new(0.5);

        if typeof(v46) == "NumberRange" then
            v47 = v46;
        elseif typeof(v46) == "number" then
            v47 = NumberRange.new(v46);
        end;

        v9.AmplitudeDecay = v47;
        local v48 = u10:GetAttribute("JitterRate");
        local v49 = NumberRange.new(15);

        if typeof(v48) == "NumberRange" then
            v49 = v48;
        elseif typeof(v48) == "number" then
            v49 = NumberRange.new(v48);
        end;

        v9.JitterRate = v49;
        local v50 = u10:GetAttribute("ForkChance");
        local v51 = NumberRange.new(0);

        if typeof(v50) == "NumberRange" then
            v51 = v50;
        elseif typeof(v50) == "number" then
            v51 = NumberRange.new(v50);
        end;

        v9.ForkChance = v51;
        local v52 = u10:GetAttribute("ForkDepth");
        local v53 = NumberRange.new(0);

        if typeof(v52) == "NumberRange" then
            v53 = v52;
        elseif typeof(v52) == "number" then
            v53 = NumberRange.new(v52);
        end;

        v9.ForkDepth = v53;
        local v54 = u10:GetAttribute("ForkLengthScale");
        local v55 = NumberRange.new(0.4);

        if typeof(v54) == "NumberRange" then
            v55 = v54;
        elseif typeof(v54) == "number" then
            v55 = NumberRange.new(v54);
        end;

        v9.ForkLengthScale = v55;
        local v56 = u10:GetAttribute("Sag");
        local v57 = NumberRange.new(0);

        if typeof(v56) == "NumberRange" then
            v57 = v56;
        elseif typeof(v56) == "number" then
            v57 = NumberRange.new(v56);
        end;

        v9.Sag = v57;
        local v58 = u10:GetAttribute("SagShape");
        local v59 = NumberRange.new(1);

        if typeof(v58) == "NumberRange" then
            v59 = v58;
        elseif typeof(v58) == "number" then
            v59 = NumberRange.new(v58);
        end;

        v9.SagShape = v59;
        local v60 = u10:GetAttribute("SeekRadius");
        local v61 = NumberRange.new(30);

        if typeof(v60) == "NumberRange" then
            v61 = v60;
        elseif typeof(v60) == "number" then
            v61 = NumberRange.new(v60);
        end;

        v9.SeekRadius = v61;
        v9.SeekRetarget = u10:GetAttribute("SeekRetarget") == true;
        v9.SeekBias = u10:GetAttribute("SeekBias") or 0;
        v9.RetargetSpeed = u10:GetAttribute("RetargetSpeed") or 0;
        v9.Gradient = u10:GetAttribute("Gradient");
        v9.ShapeMode = u10:GetAttribute("ShapeMode") or "Jitter";
        local v62 = u10:GetAttribute("ScrollSpeed");
        local v63 = NumberRange.new(1);

        if typeof(v62) == "NumberRange" then
            v63 = v62;
        elseif typeof(v62) == "number" then
            v63 = NumberRange.new(v62);
        end;

        v9.ScrollSpeed = v63;
        local v64 = u10:GetAttribute("Waves");
        local v65 = NumberRange.new(3);

        if typeof(v64) == "NumberRange" then
            v65 = v64;
        elseif typeof(v64) == "number" then
            v65 = NumberRange.new(v64);
        end;

        v9.Waves = v65;
        v9.UseShape = u10:GetAttribute("UseShape") == true;
        local ParticleEmitterShape = Enum.ParticleEmitterShape;
        local u66 = u10:GetAttribute("Shape");
        local Box = Enum.ParticleEmitterShape.Box;

        if u66 then
            local success, result = pcall(function() -- Line: 15
                -- upvalues: ParticleEmitterShape (copy), u66 (copy)
                return ParticleEmitterShape[u66];
            end);

            if success then
                Box = result or Box;
            end;
        end;

        v9.Shape = Box;
        local ParticleEmitterShapeInOut = Enum.ParticleEmitterShapeInOut;
        local u67 = u10:GetAttribute("ShapeInOut");
        local Outward = Enum.ParticleEmitterShapeInOut.Outward;

        if u67 then
            local success, result = pcall(function() -- Line: 15
                -- upvalues: ParticleEmitterShapeInOut (copy), u67 (copy)
                return ParticleEmitterShapeInOut[u67];
            end);

            if success then
                Outward = result or Outward;
            end;
        end;

        v9.ShapeInOut = Outward;
        v9.ShapePartial = u10:GetAttribute("ShapePartial") or 0;
        v9.ShapeDirection = u10:GetAttribute("ShapeDirection") or "Emitter";
        local ShapePart = p8:FindFirstChild("ShapePart");
        v9.ShapePart = ShapePart and (ShapePart:IsA("ObjectValue") and ShapePart.Value) or nil;
        v9.PosX = u10:GetAttribute("PosX") or NumberRange.new(0);
        v9.PosY = u10:GetAttribute("PosY") or NumberRange.new(0);
        v9.PosZ = u10:GetAttribute("PosZ") or NumberRange.new(0);
        v9.PosXEven = u10:GetAttribute("PosXEven") == true;
        v9.PosYEven = u10:GetAttribute("PosYEven") == true;
        v9.PosZEven = u10:GetAttribute("PosZEven") == true;
        v9.PosMode = u10:GetAttribute("PosMode") or "Local";
        v9.RotX = u10:GetAttribute("RotX") or NumberRange.new(0);
        v9.RotY = u10:GetAttribute("RotY") or NumberRange.new(0);
        v9.RotZ = u10:GetAttribute("RotZ") or NumberRange.new(0);
        v9.RotXEven = u10:GetAttribute("RotXEven") == true;
        v9.RotYEven = u10:GetAttribute("RotYEven") == true;
        v9.RotZEven = u10:GetAttribute("RotZEven") == true;
        v9.RotOrder = u10:GetAttribute("RotOrder") or "Global";
        v9.DirMode = u10:GetAttribute("DirMode") or "RigidLocal";
        v9.AxisLinks = readAxisLinks(u10);
        v9.Speed = u10:GetAttribute("Speed");
        v9.Acceleration = u10:GetAttribute("Acceleration") or Vector3.new(0, 0, 0);
        v9.Drag = u10:GetAttribute("Drag") or 0;
        v9.PosOffsetX = u10:GetAttribute("PosOffsetX");
        v9.PosOffsetY = u10:GetAttribute("PosOffsetY");
        v9.PosOffsetZ = u10:GetAttribute("PosOffsetZ");
        v9.DisplacementMode = u10:GetAttribute("DisplacementMode") or "Global";
        v9.Turbulence = u10:GetAttribute("Turbulence");
        v9.TurbulenceFrequency = u10:GetAttribute("TurbulenceFrequency") or 1;
        v9.Color = u10:GetAttribute("Color");
        v9.Brightness = u10:GetAttribute("Brightness");
        v9.Transparency = u10:GetAttribute("Transparency");
        v9.Thickness = u10:GetAttribute("Thickness");
        v9.Timescale = u10:GetAttribute("Timescale");
        v9.Pool = u10:GetAttribute("Pool");

        return v9;
    end;
end;