-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Unicorn",
    Icon = "rbxassetid://70463817382627",
    EarningRate = 1000000000,
    IndexSpeedReward = 2400000,
    DropWeight = 10,
    VisualOdds = 168336391482836.53,
    ModelWeight = 1200,
    Egg = {
        DisplayName = "Unicorn Egg",
        Icon = "rbxassetid://126240842939586",
        GrowthTime = 43200,
        WeightKg = 10
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://126479121498082").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://84295085072416").anim
    },
    Rarity = Rarity.Rarities.Divine,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 93124590164789,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 116297838397212,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});