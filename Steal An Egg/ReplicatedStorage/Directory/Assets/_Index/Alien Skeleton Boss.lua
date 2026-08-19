-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Cosmic Skeleton Boss",
    Icon = "rbxassetid://78949830377013",
    GenderLocked = "Male",
    EarningRate = 45000000,
    IndexSpeedReward = 1680000,
    DropWeight = 0.1,
    VisualOdds = 5266356515000.135,
    ModelWeight = 1000,
    Egg = {
        DisplayName = "Cosmic Skeleton Boss Egg",
        Icon = "rbxassetid://102395451894667",
        GrowthTime = 9000,
        WeightKg = 8
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://120083284147768").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://103226370812076").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(27, 42, 53),
    PossibleModelColors = {
        { Color3.fromRGB(27, 42, 53), 990 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 85892053481113,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 98648905921986,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});