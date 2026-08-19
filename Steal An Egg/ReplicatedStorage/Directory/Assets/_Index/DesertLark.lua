-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Bird",
    Icon = "rbxassetid://107145283169125",
    EarningRate = 8,
    IndexSpeedReward = 500,
    DropWeight = 0.3333333333333333,
    VisualOdds = 3.265923580159354,
    ModelWeight = 5,
    Egg = {
        DisplayName = "Bird Egg",
        Icon = "rbxassetid://74743575552986",
        GrowthTime = 25,
        WeightKg = 1
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://83189168987431").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://71642453365136").anim
    },
    Rarity = Rarity.Rarities.Uncommon,
    BaseModelColor = Color3.fromRGB(165, 155, 129),
    PossibleModelColors = {
        { Color3.fromRGB(165, 155, 129), 700 },
        { Color3.fromRGB(190, 175, 135), 180 },
        { Color3.fromRGB(125, 105, 75), 85 },
        { Color3.fromRGB(215, 200, 165), 35 },
        { Color3.fromRGB(255, 255, 255), 15 }
    },
    WalkSound = {
        SoundId = 84310341547585,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 129056410182887,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});