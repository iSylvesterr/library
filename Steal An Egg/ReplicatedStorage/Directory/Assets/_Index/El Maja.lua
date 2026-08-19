-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "El Maja",
    Icon = "rbxassetid://77518688092604",
    GenderLocked = "Male",
    EarningRate = 130000000,
    IndexSpeedReward = 180000,
    DropWeight = 0.125,
    VisualOdds = 66391535236.3381,
    ModelWeight = 90000,
    Egg = {
        DisplayName = "El Maja Egg",
        Icon = "rbxassetid://86275614169244",
        GrowthTime = 19800,
        WeightKg = 6
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://132181117287223").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://75800532076044").anim
    },
    Rarity = Rarity.Rarities.Eternal,
    BaseModelColor = Color3.fromRGB(0, 153, 255),
    PossibleModelColors = {
        { Color3.fromRGB(0, 153, 255), 900 },
        { Color3.fromRGB(0, 45, 95), 100 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    RandomIdleSound = {
        SoundId = 88927188226844,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});