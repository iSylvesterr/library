-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Demon Imp",
    Icon = "rbxassetid://137458446707590",
    EarningRate = 700000,
    IndexSpeedReward = 900000,
    DropWeight = 0,
    VisualOdds = 2.38,
    ModelWeight = 45000,
    DontRoll = true,
    Egg = {
        DisplayName = "Demonic Egg",
        Icon = "rbxassetid://109846660752456",
        GrowthTime = 50400,
        WeightKg = 8
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://72081259853723").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://116257151425403").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    BaseModelColor = Color3.fromRGB(92, 24, 30),
    PossibleModelColors = {
        { Color3.fromRGB(92, 24, 30), 1000 }
    }
};

return setmetatable(v1, {
    __index = Default
});