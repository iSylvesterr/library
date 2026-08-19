-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Beluga Whale",
    Icon = "rbxassetid://90630918901856",
    EarningRate = 850000,
    IndexSpeedReward = 126000,
    DropWeight = 0,
    VisualOdds = 22000000000,
    ModelWeight = 5000,
    Egg = {
        DisplayName = "Beluga Whale Egg",
        Icon = "rbxassetid://94470939106990",
        GrowthTime = 720,
        WeightKg = 6
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://102403705437382").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://128961185865478").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    PossibleModelColors = {},
    RandomIdleSound = {
        SoundId = 109084013864839,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});