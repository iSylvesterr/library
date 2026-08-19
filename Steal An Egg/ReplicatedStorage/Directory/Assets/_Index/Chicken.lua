-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Chicken",
    Icon = "rbxassetid://87733160598688",
    EarningRate = 1,
    IndexSpeedReward = 420,
    DropWeight = 0.5,
    VisualOdds = 2.154706,
    ModelWeight = 8,
    Egg = {
        DisplayName = "Chicken Egg",
        Icon = "rbxassetid://133004694392561",
        GrowthTime = 10,
        WeightKg = 1
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://139122582247217").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://139560613766322").anim
    },
    Rarity = Rarity.Rarities.Common,
    BaseModelColor = Color3.fromRGB(248, 248, 248),
    PossibleModelColors = {
        { Color3.fromRGB(248, 248, 248), 760 },
        { Color3.fromRGB(230, 210, 160), 120 }
    },
    WalkSound = {
        SoundId = 77569052979374,
        Data = {
            Speed = 1,
            Volume = 2,
            MaxDistance = 20,
            Looped = true
        }
    }
};

return setmetatable(v1, {
    __index = Default
});