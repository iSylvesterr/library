-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Royal Sphinx",
    Icon = "rbxassetid://87730617613483",
    EarningRate = 280000,
    IndexSpeedReward = 18000,
    DropWeight = 0.14285714285714285,
    VisualOdds = 86188.232439,
    ModelWeight = 4000,
    Egg = {
        DisplayName = "Royal Sphinx Egg",
        Icon = "rbxassetid://102158231449811",
        GrowthTime = 1800,
        WeightKg = 3
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://77345919406065").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://128542246302725").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    BaseModelColor = Color3.fromRGB(130, 100, 66),
    PossibleModelColors = {
        { Color3.fromRGB(130, 100, 66), 850 },
        { Color3.fromRGB(165, 130, 80), 100 },
        { Color3.fromRGB(95, 70, 45), 50 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 95217113025089,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 124949844244934,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});