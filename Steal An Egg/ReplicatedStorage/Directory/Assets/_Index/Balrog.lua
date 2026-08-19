-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Balrog",
    Icon = "rbxassetid://136823106702803",
    EarningRate = 200000000,
    IndexSpeedReward = 4500000,
    DropWeight = 0,
    VisualOdds = 20.41,
    ModelWeight = 65000,
    DontRoll = true,
    Egg = {
        DisplayName = "Demonic Egg",
        Icon = "rbxassetid://109846660752456",
        GrowthTime = 86400,
        WeightKg = 16
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://137935991627684").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://112496245402060").anim
    },
    Rarity = Rarity.Rarities.Eternal,
    BaseModelColor = Color3.fromRGB(120, 36, 26),
    PossibleModelColors = {
        { Color3.fromRGB(120, 36, 26), 1000 }
    }
};

return setmetatable(v1, {
    __index = Default
});