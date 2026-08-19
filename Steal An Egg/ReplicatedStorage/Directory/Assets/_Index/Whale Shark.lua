-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Whale Shark",
    Icon = "rbxassetid://133745688279874",
    EarningRate = 700000,
    IndexSpeedReward = 108000,
    DropWeight = 0.25,
    VisualOdds = 14504941186.087273,
    ModelWeight = 2000,
    Egg = {
        DisplayName = "Whale Shark Egg",
        Icon = "rbxassetid://95374412366370",
        GrowthTime = 600,
        WeightKg = 6
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://96079428169602").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://94460509562960").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    BaseModelColor = Color3.fromRGB(0, 32, 96),
    PossibleModelColors = {
        { Color3.fromRGB(0, 32, 96), 680 },
        { Color3.fromRGB(25, 43, 54), 160 },
        { Color3.fromRGB(37, 43, 45), 110 },
        { Color3.fromRGB(38, 41, 41), 35 },
        { Color3.fromRGB(25, 35, 45), 15 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    RandomIdleSound = {
        SoundId = 109084013864839,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});