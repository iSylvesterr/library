-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Turtle",
    Icon = "rbxassetid://90736612624734",
    EarningRate = 60,
    IndexSpeedReward = 2750,
    DropWeight = 0.3333333333333333,
    VisualOdds = 349.30572063219404,
    ModelWeight = 100,
    Egg = {
        DisplayName = "Turtle Egg",
        Icon = "rbxassetid://87685717325235",
        GrowthTime = 50,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://79398133579699").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://116555747328509").anim
    },
    Rarity = Rarity.Rarities.Rare,
    BaseModelColor = Color3.fromRGB(93, 134, 61),
    PossibleModelColors = {
        { Color3.fromRGB(93, 134, 61), 560 },
        { Color3.fromRGB(90, 80, 45), 220 },
        { Color3.fromRGB(60, 95, 55), 120 },
        { Color3.fromRGB(140, 115, 65), 75 },
        { Color3.fromRGB(45, 50, 35), 25 },
        { Color3.fromRGB(255, 255, 255), 15 }
    },
    WalkSound = {
        SoundId = 96543613394996,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    }
};

return setmetatable(v1, {
    __index = Default
});