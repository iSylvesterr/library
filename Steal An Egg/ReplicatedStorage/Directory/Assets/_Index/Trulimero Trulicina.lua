-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Trulimero Trulicina",
    Icon = "rbxassetid://81618825460267",
    EarningRate = 260,
    IndexSpeedReward = 3000,
    DropWeight = 0.25,
    VisualOdds = 475.4503389645072,
    ModelWeight = 140,
    Egg = {
        DisplayName = "Trulimero Trulicina Egg",
        Icon = "rbxassetid://87452659682783",
        GrowthTime = 90,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://138590187651980").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://91056240062272").anim
    },
    Rarity = Rarity.Rarities.Epic,
    PossibleModelColors = {},
    RandomIdleSound = {
        SoundId = 89324287675790,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});