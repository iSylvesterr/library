-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Lava Gecko",
    Icon = "rbxassetid://72012424724645",
    EarningRate = 180,
    IndexSpeedReward = 24000,
    DropWeight = 0.5,
    VisualOdds = 89779408.791,
    ModelWeight = 14,
    Egg = {
        DisplayName = "Lava Gecko Egg",
        Icon = "rbxassetid://133900489402684",
        GrowthTime = 60,
        WeightKg = 5
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://74003246937640").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://105897036611424").anim
    },
    Rarity = Rarity.Rarities.Rare,
    BaseModelColor = Color3.fromRGB(68, 59, 60),
    PossibleModelColors = {},
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