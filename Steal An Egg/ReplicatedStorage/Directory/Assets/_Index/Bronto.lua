-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Bronto",
    Icon = "rbxassetid://97379364436568",
    EarningRate = 1500000,
    IndexSpeedReward = 300000,
    DropWeight = 0.25,
    VisualOdds = 10773529.055,
    ModelWeight = 35000,
    Egg = {
        DisplayName = "Bronto Egg",
        Icon = "rbxassetid://102498197407436",
        GrowthTime = 660,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://99676847051723").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://93614636566946").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    BaseModelColor = Color3.fromRGB(105, 107, 121),
    PossibleModelColors = {
        { Color3.fromRGB(105, 107, 121), 440 },
        { Color3.fromRGB(110, 95, 70), 210 },
        { Color3.fromRGB(95, 115, 75), 150 },
        { Color3.fromRGB(145, 130, 95), 120 },
        { Color3.fromRGB(65, 65, 70), 80 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 87512139889151,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 75758812305276,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});