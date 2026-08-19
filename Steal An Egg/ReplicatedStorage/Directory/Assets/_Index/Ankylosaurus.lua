-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Ankylosaurus",
    Icon = "rbxassetid://71901208958017",
    EarningRate = 120000,
    IndexSpeedReward = 330000,
    DropWeight = 0.5,
    VisualOdds = 7778.721339,
    ModelWeight = 2500,
    Egg = {
        DisplayName = "Ankylosaurus Egg",
        Icon = "rbxassetid://103179713771844",
        GrowthTime = 300,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://71910623791893").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://115768568703296").anim
    },
    Rarity = Rarity.Rarities.Mythic,
    BaseModelColor = Color3.fromRGB(98, 88, 93),
    PossibleModelColors = {
        { Color3.fromRGB(98, 88, 93), 450 },
        { Color3.fromRGB(95, 80, 60), 210 },
        { Color3.fromRGB(80, 95, 65), 150 },
        { Color3.fromRGB(130, 115, 90), 120 },
        { Color3.fromRGB(55, 55, 55), 70 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 87539099304537,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 91147897361155,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});