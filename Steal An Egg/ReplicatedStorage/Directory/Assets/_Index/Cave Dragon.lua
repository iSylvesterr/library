-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Cosmic Dragon",
    Icon = "rbxassetid://107923370723949",
    EarningRate = 60000000,
    IndexSpeedReward = 1440000,
    DropWeight = 70,
    VisualOdds = 1141825743428080.2,
    ModelWeight = 15000,
    Egg = {
        DisplayName = "Cosmic Dragon Egg",
        Icon = "rbxassetid://108447968078067",
        GrowthTime = 10800,
        WeightKg = 8
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://102500062625694").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://137187648227824").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(27, 42, 53),
    PossibleModelColors = {
        { Color3.fromRGB(27, 42, 53), 1000 },
        { Color3.fromRGB(52, 79, 85), 200 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 139724850248238,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 84365701151321,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});