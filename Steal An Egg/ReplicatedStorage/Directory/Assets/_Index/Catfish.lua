-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Catfish",
    Icon = "rbxassetid://137813424891388",
    EarningRate = 12,
    IndexSpeedReward = 2500,
    DropWeight = 0.5,
    VisualOdds = 262.769001,
    ModelWeight = 35,
    Egg = {
        DisplayName = "Catfish Egg",
        Icon = "rbxassetid://79651367855993",
        GrowthTime = 30,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://77531242643307").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://97654952506163").anim
    },
    Rarity = Rarity.Rarities.Uncommon,
    BaseModelColor = Color3.fromRGB(4, 175, 236),
    PossibleModelColors = {
        { Color3.fromRGB(4, 175, 236), 470 },
        { Color3.fromRGB(66, 69, 64), 230 },
        { Color3.fromRGB(65, 60, 50), 150 },
        { Color3.fromRGB(116, 255, 151), 100 },
        { Color3.fromRGB(35, 35, 35), 50 },
        { Color3.fromRGB(255, 255, 255), 15 }
    },
    RandomIdleSound = {
        SoundId = 87747919169770,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});