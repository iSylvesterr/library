-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Belula Beluga",
    Icon = "rbxassetid://131612050648072",
    EarningRate = 40000,
    IndexSpeedReward = 2580,
    DropWeight = 0.2,
    VisualOdds = 5,
    ModelWeight = 800,
    Egg = {
        DisplayName = "Belula Beluga Egg",
        Icon = "rbxassetid://139937203160382",
        GrowthTime = 120,
        WeightKg = 6,
        HideRarity = true
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://89535663236245").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://98122045191941").anim
    },
    Rarity = Rarity.Rarities.Mythic,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 118667471602135,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 90413578033778,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});