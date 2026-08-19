-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Flaming Bull",
    Icon = "rbxassetid://77430751529509",
    EarningRate = 9500,
    IndexSpeedReward = 30000,
    DropWeight = 0.25,
    VisualOdds = 195882346.453,
    ModelWeight = 450,
    Egg = {
        DisplayName = "Flaming Bull Egg",
        Icon = "rbxassetid://70883699567304",
        GrowthTime = 180,
        WeightKg = 5
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://102660603214468").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://118005353706335").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 123565424234895,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 73942787332078,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});