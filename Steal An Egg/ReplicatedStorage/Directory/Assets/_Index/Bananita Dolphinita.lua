-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Bananita Dolphinita",
    Icon = "rbxassetid://99962600313926",
    EarningRate = 400,
    IndexSpeedReward = 710,
    DropWeight = 0.26,
    VisualOdds = 3.8461538461538463,
    ModelWeight = 300,
    Egg = {
        DisplayName = "Bananita Dolphinita Egg",
        Icon = "rbxassetid://139937203160382",
        GrowthTime = 35,
        WeightKg = 6,
        HideRarity = true
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://75900414417695").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://118897156465916").anim
    },
    Rarity = Rarity.Rarities.Epic,
    BaseModelColor = Color3.fromRGB(91, 111, 129),
    PossibleModelColors = {
        { Color3.fromRGB(91, 111, 129), 990 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 124578818661623,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 140355694088112,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});