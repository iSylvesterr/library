-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "La Vacca Saturno Saturnita",
    Icon = "rbxassetid://86595261029491",
    GenderLocked = "Female",
    EarningRate = 2200000,
    IndexSpeedReward = 1320000,
    DropWeight = 0,
    VisualOdds = 3490000000000,
    ModelWeight = 740,
    Egg = {
        DisplayName = "La Vacca Saturno Saturnita Egg",
        Icon = "rbxassetid://135566519246226",
        GrowthTime = 780,
        WeightKg = 8
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://120183935492627").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://120333516238527").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 121275249192606,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 124578818661623,
        Data = {
            Volume = 1.2,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});