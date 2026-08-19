-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);

return {
    Icon = nil,
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1,
    IndexSpeedReward = 0,
    DropWeight = 1,
    VisualOdds = 1,
    ModelWeight = 80,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    IsTradable = nil,
    DontRoll = nil,
    GenderLocked = nil,
    DisplayName = script.Name,
    Egg = {
        Icon = "rbxassetid://116524274262912",
        GrowthTime = 60,
        WeightKg = 80,
        DisplayName = script.Name
    },
    Animations = {
        Walk = nil,
        Idle = Pipeline:GetAndSerializeAnimation("rbxassetid://122342179426051").anim
    },
    Rarity = Rarity.Rarities.Common,
    BaseModelColor = Color3.fromRGB(86, 160, 61),
    PossibleModelColors = {
        { Color3.fromRGB(86, 160, 61), 1 },
        { Color3.fromRGB(96, 119, 82), 1 },
        { Color3.fromRGB(90, 100, 105), 1 },
        { Color3.fromRGB(93, 84, 67), 1 },
        { Color3.fromRGB(145, 122, 86), 1 }
    }
};