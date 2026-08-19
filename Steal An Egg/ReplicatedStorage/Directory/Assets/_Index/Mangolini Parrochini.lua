-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Mangolini Parrochini",
    Icon = "rbxassetid://109852386744531",
    EarningRate = 800000,
    IndexSpeedReward = 267000,
    DropWeight = 0.1,
    VisualOdds = 10,
    ModelWeight = 1500,
    LimitedEggViewportVerticalOffset = 0.05,
    Egg = {
        DisplayName = "Mangolini Parrochini Egg",
        Icon = "rbxassetid://139937203160382",
        GrowthTime = 600,
        WeightKg = 6,
        HideRarity = true
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://75493177575013").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://75513556478978").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    BaseModelColor = Color3.fromRGB(154, 34, 24),
    PossibleModelColors = {
        { Color3.fromRGB(154, 34, 24), 990 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 118667471602135,
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