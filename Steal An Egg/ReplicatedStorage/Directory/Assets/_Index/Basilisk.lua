-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Leviathan",
    Icon = "rbxassetid://127583688266170",
    EarningRate = 220000,
    IndexSpeedReward = 5000,
    DropWeight = 0.14285714285714285,
    VisualOdds = 1372.3499248948783,
    ModelWeight = 5000,
    Egg = {
        DisplayName = "Leviathan Egg",
        Icon = "rbxassetid://120297489068938",
        GrowthTime = 1500,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://99945162566289").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://134348178448156").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    BaseModelColor = Color3.fromRGB(27, 42, 53),
    PossibleModelColors = {
        { Color3.fromRGB(27, 42, 53), 520 },
        { Color3.fromRGB(19, 24, 13), 210 },
        { Color3.fromRGB(52, 41, 26), 140 },
        { Color3.fromRGB(31, 30, 21), 90 },
        { Color3.fromRGB(33, 33, 31), 40 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    RandomIdleSound = {
        SoundId = 81960453819318,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});