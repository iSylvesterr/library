-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Mammoth",
    Icon = "rbxassetid://72054098131730",
    EarningRate = 42000,
    IndexSpeedReward = 19200,
    DropWeight = 0,
    VisualOdds = 12000000,
    ModelWeight = 2000,
    Egg = {
        DisplayName = "Mammoth Egg",
        Icon = "rbxassetid://88448405951568",
        GrowthTime = 300,
        WeightKg = 4
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://73103285301861").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://121840579521857").anim
    },
    Rarity = Rarity.Rarities.Mythic,
    BaseModelColor = Color3.fromRGB(52, 34, 23),
    PossibleModelColors = {
        { Color3.fromRGB(52, 34, 23), 620 },
        { Color3.fromRGB(90, 60, 35), 210 },
        { Color3.fromRGB(135, 95, 55), 120 },
        { Color3.fromRGB(190, 165, 125), 40 },
        { Color3.fromRGB(28, 25, 22), 10 },
        { Color3.fromRGB(255, 255, 255), 10 }
    },
    WalkSound = {
        SoundId = 73924753601037,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 109052627263741,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});