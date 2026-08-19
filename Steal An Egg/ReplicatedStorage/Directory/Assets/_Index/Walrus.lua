-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Walrus",
    Icon = "rbxassetid://129141571024477",
    EarningRate = 600,
    IndexSpeedReward = 14400,
    DropWeight = 0.5,
    VisualOdds = 4788235.136,
    ModelWeight = 200,
    Egg = {
        DisplayName = "Walrus Egg",
        Icon = "rbxassetid://81034642321828",
        GrowthTime = 60,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://98973083016392").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://106288976924750").anim
    },
    Rarity = Rarity.Rarities.Epic,
    BaseModelColor = Color3.fromRGB(119, 113, 107),
    PossibleModelColors = {
        { Color3.fromRGB(119, 113, 107), 620 },
        { Color3.fromRGB(105, 85, 70), 180 },
        { Color3.fromRGB(165, 140, 120), 140 },
        { Color3.fromRGB(190, 165, 145), 45 },
        { Color3.fromRGB(70, 60, 55), 15 },
        { Color3.fromRGB(71, 94, 157), 7 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 110863031812081,
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