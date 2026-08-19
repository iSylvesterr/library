-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Tiger",
    Icon = "rbxassetid://105792176792591",
    EarningRate = 28000,
    IndexSpeedReward = 14400,
    DropWeight = 0.14285714285714285,
    VisualOdds = 1150976.057531318,
    ModelWeight = 260,
    WalkAnimationReferenceSpeed = 10,
    Egg = {
        DisplayName = "Tiger Egg",
        Icon = "rbxassetid://76046824892930",
        GrowthTime = 360,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://129822945034773").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://102697421744284").anim
    },
    Rarity = Rarity.Rarities.Mythic,
    BaseModelColor = Color3.fromRGB(255, 136, 51),
    PossibleModelColors = {
        { Color3.fromRGB(255, 136, 51), 820 },
        { Color3.fromRGB(238, 229, 205), 120 },
        { Color3.fromRGB(212, 169, 71), 40 }
    },
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