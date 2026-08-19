-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Strawberry Elephant",
    Icon = "rbxassetid://138871903615614",
    EarningRate = 110000000,
    IndexSpeedReward = 143000,
    DropWeight = 0.01,
    VisualOdds = 100,
    ModelWeight = 35000,
    LimitedEggViewportScale = 1.4,
    LimitedEggViewportVerticalOffset = 0.15,
    Egg = {
        DisplayName = "Strawberry Elephant Egg",
        Icon = "rbxassetid://139937203160382",
        GrowthTime = 14400,
        WeightKg = 6,
        HideRarity = true
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://90573984317625").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://98202252617158").anim
    },
    Rarity = Rarity.Rarities.Eternal,
    BaseModelColor = Color3.fromRGB(255, 0, 0),
    PossibleModelColors = {
        { Color3.fromRGB(255, 0, 0), 990 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 73924753601037,
        Data = {
            Speed = 1,
            Volume = 2,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 98860262183478,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});