-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Kraken",
    Icon = "rbxassetid://136429320011912",
    EarningRate = 15000000,
    IndexSpeedReward = 144000,
    DropWeight = 0.14285714285714285,
    VisualOdds = 40284267734.10782,
    ModelWeight = 18000,
    Egg = {
        DisplayName = "Kraken Egg",
        Icon = "rbxassetid://74154644445138",
        GrowthTime = 8100,
        WeightKg = 6
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://77550298467205").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://125902579005259").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(196, 40, 28),
    PossibleModelColors = {
        { Color3.fromRGB(196, 40, 28), 460 },
        { Color3.fromRGB(120, 55, 85), 190 },
        { Color3.fromRGB(95, 60, 45), 140 },
        { Color3.fromRGB(185, 110, 70), 110 },
        { Color3.fromRGB(55, 45, 60), 70 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 136575457054802,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 95615102125339,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});