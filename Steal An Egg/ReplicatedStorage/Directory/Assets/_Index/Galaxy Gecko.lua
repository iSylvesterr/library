-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Cosmic Gecko",
    Icon = "rbxassetid://115834854015858",
    EarningRate = 30000,
    IndexSpeedReward = 1080000,
    DropWeight = 0,
    VisualOdds = 2500000000000,
    ModelWeight = 18,
    Egg = {
        DisplayName = "Cosmic Gecko Egg",
        Icon = "rbxassetid://107132653319667",
        GrowthTime = 240,
        WeightKg = 8
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://138853141977630").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://99128282956160").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    BaseModelColor = Color3.fromRGB(62, 84, 103),
    PossibleModelColors = {
        { Color3.fromRGB(62, 84, 103), 900 },
        { Color3.fromRGB(20, 30, 55), 100 },
        { Color3.fromRGB(255, 255, 255), 15 }
    },
    WalkSound = {
        SoundId = 122588221392543,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 139340174291871,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});