-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Orangutini Ananassini",
    Icon = "rbxassetid://106995702842298",
    GenderLocked = "Male",
    EarningRate = 5500,
    IndexSpeedReward = 10800,
    DropWeight = 0,
    VisualOdds = 340000,
    ModelWeight = 140,
    Egg = {
        DisplayName = "Orangutini Ananassini Egg",
        Icon = "rbxassetid://138198441332505",
        GrowthTime = 150,
        WeightKg = 3
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://135718557524872").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://122205222823196").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 136703842556018,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 119425637805679,
        Data = {
            Volume = 1.2,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});