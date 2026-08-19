-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Minotaur",
    Icon = "rbxassetid://107707129390656",
    EarningRate = 40000000,
    IndexSpeedReward = 3000000,
    DropWeight = 0,
    VisualOdds = 10,
    ModelWeight = 55000,
    DontRoll = true,
    Egg = {
        DisplayName = "Demonic Egg",
        Icon = "rbxassetid://109846660752456",
        GrowthTime = 82800,
        WeightKg = 12
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://71991960660581").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://135969819602518").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(102, 63, 47),
    PossibleModelColors = {
        { Color3.fromRGB(102, 63, 47), 1000 }
    }
};

return setmetatable(v1, {
    __index = Default
});