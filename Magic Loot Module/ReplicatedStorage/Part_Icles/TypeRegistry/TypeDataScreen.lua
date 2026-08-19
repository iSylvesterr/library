-- Decompiled with Potassium's decompiler.

local v1 = {
    BlurProperties = {
        Size = {
            type = "NumberSequence",
            attrName = "BlurSize",
            nonNegative = true,
            default = NumberSequence.new(10)
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
        TotalKeyFrames = {
            type = "number",
            default = 100
        },
        PartLife = {
            type = "number",
            default = 0
        },
        Enabled = {
            type = "boolean",
            default = false
        }
    },
    BloomProperties = {
        Intensity = {
            type = "NumberSequence",
            attrName = "BloomIntensity",
            nonNegative = true,
            default = NumberSequence.new(0.4)
        },
        Size = {
            type = "NumberSequence",
            attrName = "BloomSize",
            nonNegative = true,
            default = NumberSequence.new(24)
        },
        Threshold = {
            type = "NumberSequence",
            attrName = "BloomThreshold",
            nonNegative = true,
            default = NumberSequence.new(0.95)
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
        TotalKeyFrames = {
            type = "number",
            default = 100
        },
        PartLife = {
            type = "number",
            default = 0
        },
        Enabled = {
            type = "boolean",
            default = false
        }
    },
    ColorCorrectionProperties = {
        Brightness = {
            type = "NumberSequence",
            attrName = "CCBrightness",
            default = NumberSequence.new(0)
        },
        Contrast = {
            type = "NumberSequence",
            attrName = "CCContrast",
            default = NumberSequence.new(0)
        },
        Saturation = {
            type = "NumberSequence",
            attrName = "CCSaturation",
            default = NumberSequence.new(0)
        },
        TintColor = {
            type = "ColorSequence",
            attrName = "CCTintColor",
            default = ColorSequence.new(Color3.new(1, 1, 1))
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
        TotalKeyFrames = {
            type = "number",
            default = 100
        },
        PartLife = {
            type = "number",
            default = 0
        },
        Enabled = {
            type = "boolean",
            default = false
        }
    },
    AtmosphereProperties = {
        Density = {
            type = "NumberSequence",
            attrName = "AtmDensity",
            nonNegative = true,
            default = NumberSequence.new(0.3)
        },
        Offset = {
            type = "NumberSequence",
            attrName = "AtmOffset",
            nonNegative = true,
            default = NumberSequence.new(0.25)
        },
        Glare = {
            type = "NumberSequence",
            attrName = "AtmGlare",
            nonNegative = true,
            default = NumberSequence.new(0)
        },
        Haze = {
            type = "NumberSequence",
            attrName = "AtmHaze",
            nonNegative = true,
            default = NumberSequence.new(0)
        },
        Color = {
            type = "ColorSequence",
            attrName = "AtmColor",
            default = ColorSequence.new(Color3.new(0.78, 0.78, 0.78))
        },
        Decay = {
            type = "ColorSequence",
            attrName = "AtmDecay",
            default = ColorSequence.new(Color3.new(0.416, 0.471, 0.541))
        },
        Timescale = {
            type = "NumberSequence",
            attrName = "AtmTimescale",
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
            default = 0
        },
        Enabled = {
            type = "boolean",
            default = false
        }
    },
    ImageLabelProperties = {
        ImageTransparency = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        BackgroundTransparency = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        Speed = {
            type = "NumberSequence",
            attrName = "ImgSpeed",
            nonNegative = true,
            default = NumberSequence.new(0)
        },
        SizeScaleX = {
            type = "NumberSequence",
            nonNegative = true,
            default = NumberSequence.new(1)
        },
        SizeScaleY = {
            type = "NumberSequence",
            nonNegative = true,
            default = NumberSequence.new(1)
        },
        RotRange = {
            type = "NumberRange",
            attrName = "ImgRotRange",
            default = NumberRange.new(0)
        },
        RotSpeed = {
            type = "NumberSequence",
            attrName = "ImgRotSpeed",
            default = NumberSequence.new(0)
        },
        RotMode = {
            type = "string",
            default = "OverLife",
            attrName = "ImgRotMode"
        },
        ImageColor3 = {
            type = "ColorSequence",
            default = ColorSequence.new(Color3.new(1, 1, 1))
        },
        BackgroundColor3 = {
            type = "ColorSequence",
            default = ColorSequence.new(Color3.new(1, 1, 1))
        },
        Image = {
            type = "string",
            default = ""
        },
        Position = {
            type = "UDim2",
            default = UDim2.fromScale(0.5, 0.5)
        },
        Size = {
            type = "UDim2",
            attrName = "ImgSize",
            default = UDim2.fromOffset(100, 100)
        },
        AnchorPoint = {
            type = "Vector2",
            default = Vector2.new(0.5, 0.5)
        },
        ZIndex = {
            type = "number",
            default = 1
        },
        ScaleType = {
            type = "enum",
            enumType = "ScaleType",
            default = Enum.ScaleType.Stretch
        },
        ResampleMode = {
            type = "enum",
            enumType = "ResamplerMode",
            default = Enum.ResamplerMode.Default
        },
        EmissionAngle = {
            type = "number",
            default = 90
        },
        SpreadAngle = {
            type = "number",
            default = 0,
            attrName = "ImgSpreadAngle"
        },
        Acceleration = {
            type = "Vector2",
            attrName = "ImgAcceleration",
            default = Vector2.new(0, 0)
        },
        Drag = {
            type = "number",
            default = 0,
            attrName = "ImgDrag"
        },
        InvertMotion = {
            type = "boolean",
            default = false,
            attrName = "ImgInvertMotion"
        },
        FlipbookSource = {
            type = "string",
            default = "Decals",
            attrName = "ImgFlipbookSource"
        },
        FlipbookMode = {
            type = "enum",
            enumType = "ParticleFlipbookMode",
            attrName = "ImgFlipbookMode",
            default = Enum.ParticleFlipbookMode.Loop
        },
        FlipbookStartRandom = {
            type = "boolean",
            default = false,
            attrName = "ImgFlipbookStartRandom"
        },
        GridCols = {
            type = "number",
            default = 8
        },
        GridRows = {
            type = "number",
            default = 1
        },
        FlipbookFramerate = {
            type = "NumberRange",
            attrName = "ImgFlipbookFramerate",
            default = NumberRange.new(10)
        },
        FlipbookReverse = {
            type = "boolean",
            default = false,
            attrName = "ImgFlipbookReverse"
        },
        Timescale = {
            type = "NumberSequence",
            attrName = "ImgTimescale",
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
            default = 0
        },
        Enabled = {
            type = "boolean",
            default = false
        }
    }
};
v1.Types = {
    Blur = {
        pDataType = "Blur",
        uiSection = "Blurs",

        classCheck = function(p2) -- Line: 135, Name: classCheck
            return p2:IsA("BlurEffect");
        end,

        properties = v1.BlurProperties,
        resize = {
            scaleGraphs = { "Size" }
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
                props = { "Size" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    },
    Bloom = {
        pDataType = "Bloom",
        uiSection = "Blooms",

        classCheck = function(p3) -- Line: 151, Name: classCheck
            return p3:IsA("BloomEffect");
        end,

        properties = v1.BloomProperties,
        resize = {
            scaleGraphs = { "Size" }
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
                props = { "Intensity", "Size", "Threshold" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    },
    ColorCorrection = {
        pDataType = "ColorCorrection",
        uiSection = "ColorCorrections",

        classCheck = function(p4) -- Line: 167, Name: classCheck
            return p4:IsA("ColorCorrectionEffect");
        end,

        properties = v1.ColorCorrectionProperties,
        resize = {},
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
                props = { "Brightness", "Contrast", "Saturation", "TintColor" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    },
    Atmosphere = {
        pDataType = "Atmosphere",
        uiSection = "Atmospheres",

        classCheck = function(p5) -- Line: 183, Name: classCheck
            return p5:IsA("Atmosphere");
        end,

        properties = v1.AtmosphereProperties,
        resize = {},
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
                props = { "Density", "Offset", "Glare", "Haze", "Color", "Decay" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    },
    ImageLabel = {
        pDataType = "ImageLabel",
        uiSection = "ImageLabels",

        classCheck = function(p6) -- Line: 199, Name: classCheck
            return p6:IsA("ImageLabel");
        end,

        properties = v1.ImageLabelProperties,
        resize = {
            scaleGraphs = { "Speed", "SizeScaleX", "SizeScaleY" },
            scaleVectors = { "Acceleration" },
            scaleUDim2s = { "Position", "Size" }
        },
        retime = {
            multiplyNumbers = { "Rate", "Drag" },
            divideRanges = { "Lifetime" },
            multiplyRanges = { "FlipbookFramerate" },
            multiplyGraphs = { "Speed", "RotSpeed" },
            squareVectors = { "Acceleration" }
        },
        clipboard = { {
                name = "Spawning",
                props = { "Rate", "Lifetime", "RotRange", "RotSpeed", "RotMode" }
            }, {
                name = "Emission",
                props = { "EmitCount", "EmitDelay", "EmitDuration" }
            }, {
                name = "Appearance",
                props = { "Image", "ImageColor3", "ImageTransparency", "BackgroundColor3", "BackgroundTransparency", "ScaleType", "ResampleMode" }
            }, {
                name = "Layout",
                props = { "Position", "Size", "SizeScaleX", "SizeScaleY", "AnchorPoint", "ZIndex" }
            }, {
                name = "Motion",
                props = { "Speed", "EmissionAngle", "SpreadAngle", "Acceleration", "Drag", "InvertMotion" }
            }, {
                name = "Flipbook",
                props = { "FlipbookSource", "FlipbookMode", "FlipbookStartRandom", "GridCols", "GridRows", "FlipbookFramerate", "FlipbookReverse" }
            }, {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale" }
            }, {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            } }
    }
};

return v1;