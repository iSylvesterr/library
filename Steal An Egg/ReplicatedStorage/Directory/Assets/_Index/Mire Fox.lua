-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Fox",
    Icon = "rbxassetid://96639152572865",
    EarningRate = 180,
    IndexSpeedReward = 720,
    DropWeight = 0.14285714285714285,
    VisualOdds = 10.773529,
    ModelWeight = 28,
    Egg = {
        DisplayName = "Fox Egg",
        Icon = "rbxassetid://81784802036459",
        GrowthTime = 90,
        WeightKg = 1
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://115440197758670").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://107607987905386").anim
    },
    Rarity = Rarity.Rarities.Epic,
    BaseModelColor = Color3.fromRGB(255, 72, 0),
    PossibleModelColors = {
        { Color3.fromRGB(255, 72, 0), 760 },
        { Color3.fromRGB(124, 80, 47), 120 },
        { Color3.fromRGB(235, 210, 165), 70 },
        { Color3.fromRGB(45, 42, 38), 35 },
        { Color3.fromRGB(245, 245, 235), 15 }
    },
    WalkSound = {
        SoundId = 72733661023288,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 93011701238042,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});