-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Tung Tung Sahur",
    Icon = "rbxassetid://133341038169489",
    EarningRate = 100,
    IndexSpeedReward = 640,
    DropWeight = 0.4,
    VisualOdds = 2.5,
    ModelWeight = 35,
    Egg = {
        DisplayName = "Tung Tung Sahur Egg",
        Icon = "rbxassetid://139937203160382",
        GrowthTime = 15,
        WeightKg = 6,
        HideRarity = true
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://105724138744403").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://132517087966271").anim
    },
    Rarity = Rarity.Rarities.Rare,
    BaseModelColor = Color3.fromRGB(91, 111, 129),
    PossibleModelColors = {
        { Color3.fromRGB(91, 111, 129), 990 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 87776860556516,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 127535170649609,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});