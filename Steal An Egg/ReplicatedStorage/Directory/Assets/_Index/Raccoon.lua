-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Raccoon",
    Icon = "rbxassetid://108876887480947",
    EarningRate = 45,
    IndexSpeedReward = 620,
    DropWeight = 0.16666666666666666,
    VisualOdds = 8.44701453885662,
    ModelWeight = 19,
    Egg = {
        DisplayName = "Raccoon Egg",
        Icon = "rbxassetid://119179522600617",
        GrowthTime = 50,
        WeightKg = 1
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://110452042491667").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://134919972715929").anim
    },
    Rarity = Rarity.Rarities.Rare,
    BaseModelColor = Color3.fromRGB(91, 93, 105),
    PossibleModelColors = {
        { Color3.fromRGB(91, 93, 105), 760 },
        { Color3.fromRGB(65, 65, 70), 140 },
        { Color3.fromRGB(130, 125, 115), 70 },
        { Color3.fromRGB(66, 64, 64), 30 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 93247766618772,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 99003636968368,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});