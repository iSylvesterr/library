-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Bomboclat Crocolat",
    Icon = "rbxassetid://81767576698008",
    EarningRate = 20000000,
    IndexSpeedReward = 860000,
    DropWeight = 0.05,
    VisualOdds = 20,
    ModelWeight = 7000,
    LimitedEggViewportScale = 1.5,
    Egg = {
        DisplayName = "Bomboclat Crocolat Egg",
        Icon = "rbxassetid://139937203160382",
        GrowthTime = 5400,
        WeightKg = 6,
        HideRarity = true
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://84210119087176").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://75412446679060").anim
    },
    Rarity = Rarity.Rarities.Secret,
    BaseModelColor = Color3.fromRGB(60, 88, 48),
    PossibleModelColors = {
        { Color3.fromRGB(60, 88, 48), 990 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 97704959570533,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 71126963498892,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});