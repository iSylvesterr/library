-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Camel",
    Icon = "rbxassetid://108762713931799",
    EarningRate = 75,
    IndexSpeedReward = 9000,
    DropWeight = 0.5,
    VisualOdds = 7778.721339,
    ModelWeight = 700,
    Egg = {
        DisplayName = "Camel Egg",
        Icon = "rbxassetid://115243820830396",
        GrowthTime = 45,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://83083910997284").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://136708237711163").anim
    },
    Rarity = Rarity.Rarities.Rare,
    BaseModelColor = Color3.fromRGB(176, 136, 90),
    PossibleModelColors = {
        { Color3.fromRGB(188, 155, 93), 680 },
        { Color3.fromRGB(150, 105, 60), 180 },
        { Color3.fromRGB(220, 195, 140), 105 },
        { Color3.fromRGB(95, 65, 40), 35 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 75763741236219,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    }
};

return setmetatable(v1, {
    __index = Default
});