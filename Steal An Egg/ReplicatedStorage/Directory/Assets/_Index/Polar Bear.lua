-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Polar Bear",
    Icon = "rbxassetid://81532861297291",
    EarningRate = 7000,
    IndexSpeedReward = 16000,
    DropWeight = 0.5,
    VisualOdds = 4788235.136,
    ModelWeight = 650,
    Egg = {
        DisplayName = "Polar Bear Egg",
        Icon = "rbxassetid://118897853908991",
        GrowthTime = 120,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://75033907531372").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://100083657738512").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 98962076190481,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 127207447045739,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});