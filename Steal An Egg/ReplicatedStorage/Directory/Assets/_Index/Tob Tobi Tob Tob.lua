-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Tob Tobi Tob Tob",
    Icon = "rbxassetid://127993958977152",
    GenderLocked = "Male",
    EarningRate = 325,
    IndexSpeedReward = 9900,
    DropWeight = 0.3333333333333333,
    VisualOdds = 13901.327813000002,
    ModelWeight = 700,
    Egg = {
        DisplayName = "Tob Tobi Tob Tob Egg",
        Icon = "rbxassetid://100658524019292",
        GrowthTime = 75,
        WeightKg = 3
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://114908374085340").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://109723844766192").anim
    },
    Rarity = Rarity.Rarities.Epic,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 132784244995896,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 103713074753122,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});