-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Sabertooth Tiger",
    Icon = "rbxassetid://96692775133579",
    EarningRate = 35000,
    IndexSpeedReward = 17600,
    DropWeight = 0.25,
    VisualOdds = 10773529.055,
    ModelWeight = 350,
    Egg = {
        DisplayName = "Sabertooth Tiger Egg",
        Icon = "rbxassetid://93865460563487",
        GrowthTime = 240,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://127318092625113").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://105169541499611").anim
    },
    Rarity = Rarity.Rarities.Mythic,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 106128665613743,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 76228157397099,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});