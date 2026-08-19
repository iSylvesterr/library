-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Fennec",
    Icon = "rbxassetid://130204625520606",
    EarningRate = 18,
    IndexSpeedReward = 8100,
    DropWeight = 0.5,
    VisualOdds = 7778.721339,
    ModelWeight = 8,
    Egg = {
        DisplayName = "Fennec Egg",
        Icon = "rbxassetid://73808584409925",
        GrowthTime = 30,
        WeightKg = 2
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://97698541539837").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://87942495505255").anim
    },
    Rarity = Rarity.Rarities.Uncommon,
    BaseModelColor = Color3.fromRGB(214, 186, 142),
    PossibleModelColors = {
        { Color3.fromRGB(214, 186, 142), 780 },
        { Color3.fromRGB(235, 215, 175), 130 },
        { Color3.fromRGB(180, 135, 80), 70 },
        { Color3.fromRGB(255, 187, 128), 20 },
        { Color3.fromRGB(255, 255, 255), 15 }
    },
    WalkSound = {
        SoundId = 75830491774531,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 95694784081534,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});