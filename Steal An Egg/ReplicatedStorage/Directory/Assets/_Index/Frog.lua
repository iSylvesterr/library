-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Frog",
    Icon = "rbxassetid://72292680831922",
    EarningRate = 3,
    IndexSpeedReward = 2000,
    DropWeight = 0.2,
    VisualOdds = 159.607838,
    ModelWeight = 3,
    Egg = {
        DisplayName = "Frog Egg",
        Icon = "rbxassetid://106952885335586",
        GrowthTime = 15,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://100045400244807").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://126703618071787").anim
    },
    Rarity = Rarity.Rarities.Common,
    BaseModelColor = Color3.fromRGB(75, 151, 75),
    PossibleModelColors = {
        { Color3.fromRGB(75, 151, 75), 620 },
        { Color3.fromRGB(105, 130, 55), 170 },
        { Color3.fromRGB(95, 80, 45), 95 },
        { Color3.fromRGB(226, 35, 255), 65 },
        { Color3.fromRGB(55, 120, 120), 35 },
        { Color3.fromRGB(40, 45, 35), 15 },
        { Color3.fromRGB(255, 255, 255), 15 }
    },
    WalkSound = {
        SoundId = 98592829152488,
        Data = {
            Speed = 1,
            Volume = 2.1,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 110446822397054,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});