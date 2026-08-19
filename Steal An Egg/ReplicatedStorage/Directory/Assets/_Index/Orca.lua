-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Orca",
    Icon = "rbxassetid://90382263788089",
    EarningRate = 80000,
    IndexSpeedReward = 99000,
    DropWeight = 0,
    VisualOdds = 19000000000,
    ModelWeight = 1800,
    Egg = {
        DisplayName = "Orca Egg",
        Icon = "rbxassetid://99932807273458",
        GrowthTime = 360,
        WeightKg = 6
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://127927181298183").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://118415860190284").anim
    },
    Rarity = Rarity.Rarities.Mythic,
    BaseModelColor = Color3.fromRGB(17, 17, 17),
    PossibleModelColors = {},
    RandomIdleSound = {
        SoundId = 72265202988047,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});