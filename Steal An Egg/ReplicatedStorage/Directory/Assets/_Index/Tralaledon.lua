-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Tralaledon",
    Icon = "rbxassetid://83759742597862",
    EarningRate = 32000000,
    IndexSpeedReward = 480000,
    DropWeight = 0.5,
    VisualOdds = 4788235.136,
    ModelWeight = 1000,
    Egg = {
        DisplayName = "Tralaledon Egg",
        Icon = "rbxassetid://73956313512014",
        GrowthTime = 10800,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://95816098943015").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://105841615259977").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(86, 160, 61),
    PossibleModelColors = {
        { Color3.fromRGB(86, 160, 61), 1 },
        { Color3.fromRGB(96, 119, 82), 1 },
        { Color3.fromRGB(90, 100, 105), 1 },
        { Color3.fromRGB(93, 84, 67), 1 },
        { Color3.fromRGB(145, 122, 86), 1 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 111656068182484,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = { 85318836335134, 119220966165422 },
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});