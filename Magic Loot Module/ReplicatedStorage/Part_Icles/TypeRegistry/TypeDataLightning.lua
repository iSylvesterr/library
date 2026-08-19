-- Decompiled with Potassium's decompiler.

local v1 = {
    LightningProperties = {
        Color = {
            type = "ColorSequence",
            default = ColorSequence.new(Color3.new(1, 1, 1))
        },
        Gradient = {
            type = "ColorSequence",
            default = ColorSequence.new(Color3.new(1, 1, 1))
        },
        Brightness = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        Transparency = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        Thickness = {
            type = "NumberSequence",
            default = NumberSequence.new(0.15)
        },
        Timescale = {
            type = "NumberSequence",
            default = NumberSequence.new(1)
        },
        Rate = {
            type = "number",
            default = 10
        },
        Lifetime = {
            type = "NumberRange",
            default = NumberRange.new(1)
        },
        Enabled = {
            type = "boolean",
            default = false
        },
        TargetMode = {
            type = "string",
            default = "Directional"
        },
        SeekRadius = {
            type = "NumberRange",
            nonNegative = true,
            default = NumberRange.new(30)
        },
        SeekRetarget = {
            type = "boolean",
            default = false
        },
        SeekBias = {
            type = "number",
            default = 0,
            nonNegative = true
        },
        RetargetSpeed = {
            type = "number",
            default = 0,
            nonNegative = true
        },
        Length = {
            type = "NumberRange",
            default = NumberRange.new(20)
        },
        GrowthSpeed = {
            type = "number",
            default = 0
        },
        SpreadAngle = {
            type = "Vector2",
            default = Vector2.new(0, 0)
        },
        EmissionDirection = {
            type = "enum",
            enumType = "NormalId",
            default = Enum.NormalId.Top
        },
        SegmentCount = {
            type = "NumberRange",
            default = NumberRange.new(12)
        },
        Amplitude = {
            type = "NumberRange",
            default = NumberRange.new(0.15)
        },
        AmplitudeDecay = {
            type = "NumberRange",
            nonNegative = true,
            default = NumberRange.new(0.5)
        },
        JitterRate = {
            type = "NumberRange",
            nonNegative = true,
            default = NumberRange.new(15)
        },
        ForkChance = {
            type = "NumberRange",
            nonNegative = true,
            default = NumberRange.new(0)
        },
        ForkDepth = {
            type = "NumberRange",
            nonNegative = true,
            default = NumberRange.new(0)
        },
        ForkLengthScale = {
            type = "NumberRange",
            nonNegative = true,
            default = NumberRange.new(0.4)
        },
        Sag = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        SagShape = {
            type = "NumberRange",
            nonNegative = true,
            default = NumberRange.new(1)
        },
        ShapeMode = {
            type = "string",
            default = "Jitter"
        },
        ScrollSpeed = {
            type = "NumberRange",
            default = NumberRange.new(1)
        },
        Waves = {
            type = "NumberRange",
            nonNegative = true,
            default = NumberRange.new(3)
        },
        UseShape = {
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
        ShapePartial = {
            type = "number",
            default = 0
        },
        ShapeDirection = {
            type = "string",
            default = "Emitter"
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
        PosMode = {
            type = "string",
            default = "Local"
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
        RotationEvenCycle = {
            type = "NumberRange",
            default = NumberRange.new(0)
        },
        RotOrder = {
            type = "string",
            default = "Global"
        },
        DirMode = {
            type = "string",
            default = "RigidLocal"
        },
        Speed = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        Acceleration = {
            type = "Vector3",
            default = Vector3.new(0, 0, 0)
        },
        Drag = {
            type = "number",
            default = 0
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
        DisplacementMode = {
            type = "string",
            default = "Global"
        },
        Turbulence = {
            type = "NumberSequence",
            default = NumberSequence.new(0)
        },
        TurbulenceFrequency = {
            type = "number",
            default = 1
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
        TotalKeyFrames = {
            type = "number",
            default = 100
        },
        PartLife = {
            type = "number",
            default = 0,
            nonNegative = true
        },
        Pool = {
            type = "boolean",
            default = false
        }
    }
};
v1.Types = {
    Lightning = {
        pDataType = "Lightning",
        uiSection = "Lightnings",

        classCheck = function(p2) -- Line: 149, Name: classCheck
            local v3 = p2:IsA("BasePart");

            if v3 then
                if p2:GetAttribute("IsLightning") == true then
                    v3 = p2:FindFirstChild("PartIcleProperties") ~= nil;
                else
                    v3 = false;
                end;
            end;

            return v3;
        end,

        properties = v1.LightningProperties,
        resize = {
            scaleGraphs = { "Thickness", "Speed", "PosOffsetX", "PosOffsetY", "PosOffsetZ", "Turbulence" },
            scaleVectors = { "Acceleration" },
            scaleRanges = { "Length", "PosX", "PosY", "PosZ", "SeekRadius" },
            scaleNumbers = { "GrowthSpeed", "RetargetSpeed" }
        },
        retime = {
            multiplyNumbers = { "Rate", "GrowthSpeed", "Drag", "TurbulenceFrequency", "RetargetSpeed" },
            multiplyRanges = { "JitterRate", "ScrollSpeed" },
            multiplyGraphs = { "Speed" },
            squareVectors = { "Acceleration" },
            divideRanges = { "Lifetime" }
        },
        clipboard = {
            {
                name = "Spawning",
                props = { "Rate", "Lifetime", "TargetMode", "SeekRadius", "SeekRetarget", "SeekBias", "RetargetSpeed", "Length", "GrowthSpeed", "SpreadAngle", "EmissionDirection", "PosX", "PosY", "PosZ", "PosXEven", "PosYEven", "PosZEven", "PositionEvenCycle", "PosMode", "RotX", "RotY", "RotZ", "RotXEven", "RotYEven", "RotZEven", "RotationEvenCycle", "RotOrder", "DirMode" }
            },
            {
                name = "Emission",
                props = { "EmitCount", "EmitDelay", "EmitDuration" }
            },
            {
                name = "Bolt Shape",
                props = { "ShapeMode", "SegmentCount", "Amplitude", "AmplitudeDecay", "JitterRate", "ScrollSpeed", "Waves", "ForkChance", "ForkDepth", "ForkLengthScale", "Sag", "SagShape" }
            },
            {
                name = "Shape",
                props = { "UseShape", "Shape", "ShapeInOut", "ShapePartial", "ShapeDirection" }
            },
            {
                name = "Movement",
                props = { "Speed", "PosOffsetX", "PosOffsetY", "PosOffsetZ", "Turbulence", "TurbulenceFrequency", "Acceleration", "Drag", "DisplacementMode" }
            },
            {
                name = "Appearance",
                props = { "Color", "Gradient", "Brightness", "Transparency", "Thickness", "Material" }
            },
            {
                name = "Advanced",
                props = { "TotalKeyFrames", "PartLife", "Timescale", "Pool" }
            },
            {
                name = "Events",
                props = { "OnEmit", "OnDeath", "OnDestruction" }
            }
        }
    }
};

return v1;