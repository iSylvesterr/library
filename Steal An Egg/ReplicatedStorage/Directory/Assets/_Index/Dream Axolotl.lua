-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Axolotl",
    Icon = "rbxassetid://84193700181481",
    EarningRate = 2800,
    IndexSpeedReward = 4000,
    DropWeight = 0.16666666666666666,
    VisualOdds = 954.119769692145,
    ModelWeight = 28,
    Egg = {
        DisplayName = "Axolotl Egg",
        Icon = "rbxassetid://125947630197409",
        GrowthTime = 300,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://117095482240153").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://71945120495204").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    BaseModelColor = Color3.fromRGB(51, 88, 130),
    PossibleModelColors = {
        { Color3.fromRGB(51, 88, 130), 430 },
        { Color3.fromRGB(95, 70, 55), 230 },
        { Color3.fromRGB(235, 210, 120), 150 },
        { Color3.fromRGB(245, 245, 230), 110 },
        { Color3.fromRGB(45, 45, 45), 60 },
        { Color3.fromRGB(160, 130, 105), 20 }
    },
    WalkSound = {
        SoundId = 82252285582806,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 138943450824966,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});