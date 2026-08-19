-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Phoenix",
    Icon = "rbxassetid://118067990008425",
    EarningRate = 85000000,
    IndexSpeedReward = 48000,
    DropWeight = 0.1111111111111111,
    VisualOdds = 1077352905.49,
    ModelWeight = 2500,
    Egg = {
        DisplayName = "Phoenix Egg",
        Icon = "rbxassetid://134491333572507",
        GrowthTime = 16200,
        WeightKg = 5
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://85057156715276").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://104273848115084").anim
    },
    Rarity = Rarity.Rarities.Eternal,
    BaseModelColor = Color3.fromRGB(163, 86, 42),
    PossibleModelColors = {
        { Color3.fromRGB(163, 86, 42), 440 },
        { Color3.fromRGB(255, 123, 47), 210 },
        { Color3.fromRGB(130, 65, 27), 150 },
        { Color3.fromRGB(183, 78, 18), 120 },
        { Color3.fromRGB(255, 0, 0), 80 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 85249941990373,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 116162430890513,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});