-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Spider",
    Icon = "rbxassetid://132010793204072",
    EarningRate = 22000,
    IndexSpeedReward = 12600,
    DropWeight = 0.16666666666666666,
    VisualOdds = 861882.324392,
    ModelWeight = 120,
    Egg = {
        DisplayName = "Spider Egg",
        Icon = "rbxassetid://106778490216774",
        GrowthTime = 270,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://117459506499807").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://71117255441251").anim
    },
    Rarity = Rarity.Rarities.Mythic,
    BaseModelColor = Color3.fromRGB(55, 56, 62),
    PossibleModelColors = {
        { Color3.fromRGB(55, 56, 62), 520 },
        { Color3.fromRGB(45, 35, 30), 180 },
        { Color3.fromRGB(85, 70, 45), 130 },
        { Color3.fromRGB(35, 45, 35), 100 },
        { Color3.fromRGB(130, 95, 45), 50 },
        { Color3.fromRGB(25, 25, 25), 20 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 95492669493151,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 86585082706748,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});