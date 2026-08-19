-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Gargoyle",
    Icon = "rbxassetid://116474969939081",
    EarningRate = 12000000,
    IndexSpeedReward = 2200000,
    DropWeight = 0,
    VisualOdds = 6.67,
    ModelWeight = 50000,
    DontRoll = true,
    Egg = {
        DisplayName = "Demonic Egg",
        Icon = "rbxassetid://109846660752456",
        GrowthTime = 75600,
        WeightKg = 9
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://80513931984175").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://91735621237424").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(84, 84, 92),
    PossibleModelColors = {
        { Color3.fromRGB(84, 84, 92), 1000 }
    }
};

return setmetatable(v1, {
    __index = Default
});