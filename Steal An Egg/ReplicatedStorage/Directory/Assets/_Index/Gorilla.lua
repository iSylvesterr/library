-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Gorilla",
    Icon = "rbxassetid://117411686345819",
    EarningRate = 4800,
    IndexSpeedReward = 9900,
    DropWeight = 0.3333333333333333,
    VisualOdds = 294259.18734308693,
    ModelWeight = 190,
    Egg = {
        DisplayName = "Gorilla Egg",
        Icon = "rbxassetid://125019217025479",
        GrowthTime = 120,
        WeightKg = 3
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://74956622750880").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://97501167000723").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    BaseModelColor = Color3.fromRGB(39, 39, 39),
    PossibleModelColors = {
        { Color3.fromRGB(39, 39, 39), 720 },
        { Color3.fromRGB(65, 65, 65), 180 },
        { Color3.fromRGB(105, 105, 100), 80 },
        { Color3.fromRGB(25, 25, 25), 20 },
        { Color3.fromRGB(237, 234, 234), 2 }
    },
    WalkSound = {
        SoundId = 92160997537319,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 104088414306613,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});