-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Dog",
    Icon = "rbxassetid://128470938015055",
    EarningRate = 2,
    IndexSpeedReward = 460,
    DropWeight = 0,
    VisualOdds = 2,
    ModelWeight = 25,
    Egg = {
        DisplayName = "Dog Egg",
        Icon = "rbxassetid://91260564167870",
        GrowthTime = 15,
        WeightKg = 1
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://117866633124975").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://85471228397160").anim
    },
    Rarity = Rarity.Rarities.Common,
    BaseModelColor = Color3.fromRGB(165, 85, 85),
    PossibleModelColors = {
        { Color3.fromRGB(165, 85, 85), 170 },
        { Color3.fromRGB(218, 158, 72), 160 },
        { Color3.fromRGB(205, 170, 105), 145 },
        { Color3.fromRGB(238, 220, 175), 115 },
        { Color3.fromRGB(245, 240, 225), 85 },
        { Color3.fromRGB(105, 65, 40), 115 },
        { Color3.fromRGB(55, 45, 38), 90 },
        { Color3.fromRGB(150, 135, 115), 55 },
        { Color3.fromRGB(95, 100, 105), 40 },
        { Color3.fromRGB(185, 185, 178), 25 }
    },
    WalkSound = {
        SoundId = 109859077831837,
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