-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Pterodactyl",
    Icon = "rbxassetid://92643140066500",
    EarningRate = 22000,
    IndexSpeedReward = 270000,
    DropWeight = 0.5,
    VisualOdds = 215470.581098,
    ModelWeight = 180,
    Egg = {
        DisplayName = "Pterodactyl Egg",
        Icon = "rbxassetid://88209726148785",
        GrowthTime = 180,
        WeightKg = 3
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://139638551129821").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://92715712978388").anim
    },
    Rarity = Rarity.Rarities.Legendary,
    BaseModelColor = Color3.fromRGB(86, 80, 78),
    PossibleModelColors = {
        { Color3.fromRGB(86, 80, 78), 520 },
        { Color3.fromRGB(120, 95, 65), 180 },
        { Color3.fromRGB(150, 130, 95), 130 },
        { Color3.fromRGB(55, 55, 60), 100 },
        { Color3.fromRGB(95, 105, 115), 70 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 129027332074939,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 91501424120077,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});