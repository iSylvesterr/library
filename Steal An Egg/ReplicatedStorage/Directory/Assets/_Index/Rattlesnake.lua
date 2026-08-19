-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Snake",
    Icon = "rbxassetid://119006769959865",
    EarningRate = 3600,
    IndexSpeedReward = 10800,
    DropWeight = 0.25,
    VisualOdds = 21547.05811,
    ModelWeight = 45,
    Egg = {
        DisplayName = "Snake Egg",
        Icon = "rbxassetid://102762474708216",
        GrowthTime = 150,
        WeightKg = 3
    },
    Animations = {
        TransitionFadeDuration = 0,
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://130705101747406").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://130705101747406").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    BaseModelColor = Color3.fromRGB(165, 126, 72),
    PossibleModelColors = {
        { Color3.fromRGB(165, 126, 72), 680 },
        { Color3.fromRGB(183, 143, 88), 170 },
        { Color3.fromRGB(205, 175, 115), 115 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 96852920499596,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 86273497689098,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});