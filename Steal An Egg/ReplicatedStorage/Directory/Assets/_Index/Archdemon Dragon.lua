-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Archdemon Dragon",
    Icon = "rbxassetid://137949993315884",
    EarningRate = 1250000000,
    IndexSpeedReward = 12000000,
    DropWeight = 0,
    VisualOdds = 1000,
    ModelWeight = 120000,
    DontRoll = true,
    Egg = {
        DisplayName = "Demonic Egg",
        Icon = "rbxassetid://109846660752456",
        GrowthTime = 86400,
        WeightKg = 40
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://71670537228396").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://117332439784324").anim
    },
    Rarity = Rarity.Rarities.Divine,
    BaseModelColor = Color3.fromRGB(58, 18, 22),
    PossibleModelColors = {
        { Color3.fromRGB(58, 18, 22), 1000 }
    }
};

return setmetatable(v1, {
    __index = Default
});