-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Parrotfish",
    Icon = "rbxassetid://135424380374502",
    EarningRate = 220,
    IndexSpeedReward = 72000,
    DropWeight = 0.55,
    VisualOdds = 2773109151.841,
    ModelWeight = 5,
    Egg = {
        DisplayName = "Parrotfish Egg",
        Icon = "rbxassetid://140493305582787",
        GrowthTime = 75,
        WeightKg = 6
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://72768315033468").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://78456388841958").anim
    },
    Rarity = Rarity.Rarities.Rare,
    BaseModelColor = Color3.fromRGB(207, 110, 152),
    PossibleModelColors = {},
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