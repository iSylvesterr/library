-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Hellhound",
    Icon = "rbxassetid://101740580925899",
    EarningRate = 1800000,
    IndexSpeedReward = 1400000,
    DropWeight = 0,
    VisualOdds = 3.57,
    ModelWeight = 72000,
    DontRoll = true,
    Egg = {
        DisplayName = "Demonic Egg",
        Icon = "rbxassetid://109846660752456",
        GrowthTime = 64800,
        WeightKg = 20
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://99261223641676").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://101282719055269").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    BaseModelColor = Color3.fromRGB(38, 30, 34),
    PossibleModelColors = {
        { Color3.fromRGB(38, 30, 34), 1000 }
    }
};

return setmetatable(v1, {
    __index = Default
});