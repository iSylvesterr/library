-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Chillin Chilli",
    Icon = "rbxassetid://72909501825643",
    GenderLocked = "Male",
    EarningRate = 55000,
    IndexSpeedReward = 33000,
    DropWeight = 0.16666666666666666,
    VisualOdds = 478823513.551,
    ModelWeight = 30,
    Egg = {
        DisplayName = "Chillin Chilli Egg",
        Icon = "rbxassetid://122894089279706",
        GrowthTime = 420,
        WeightKg = 5
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://119275384872623").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://122441867955694").anim
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
        SoundId = 104388767547534,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});