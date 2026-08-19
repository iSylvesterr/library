-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Lava frog",
    Icon = "rbxassetid://114459378608051",
    EarningRate = 850,
    IndexSpeedReward = 27000,
    DropWeight = 0.3333333333333333,
    VisualOdds = 134669113.186,
    ModelWeight = 4,
    Egg = {
        DisplayName = "Lava frog Egg",
        Icon = "rbxassetid://91110146804468",
        GrowthTime = 90,
        WeightKg = 5
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://78716529378425").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://87049475895759").anim
    },
    Rarity = Rarity.Rarities.Epic,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 98592829152488,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 110446822397054,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});