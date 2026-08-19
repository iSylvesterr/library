-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Lava Dragon",
    Icon = "rbxassetid://78935088838538",
    EarningRate = 100000000,
    IndexSpeedReward = 60000,
    DropWeight = 0.1,
    VisualOdds = 1723764648.784,
    ModelWeight = 14000,
    Egg = {
        DisplayName = "Lava Dragon Egg",
        Icon = "rbxassetid://137621122825975",
        GrowthTime = 18000,
        WeightKg = 5
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://89972004562188").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://76810501908674").anim
    },
    Rarity = Rarity.Rarities.Eternal,
    BaseModelColor = Color3.fromRGB(47, 34, 34),
    PossibleModelColors = {
        { Color3.fromRGB(47, 34, 34), 950 },
        { Color3.fromRGB(190, 35, 25), 50 },
        { Color3.fromRGB(255, 255, 255), 12 }
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
        SoundId = 99271197379717,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});