-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Cerberus",
    Icon = "rbxassetid://71959618623573",
    GenderLocked = "Male",
    EarningRate = 8000000,
    IndexSpeedReward = 42000,
    DropWeight = 0.12,
    VisualOdds = 718235270.327,
    ModelWeight = 9000,
    WalkAnimationReferenceSpeed = 7,
    Egg = {
        DisplayName = "Cerberus Egg",
        Icon = "rbxassetid://81989677951623",
        GrowthTime = 7200,
        WeightKg = 5
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://128670391346328").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://134754326183729").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(59, 54, 54),
    PossibleModelColors = {
        { Color3.fromRGB(59, 54, 54), 950 },
        { Color3.fromRGB(180, 35, 25), 50 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 103736662890224,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 112652966180684,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});