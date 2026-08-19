-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Ice Dragon",
    Icon = "rbxassetid://101397684798718",
    EarningRate = 65000000,
    IndexSpeedReward = 32000,
    DropWeight = 0.125,
    VisualOdds = 61563023.171000004,
    ModelWeight = 8500,
    Egg = {
        DisplayName = "Ice Dragon Egg",
        Icon = "rbxassetid://119364076980389",
        GrowthTime = 14400,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://89972004562188").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://76810501908674").anim
    },
    Rarity = Rarity.Rarities.Eternal,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 93258675255690,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 77733562549629,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});