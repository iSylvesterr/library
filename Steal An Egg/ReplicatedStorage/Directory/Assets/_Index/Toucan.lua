-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Toucan",
    Icon = "rbxassetid://125683101618417",
    EarningRate = 110,
    IndexSpeedReward = 8100,
    DropWeight = 0.5,
    VisualOdds = 215470.581098,
    ModelWeight = 5,
    Egg = {
        DisplayName = "Toucan Egg",
        Icon = "rbxassetid://120301498654307",
        GrowthTime = 40,
        WeightKg = 3
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://103568539384204").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://93317338815787").anim
    },
    Rarity = Rarity.Rarities.Rare,
    BaseModelColor = Color3.fromRGB(8, 8, 9),
    PossibleModelColors = {
        { Color3.fromRGB(8, 8, 9), 760 },
        { Color3.fromRGB(45, 45, 42), 120 },
        { Color3.fromRGB(245, 235, 205), 80 },
        { Color3.fromRGB(75, 55, 35), 40 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 84310341547585,
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