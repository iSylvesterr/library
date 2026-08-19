-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "King Mammoth",
    Icon = "rbxassetid://125958663108854",
    GenderLocked = "Male",
    EarningRate = 400000,
    IndexSpeedReward = 22400,
    DropWeight = 0.2,
    VisualOdds = 17955881.758,
    ModelWeight = 25000,
    Egg = {
        DisplayName = "King Mammoth Egg",
        Icon = "rbxassetid://139700961680740",
        GrowthTime = 900,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://76543140284990").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://70610611286730").anim
    },
    Rarity = Rarity.Rarities.Cosmic,
    PossibleModelColors = {},
    WalkSound = {
        SoundId = 73924753601037,
        Data = {
            Speed = 1,
            Volume = 2,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 109052627263741,
        Data = {
            Volume = 1.8,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});