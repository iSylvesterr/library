-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Brr Brr Patapim",
    Icon = "rbxassetid://111877395304221",
    GenderLocked = "Male",
    EarningRate = 1800,
    IndexSpeedReward = 1000,
    DropWeight = 0.25,
    VisualOdds = 102.605039,
    ModelWeight = 800,
    Egg = {
        DisplayName = "Brr Brr Patapim Egg",
        Icon = "rbxassetid://86499305011812",
        GrowthTime = 300,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://121373550635703").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://100794445119193").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 87776860556516,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 113732812225664,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});