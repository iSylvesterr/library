-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Bear",
    Icon = "rbxassetid://99309954423391",
    EarningRate = 240,
    IndexSpeedReward = 820,
    DropWeight = 0.3333333333333333,
    VisualOdds = 56.702784,
    ModelWeight = 220,
    Egg = {
        DisplayName = "Bear Egg",
        Icon = "rbxassetid://71030998820335",
        GrowthTime = 120,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://117105848139359").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://112971811958973").anim
    },
    Rarity = Rarity.Rarities.Epic,
    BaseModelColor = Color3.fromRGB(83, 60, 32),
    PossibleModelColors = {
        { Color3.fromRGB(83, 60, 32), 640 },
        { Color3.fromRGB(45, 38, 32), 180 },
        { Color3.fromRGB(93, 67, 44), 120 },
        { Color3.fromRGB(210, 190, 150), 45 },
        { Color3.fromRGB(235, 230, 215), 15 }
    },
    WalkSound = {
        SoundId = 98962076190481,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 127207447045739,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});