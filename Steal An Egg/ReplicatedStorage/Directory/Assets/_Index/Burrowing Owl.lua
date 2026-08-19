-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Owl",
    Icon = "rbxassetid://123516361239872",
    EarningRate = 35,
    IndexSpeedReward = 560,
    DropWeight = 0.2,
    VisualOdds = 6.484806179286864,
    ModelWeight = 8,
    Egg = {
        DisplayName = "Owl Egg",
        Icon = "rbxassetid://96603112916917",
        GrowthTime = 40,
        WeightKg = 1
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://89419902709935").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://137489865198011").anim
    },
    Rarity = Rarity.Rarities.Rare,
    BaseModelColor = Color3.fromRGB(88, 76, 53),
    PossibleModelColors = {
        { Color3.fromRGB(88, 76, 53), 720 },
        { Color3.fromRGB(125, 105, 70), 170 },
        { Color3.fromRGB(65, 58, 45), 75 },
        { Color3.fromRGB(120, 105, 74), 35 },
        { Color3.fromRGB(255, 255, 255), 15 }
    },
    WalkSound = {
        SoundId = 75259005316072,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 92414641075249,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});