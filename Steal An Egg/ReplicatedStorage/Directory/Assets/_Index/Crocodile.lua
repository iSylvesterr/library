-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Crocodile",
    Icon = "rbxassetid://122868974506056",
    EarningRate = 420,
    IndexSpeedReward = 9000,
    DropWeight = 0.5,
    VisualOdds = 215470.581098,
    ModelWeight = 400,
    Egg = {
        DisplayName = "Crocodile Egg",
        Icon = "rbxassetid://130480701116478",
        GrowthTime = 60,
        WeightKg = 3
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://90280232778597").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://127622983417455").anim
    },
    Rarity = Rarity.Rarities.Epic,
    BaseModelColor = Color3.fromRGB(92, 104, 60),
    PossibleModelColors = {
        { Color3.fromRGB(92, 104, 60), 560 },
        { Color3.fromRGB(55, 75, 45), 210 },
        { Color3.fromRGB(90, 80, 55), 130 },
        { Color3.fromRGB(35, 45, 32), 25 },
        { Color3.fromRGB(255, 255, 255), 2 }
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