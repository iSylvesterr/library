-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {
    DisplayName = "Eternal Lunar Dragon",
    Icon = "rbxassetid://93762296316916",
    EarningRate = 250000000,
    IndexSpeedReward = 1920000,
    DropWeight = 20,
    VisualOdds = 28729410813070.773,
    ModelWeight = 60000,
    Egg = {
        DisplayName = "Eternal Lunar Dragon Egg",
        Icon = "rbxassetid://76095389378180",
        GrowthTime = 25200,
        WeightKg = 9
    },
    Animations = {
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://118874129580676").anim,
        Walk = Pipeline:GetAndSerializeAnimation("rbxassetid://139537878984191").anim
    },
    Rarity = Rarity.Rarities.Eternal,
    BaseModelColor = Color3.fromRGB(27, 42, 53),
    PossibleModelColors = {
        { Color3.fromRGB(27, 42, 53), 700 },
        { Color3.fromRGB(49, 53, 71), 200 },
        { Color3.fromRGB(51, 59, 60), 100 },
        { Color3.fromRGB(255, 255, 255), 12 }
    },
    WalkSound = {
        SoundId = 71370919924821,
        Data = {
            Speed = 1,
            Volume = 1.5,
            MaxDistance = 20,
            Looped = true
        }
    },
    RandomIdleSound = {
        SoundId = 109543717701603,
        Data = {
            Volume = 1.5,
            MaxDistance = 20
        }
    }
};

return setmetatable(v1, {
    __index = Default
});