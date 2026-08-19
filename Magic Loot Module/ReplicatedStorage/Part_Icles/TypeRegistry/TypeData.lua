-- Decompiled with Potassium's decompiler.

local v1 = {
    PartProperties = {
        Brightness = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        Color = {
            type = "ColorSequence",
            default = ColorSequence.new(Color3.new(1, 1, 1))
        },
        SizeX = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        SizeY = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        SizeZ = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        Transparency = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        Speed = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        PosOffsetX = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        PosOffsetY = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        PosOffsetZ = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        Turbulence = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        TurbulenceFrequency = {
            type = "number",
            default = 1
        },
        RotSpeedX = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        RotSpeedY = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        RotSpeedZ = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        Timescale = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        Lifetime = {
            type = "NumberRange",
            default = NumberRange.new(1)
        },
        Rate = {
            type = "number",
            default = 10
        },
        Drag = {
            type = "number",
            default = 0
        },
        Acceleration = {
            type = "Vector3",
            default = Vector3.new(0, 0, 0)
        },
        SpreadAngle = {
            type = "Vector2",
            default = Vector2.new(0, 0)
        },
        RotX = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        RotY = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        RotZ = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        PosX = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        PosY = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        PosZ = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        PosMode = {
            type = "string",
            default = "Local"
        },
        RotMode = {
            type = "string",
            default = "OverLife"
        },
        RotOrder = {
            type = "string",
            default = "Global"
        },
        TotalKeyFrames = {
            type = "number",
            default = 100
        },
        PartLife = {
            type = "number",
            default = 0,
            nonNegative = true
        },
        ShapePartial = {
            type = "number",
            default = 0
        },
        VelocityVectored = {
            type = "boolean",
            default = false
        },
        DirMode = {
            type = "string",
            default = "RigidLocal"
        },
        DisplacementMode = {
            type = "string",
            default = "Global"
        },
        InvertMotion = {
            type = "boolean",
            default = false
        },
        Enabled = {
            type = "boolean",
            default = false
        },
        AccelerationTowardsInstance = {
            type = "boolean",
            default = false
        },
        AccelStrength = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        SizeXLinkedTo = {
            type = "string",
            default = ""
        },
        SizeYLinkedTo = {
            type = "string",
            default = ""
        },
        SizeZLinkedTo = {
            type = "string",
            default = ""
        },
        RotSpeedXLinkedTo = {
            type = "string",
            default = ""
        },
        RotSpeedYLinkedTo = {
            type = "string",
            default = ""
        },
        RotSpeedZLinkedTo = {
            type = "string",
            default = ""
        },
        PosOffsetXLinkedTo = {
            type = "string",
            default = ""
        },
        PosOffsetYLinkedTo = {
            type = "string",
            default = ""
        },
        PosOffsetZLinkedTo = {
            type = "string",
            default = ""
        },
        RotXLinkedTo = {
            type = "string",
            default = ""
        },
        RotYLinkedTo = {
            type = "string",
            default = ""
        },
        RotZLinkedTo = {
            type = "string",
            default = ""
        },
        PosXLinkedTo = {
            type = "string",
            default = ""
        },
        PosYLinkedTo = {
            type = "string",
            default = ""
        },
        PosZLinkedTo = {
            type = "string",
            default = ""
        },
        RotXEven = {
            type = "boolean",
            default = false
        },
        RotYEven = {
            type = "boolean",
            default = false
        },
        RotZEven = {
            type = "boolean",
            default = false
        },
        PosXEven = {
            type = "boolean",
            default = false
        },
        PosYEven = {
            type = "boolean",
            default = false
        },
        PosZEven = {
            type = "boolean",
            default = false
        },
        PositionEvenCycle = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        RotationEvenCycle = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        UseShape = {
            type = "boolean",
            default = false
        },
        LookAtInitially = {
            type = "boolean",
            default = false
        },
        Shape = {
            type = "enum",
            enumType = "ParticleEmitterShape",
            default = Enum.ParticleEmitterShape.Box
        },
        ShapeInOut = {
            type = "enum",
            enumType = "ParticleEmitterShapeInOut",
            default = Enum.ParticleEmitterShapeInOut.Outward
        },
        EmissionDirection = {
            type = "enum",
            enumType = "NormalId",
            default = Enum.NormalId.Top
        },
        Orientation = {
            type = "string",
            default = "None"
        },
        ZOffset = {
            type = "number",
            default = 0
        },
        FlipbookMode = {
            type = "enum",
            enumType = "ParticleFlipbookMode",
            default = Enum.ParticleFlipbookMode.OneShot
        },
        FlipbookFramerate = {
            type = "NumberRange",
            default = NumberRange.new(30)
        },
        FlipbookStartRandom = {
            type = "boolean",
            default = false
        },
        FlipbookReverse = {
            type = "boolean",
            default = false
        },
        Pool = {
            type = "boolean",
            default = false
        }
    },
    BeamProperties = {
        Brightness = {
            type = "NumberSequence",
            attrName = "BeamBrightness",
            default = NumberSequence.new(1)
        },
        Width0 = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        Width1 = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        CurveSize0 = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        CurveSize1 = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        LightEmission = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        LightInfluence = {
            type = "NumberSequence",
            attrName = "BeamLightInfluence",
            default = NumberSequence.new(0)
        },
        Segments = {
            type = "NumberSequence",
            default = NumberSequence.new(10)
        },
        TextureLength = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        TextureSpeed = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        Timescale = {
            type = "NumberSequence",
            attrName = "BeamTimescale",
            default = NumberSequence.new(1)
        },
        Lifetime = {
            type = "NumberRange",
            attrName = "BeamLifetime",
            default = NumberRange.new(1)
        },
        Rate = {
            type = "number",
            default = 10
        },
        TotalKeyFrames = {
            type = "number",
            default = 100
        },
        Enabled = {
            type = "boolean",
            default = false
        },
        FaceCamera = {
            type = "boolean",
            default = false
        },
        ZOffset = {
            type = "number",
            default = 0
        },
        TextureMode = {
            type = "enum",
            enumType = "TextureMode",
            attrName = "BeamTextureMode",
            default = Enum.TextureMode.Stretch
        },
        FlipbookMode = {
            type = "enum",
            enumType = "ParticleFlipbookMode",
            attrName = "BeamFlipbookMode",
            default = Enum.ParticleFlipbookMode.OneShot
        },
        FlipbookFramerate = {
            type = "NumberRange",
            attrName = "BeamFlipbookFramerate",
            default = NumberRange.new(30)
        },
        FlipbookStartRandom = {
            type = "boolean",
            default = false,
            attrName = "BeamFlipbookStartRandom"
        },
        FlipbookReverse = {
            type = "boolean",
            default = false,
            attrName = "BeamFlipbookReverse"
        },
        Pool = {
            type = "boolean",
            default = false
        }
    }
};
local TypeDataScreen = require(script.Parent.TypeDataScreen);
v1.BlurProperties = TypeDataScreen.BlurProperties;
v1.BloomProperties = TypeDataScreen.BloomProperties;
v1.ColorCorrectionProperties = TypeDataScreen.ColorCorrectionProperties;
v1.AtmosphereProperties = TypeDataScreen.AtmosphereProperties;
v1.ImageLabelProperties = TypeDataScreen.ImageLabelProperties;
v1.PointLightProperties = {
    Range = {
        type = "NumberSequence",
        attrName = "PLRange",
        default = NumberSequence.new(8)
    },
    Brightness = {
        type = "NumberSequence",
        attrName = "PLBrightness",
        default = NumberSequence.new(1)
    },
    Color = {
        type = "ColorSequence",
        attrName = "PLColor",
        default = ColorSequence.new(Color3.new(1, 1, 1))
    },
    Timescale = {
        type = "NumberSequence",
        attrName = "PLTimescale",
        default = NumberSequence.new(1)
    },
    Lifetime = {
        type = "NumberRange",
        default = NumberRange.new(1)
    },
    Rate = {
        type = "number",
        default = 10
    },
    TotalKeyFrames = {
        type = "number",
        default = 100
    },
    PartLife = {
        type = "number",
        default = 0,
        nonNegative = true
    },
    Enabled = {
        type = "boolean",
        default = false
    },
    Shadows = {
        type = "boolean",
        default = false
    },
    Pool = {
        type = "boolean",
        default = false
    }
};
v1.HighlightProperties = {
    FillColor = {
        type = "ColorSequence",
        attrName = "HLFillColor",
        default = ColorSequence.new(Color3.new(1, 1, 1))
    },
    FillTransparency = {
        type = "NumberSequence",
        attrName = "HLFillTransparency",
        default = NumberSequence.new(0)
    },
    OutlineColor = {
        type = "ColorSequence",
        attrName = "HLOutlineColor",
        default = ColorSequence.new(Color3.new(1, 1, 1))
    },
    OutlineTransparency = {
        type = "NumberSequence",
        attrName = "HLOutlineTransparency",
        default = NumberSequence.new(0)
    },
    Timescale = {
        type = "NumberSequence",
        attrName = "HLTimescale",
        default = NumberSequence.new(1)
    },
    Lifetime = {
        type = "NumberRange",
        default = NumberRange.new(1)
    },
    Rate = {
        type = "number",
        default = 10
    },
    TotalKeyFrames = {
        type = "number",
        default = 100
    },
    PartLife = {
        type = "number",
        default = 0,
        nonNegative = true
    },
    DepthMode = {
        type = "enum",
        enumType = "HighlightDepthMode",
        attrName = "HLDepthMode",
        default = Enum.HighlightDepthMode.AlwaysOnTop
    },
    Enabled = {
        type = "boolean",
        default = false
    },
    Pool = {
        type = "boolean",
        default = false
    }
};
v1.TrailEmitterProperties = {
    Lifetime = {
        type = "NumberRange",
        default = NumberRange.new(2)
    },
    TrailLife = {
        type = "NumberRange",
        attrName = "TEmitTrailLife",
        default = NumberRange.new(2)
    },
    Rate = {
        type = "number",
        default = 10
    },
    TotalKeyFrames = {
        type = "number",
        default = 100
    },
    PartLife = {
        type = "number",
        default = 0,
        nonNegative = true
    },
    Timescale = {
        type = "NumberSequence",
        attrName = "TEmitTimescale",
        default = NumberSequence.new(1)
    },
    Brightness = {
        type = "NumberSequence",
        attrName = "TEmitBrightness",
        default = NumberSequence.new(1)
    },
    LightEmission = {
        type = "NumberSequence",
        attrName = "TEmitLightEmission",
        default = NumberSequence.new(0)
    },
    LightInfluence = {
        type = "NumberSequence",
        attrName = "TEmitLightInfluence",
        default = NumberSequence.new(1)
    },
    TextureLength = {
        type = "NumberSequence",
        attrName = "TEmitTextureLength",
        nonNegative = true,
        default = NumberSequence.new(1)
    },
    MinLength = {
        type = "NumberSequence",
        attrName = "TEmitMinLength",
        nonNegative = true,
        default = NumberSequence.new(0.1)
    },
    MaxLength = {
        type = "NumberSequence",
        attrName = "TEmitMaxLength",
        nonNegative = true,
        default = NumberSequence.new(0)
    },
    Enabled = {
        type = "boolean",
        default = false
    },
    TrailFlipbookMode = {
        type = "enum",
        enumType = "ParticleFlipbookMode",
        attrName = "TEmitFlipbookMode",
        default = Enum.ParticleFlipbookMode.OneShot
    },
    TrailFlipbookFramerate = {
        type = "NumberRange",
        attrName = "TEmitFlipbookFramerate",
        default = NumberRange.new(30)
    },
    TrailFlipbookStartRandom = {
        type = "boolean",
        default = false,
        attrName = "TEmitFlipbookStartRandom"
    },
    TrailFlipbookReverse = {
        type = "boolean",
        default = false,
        attrName = "TEmitFlipbookReverse"
    },
    Pool = {
        type = "boolean",
        default = false
    }
};
v1.BeamNativeProperties = {
    Transparency = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    Color = {
        type = "ColorSequence",
        default = ColorSequence.new(Color3.new(1, 1, 1))
    },
    Brightness = {
        type = "number",
        default = 1
    },
    Width0 = {
        type = "number",
        default = 1
    },
    Width1 = {
        type = "number",
        default = 1
    },
    CurveSize0 = {
        type = "number",
        default = 0
    },
    CurveSize1 = {
        type = "number",
        default = 0
    },
    LightEmission = {
        type = "number",
        default = 0
    },
    LightInfluence = {
        type = "number",
        default = 0
    },
    Segments = {
        type = "number",
        default = 10,
        nonNegative = true
    },
    TextureLength = {
        type = "number",
        default = 1
    },
    TextureSpeed = {
        type = "number",
        default = 1
    },
    ZOffset = {
        type = "number",
        default = 0
    },
    Texture = {
        type = "string",
        default = ""
    },
    TextureMode = {
        type = "enum",
        enumType = "TextureMode",
        default = Enum.TextureMode.Stretch
    },
    FaceCamera = {
        type = "boolean",
        default = false
    },
    Enabled = {
        type = "boolean",
        default = true
    }
};
v1.TrailProperties = {
    Transparency = {
        type = "NumberSequence",
        default = NumberSequence.new(0.5)
    },
    WidthScale = {
        type = "NumberSequence",
        default = NumberSequence.new(1)
    },
    Color = {
        type = "ColorSequence",
        default = ColorSequence.new(Color3.new(1, 1, 1))
    },
    Brightness = {
        type = "number",
        default = 1
    },
    LightEmission = {
        type = "number",
        default = 0
    },
    LightInfluence = {
        type = "number",
        default = 1
    },
    TextureLength = {
        type = "number",
        default = 1
    },
    Lifetime = {
        type = "number",
        default = 2
    },
    MinLength = {
        type = "number",
        default = 0.1
    },
    MaxLength = {
        type = "number",
        default = 0
    },
    Duration = {
        type = "string",
        default = "2",
        attribute = true,
        attrName = "EmitDuration"
    },
    Enabled = {
        type = "boolean",
        default = true
    },
    FaceCamera = {
        type = "boolean",
        default = false
    },
    TextureMode = {
        type = "enum",
        enumType = "TextureMode",
        default = Enum.TextureMode.Stretch
    }
};
v1.AttachmentProperties = {
    Speed = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    PosOffsetX = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    PosOffsetY = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    PosOffsetZ = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    Turbulence = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    TurbulenceFrequency = {
        type = "number",
        default = 1
    },
    RotSpeedX = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    RotSpeedY = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    RotSpeedZ = {
        type = "NumberSequence",
        default = NumberSequence.new(0)
    },
    Timescale = {
        type = "NumberSequence",
        default = NumberSequence.new(1)
    },
    Lifetime = {
        type = "NumberRange",
        default = NumberRange.new(1)
    },
    Rate = {
        type = "number",
        default = 10
    },
    Drag = {
        type = "number",
        default = 0
    },
    Acceleration = {
        type = "Vector3",
        default = Vector3.new(0, 0, 0)
    },
    SpreadAngle = {
        type = "Vector2",
        default = Vector2.new(0, 0)
    },
    RotX = {
        type = "NumberRange",
        default = NumberRange.new(0)
    },
    RotY = {
        type = "NumberRange",
        default = NumberRange.new(0)
    },
    RotZ = {
        type = "NumberRange",
        default = NumberRange.new(0)
    },
    PosX = {
        type = "NumberRange",
        default = NumberRange.new(0)
    },
    PosY = {
        type = "NumberRange",
        default = NumberRange.new(0)
    },
    PosZ = {
        type = "NumberRange",
        default = NumberRange.new(0)
    },
    PosMode = {
        type = "string",
        default = "Local"
    },
    RotMode = {
        type = "string",
        default = "OverLife"
    },
    RotOrder = {
        type = "string",
        default = "Global"
    },
    TotalKeyFrames = {
        type = "number",
        default = 100
    },
    PartLife = {
        type = "number",
        default = 0,
        nonNegative = true
    },
    VelocityVectored = {
        type = "boolean",
        default = false
    },
    DirMode = {
        type = "string",
        default = "RigidLocal"
    },
    DisplacementMode = {
        type = "string",
        default = "Global"
    },
    InvertMotion = {
        type = "boolean",
        default = false
    },
    Enabled = {
        type = "boolean",
        default = false
    },
    EmissionDirection = {
        type = "enum",
        enumType = "NormalId",
        default = Enum.NormalId.Top
    },
    Orientation = {
        type = "string",
        default = "None"
    },
    ZOffset = {
        type = "number",
        default = 0
    },
    RotSpeedXLinkedTo = {
        type = "string",
        default = ""
    },
    RotSpeedYLinkedTo = {
        type = "string",
        default = ""
    },
    RotSpeedZLinkedTo = {
        type = "string",
        default = ""
    },
    PosOffsetXLinkedTo = {
        type = "string",
        default = ""
    },
    PosOffsetYLinkedTo = {
        type = "string",
        default = ""
    },
    PosOffsetZLinkedTo = {
        type = "string",
        default = ""
    },
    RotXLinkedTo = {
        type = "string",
        default = ""
    },
    RotYLinkedTo = {
        type = "string",
        default = ""
    },
    RotZLinkedTo = {
        type = "string",
        default = ""
    },
    PosXLinkedTo = {
        type = "string",
        default = ""
    },
    PosYLinkedTo = {
        type = "string",
        default = ""
    },
    PosZLinkedTo = {
        type = "string",
        default = ""
    },
    RotXEven = {
        type = "boolean",
        default = false
    },
    RotYEven = {
        type = "boolean",
        default = false
    },
    RotZEven = {
        type = "boolean",
        default = false
    },
    PosXEven = {
        type = "boolean",
        default = false
    },
    PosYEven = {
        type = "boolean",
        default = false
    },
    PosZEven = {
        type = "boolean",
        default = false
    },
    PositionEvenCycle = {
        type = "NumberRange",
        default = NumberRange.new(0)
    },
    RotationEvenCycle = {
        type = "NumberRange",
        default = NumberRange.new(0)
    },
    Pool = {
        type = "boolean",
        default = false
    }
};
v1.Types = {
    Part = {
        pDataType = "Part",
        uiSection = "Meshes",

        classCheck = function(p2) -- Line: 421, Name: classCheck
            local v3 = p2:IsA("BasePart") and not p2:GetAttribute("IsLightning") and not (p2:GetAttribute("IsCameraShake") or p2:GetAttribute("IsRocks")) and not p2:GetAttribute("IsRope");

            return v3;
        end,

        properties = v1.PartProperties,
        resize = {
            scaleGraphs = { "SizeX", "SizeY", "SizeZ", "Speed", "AccelStrength", "PosOffsetX", "PosOffsetY", "PosOffsetZ", "Turbulence" },
            scaleVectors = { "Acceleration" },
            scaleRanges = { "PosX", "PosY", "PosZ" }
        },
        retime = {
            multiplyNumbers = { "Rate", "Drag", "TurbulenceFrequency" },
            divideRanges = { "Lifetime" },
            multiplyRanges = { "FlipbookFramerate" },
            multiplyGraphs = { "Speed" },
            rotSpeedGraphs = { "RotSpeedX", "RotSpeedY", "RotSpeedZ" },
            squareVectors = { "Acceleration" },
            squareGraphs = { "AccelStrength" }
        },
        clipboard = {
            {
                name = "Spawning",
                props = { "Rate", "Lifetime", "SpreadAngle", "EmissionDirection", "PosX", "PosY", "PosZ", "PosXEven", "PosYEven", "PosZEven", "PositionEvenCycle", "PosMode", "Orientation", "ZOffset" }
            },
            {
                name = "Emission",
                props = { "EmitCount", "EmitDelay", "EmitDuration" }
            },
            {
                name = "Appearance",
                props = { "Brightness", "Color", "SizeX", "SizeY", "SizeZ", "Transparency", "Material" }
            },
            {
                name = "Movement",
                props = { "Speed", "PosOffsetX", "PosOffsetY", "PosOffsetZ", "Turbulence", "TurbulenceFrequency", "RotMode", "RotOrder", "RotSpeedX", "RotSpeedY", "RotSpeedZ", "Acceleration", "Drag", "DirMode", "DisplacementMode", "InvertMotion", "AccelerationTowardsInstance", "AccelStrength", "Timescale" }
            },
            {
                name = "Shape",
                props = { "UseShape", "Shape", "ShapeInOut", "ShapePartial", "LookAtInitially" }
            },
            {
                name = "Flipbook",
                props = { "FlipbookMode", "FlipbookFramerate", "FlipbookStartRandom", "FlipbookReverse" }
            },
            {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "RotX", "RotY", "RotZ", "RotXEven", "RotYEven", "RotZEven", "RotationEvenCycle", "Pool" }
            },
            {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction", "OnHit" }
            }
        }
    },
    Beam = {
        pDataType = "Beam",
        uiSection = "Beams",

        classCheck = function(p4) -- Line: 459, Name: classCheck
            local v5 = p4:IsA("Beam") and p4:FindFirstChild("PartIcleProperties") ~= nil;

            return v5;
        end,

        properties = v1.BeamProperties,
        resize = {
            scaleGraphs = { "Width0", "Width1", "CurveSize0", "CurveSize1", "Segments" }
        },
        retime = {
            multiplyNumbers = { "Rate" },
            divideRanges = { "Lifetime" },
            multiplyRanges = { "FlipbookFramerate" },
            multiplyGraphs = { "TextureSpeed" }
        },
        clipboard = { {
                name = "Spawning",
                props = { "Rate", "Lifetime" }
            }, {
                name = "Emission",
                props = { "EmitCount", "EmitDelay", "EmitDuration" }
            }, {
                name = "Appearance",
                props = { "Brightness", "Width0", "Width1", "LightEmission", "LightInfluence", "ZOffset" }
            }, {
                name = "Geometry",
                props = { "CurveSize0", "CurveSize1", "Segments", "TextureLength", "TextureSpeed", "TextureMode", "FaceCamera" }
            }, {
                name = "Flipbook",
                props = { "FlipbookMode", "FlipbookFramerate", "FlipbookStartRandom", "FlipbookReverse" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "Timescale", "Pool" }
            }, {
                name = "Blender",
                props = { "Blender" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    },
    PointLight = {
        pDataType = "PointLight",
        uiSection = "PointLights",

        classCheck = function(p6) -- Line: 486, Name: classCheck
            return p6:IsA("PointLight");
        end,

        properties = v1.PointLightProperties,
        resize = {
            scaleGraphs = { "Range" }
        },
        retime = {
            multiplyNumbers = { "Rate" },
            divideRanges = { "Lifetime" }
        },
        clipboard = { {
                name = "Spawning",
                props = { "Rate", "Lifetime" }
            }, {
                name = "Emission",
                props = { "EmitCount", "EmitDelay", "EmitDuration" }
            }, {
                name = "Appearance",
                props = { "Range", "Brightness", "Color", "Shadows" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale", "Pool" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    },
    Highlight = {
        pDataType = "Highlight",
        uiSection = "Highlights",

        classCheck = function(p7) -- Line: 508, Name: classCheck
            return p7:IsA("Highlight");
        end,

        properties = v1.HighlightProperties,
        retime = {
            multiplyNumbers = { "Rate" },
            divideRanges = { "Lifetime" }
        },
        clipboard = { {
                name = "Spawning",
                props = { "Rate", "Lifetime" }
            }, {
                name = "Emission",
                props = { "EmitCount", "EmitDelay", "EmitDuration" }
            }, {
                name = "Appearance",
                props = { "FillColor", "FillTransparency", "OutlineColor", "OutlineTransparency", "DepthMode" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale", "Pool" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    },
    TrailEmitter = {
        pDataType = "TrailEmitter",
        uiSection = "TrailEmitters",

        classCheck = function(p8) -- Line: 529, Name: classCheck
            local v9 = p8:IsA("Trail") and p8:FindFirstChild("PartIcleProperties") ~= nil;

            return v9;
        end,

        properties = v1.TrailEmitterProperties,
        resize = {
            scaleGraphs = { "MinLength", "MaxLength" }
        },
        retime = {
            multiplyNumbers = { "Rate" },
            divideRanges = { "Lifetime", "TrailLife" },
            multiplyRanges = { "TrailFlipbookFramerate" }
        },
        clipboard = { {
                name = "Spawning",
                props = { "Rate", "Lifetime" }
            }, {
                name = "Emission",
                props = { "EmitCount", "EmitDelay", "EmitDuration" }
            }, {
                name = "Appearance",
                props = { "Brightness", "LightEmission", "LightInfluence", "Texture", "TextureMode", "FaceCamera" }
            }, {
                name = "Geometry",
                props = { "TextureLength", "MinLength", "MaxLength" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale", "Pool" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    },
    BeamNative = {
        pDataType = "BeamNative",
        uiSection = "BeamNatives",
        directAccess = true,

        classCheck = function(p10) -- Line: 555, Name: classCheck
            local v11 = p10:IsA("Beam") and p10:FindFirstChild("PartIcleProperties") == nil;

            return v11;
        end,

        properties = v1.BeamNativeProperties,
        resize = {
            scaleNumbers = { "Width0", "Width1", "CurveSize0", "CurveSize1" }
        },
        retime = {
            multiplyNumbers = { "TextureSpeed" }
        },
        clipboard = { {
                name = "Appearance",
                props = { "Brightness", "Color", "Transparency", "LightEmission", "LightInfluence", "ZOffset" }
            }, {
                name = "Geometry",
                props = { "Width0", "Width1", "CurveSize0", "CurveSize1", "Segments", "TextureLength", "TextureSpeed", "TextureMode", "FaceCamera" }
            }, {
                name = "Texture",
                props = { "Texture" }
            } }
    },
    Trail = {
        pDataType = "Trail",
        uiSection = "Trails",
        directAccess = true,

        classCheck = function(p12) -- Line: 576, Name: classCheck
            local v13 = p12:IsA("Trail") and p12:FindFirstChild("PartIcleProperties") == nil;

            return v13;
        end,

        properties = v1.TrailProperties,
        resize = {
            scaleGraphs = { "WidthScale" }
        },
        retime = {
            divideNumbers = { "Lifetime" }
        },
        clipboard = { {
                name = "Spawning",
                props = { "Lifetime" }
            }, {
                name = "Emission",
                props = { "Duration" }
            }, {
                name = "Appearance",
                props = { "Brightness", "Transparency", "Color", "WidthScale", "LightEmission", "LightInfluence" }
            }, {
                name = "Geometry",
                props = { "MinLength", "MaxLength", "TextureLength", "TextureMode", "FaceCamera" }
            } }
    },
    Attachment = {
        pDataType = "Attachment",
        uiSection = "Attachments",

        classCheck = function(p14) -- Line: 601, Name: classCheck
            return p14:IsA("Attachment");
        end,

        properties = v1.AttachmentProperties,
        resize = {
            scaleGraphs = { "Speed", "PosOffsetX", "PosOffsetY", "PosOffsetZ", "Turbulence" },
            scaleVectors = { "Acceleration" },
            scaleRanges = { "PosX", "PosY", "PosZ" }
        },
        retime = {
            multiplyNumbers = { "Rate", "Drag", "TurbulenceFrequency" },
            divideRanges = { "Lifetime" },
            multiplyGraphs = { "Speed" },
            rotSpeedGraphs = { "RotSpeedX", "RotSpeedY", "RotSpeedZ" },
            squareVectors = { "Acceleration" }
        },
        clipboard = { {
                name = "Spawning",
                props = { "Rate", "Lifetime", "SpreadAngle", "EmissionDirection", "PosX", "PosY", "PosZ", "PosXEven", "PosYEven", "PosZEven", "PositionEvenCycle", "PosMode", "Orientation", "ZOffset" }
            }, {
                name = "Emission",
                props = { "EmitCount", "EmitDelay", "EmitDuration" }
            }, {
                name = "Movement",
                props = { "Speed", "PosOffsetX", "PosOffsetY", "PosOffsetZ", "Turbulence", "TurbulenceFrequency", "RotMode", "RotOrder", "RotSpeedX", "RotSpeedY", "RotSpeedZ", "Acceleration", "Drag", "DirMode", "DisplacementMode", "InvertMotion", "Timescale" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "RotX", "RotY", "RotZ", "RotXEven", "RotYEven", "RotZEven", "RotationEvenCycle", "Pool" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction", "OnHit" }
            } }
    }
};

for i, v in pairs(TypeDataScreen.Types) do
    v1.Types[i] = v;
end;

local TypeDataLightning = require(script.Parent.TypeDataLightning);
v1.LightningProperties = TypeDataLightning.LightningProperties;

for i, v in pairs(TypeDataLightning.Types) do
    v1.Types[i] = v;
end;

local TypeDataModel = require(script.Parent.TypeDataModel);
v1.ModelProperties = TypeDataModel.ModelProperties;

for i, v in pairs(TypeDataModel.Types) do
    v1.Types[i] = v;
end;

local TypeDataCameraShake = require(script.Parent.TypeDataCameraShake);
v1.CameraShakeProperties = TypeDataCameraShake.CameraShakeProperties;

for i, v in pairs(TypeDataCameraShake.Types) do
    v1.Types[i] = v;
end;

local TypeDataRocks = require(script.Parent.TypeDataRocks);
v1.RocksProperties = TypeDataRocks.RocksProperties;

for i, v in pairs(TypeDataRocks.Types) do
    v1.Types[i] = v;
end;

local TypeDataRope = require(script.Parent.TypeDataRope);
v1.RopeProperties = TypeDataRope.RopeProperties;

for i, v in pairs(TypeDataRope.Types) do
    v1.Types[i] = v;
end;

return v1;