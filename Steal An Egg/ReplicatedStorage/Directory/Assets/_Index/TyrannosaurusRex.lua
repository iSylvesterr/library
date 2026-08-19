-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "TRex",
    Icon = "rbxassetid://123124934383954",
    EarningRate = 25000000,
    IndexSpeedReward = 420000,
    DropWeight = 0.3333333333333333,
    VisualOdds = 134669113.186,
    ModelWeight = 7500,
    WalkAnimationReferenceSpeed = 16,
    Egg = {
        DisplayName = "TRex Egg",
        Icon = "rbxassetid://124390268104324",
        GrowthTime = 9000,
        WeightKg = 5
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://85804925095766").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://117274313338090").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(114, 122, 66),
    PossibleModelColors = {
        { Color3.fromRGB(114, 122, 66), 470 },
        { Color3.fromRGB(95, 75, 45), 210 },
        { Color3.fromRGB(70, 95, 55), 140 },
        { Color3.fromRGB(145, 120, 70), 100 },
        { Color3.fromRGB(113, 103, 86), 60 },
        { Color3.fromRGB(43, 66, 91), 60 },
        { Color3.fromRGB(160, 70, 45), 20 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 86392397661742,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = { 88194339648259, 106670433570032 },
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});