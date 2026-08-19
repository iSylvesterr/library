-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Audio = require(ReplicatedStorage.Library.Audio);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v1 = {};
local v2 = t.union(t.literal("Male"), t.literal("Female"));

function v1.AssetNameExists(p3) -- Line: 15
    return false, `Asset name "{p3}" cannot be checked before the Assets directory is loaded.`;
end;

v1.DefaultConfig = t.interface({
    _id = t.string,
    DisplayName = t.string,
    Icon = t.optional(t.string),
    Egg = t.interface({
        DisplayName = t.string,
        Icon = t.string,
        GrowthTime = t.numberPositive,
        WeightKg = t.numberPositive,
        HideRarity = t.optional(t.boolean)
    }),
    WhiteImage = t.optional(t.string),
    MutationIcons = t.optional(t.map(t.string, t.string)),
    EarningRate = t.number,
    IndexSpeedReward = t.number,
    DropWeight = t.number,
    VisualOdds = t.number,
    ModelWeight = t.number,
    Animations = t.interface({
        Idle = t.optional(t.instanceIsA("Animation")),
        Walk = t.optional(t.instanceIsA("Animation")),
        TransitionFadeDuration = t.optional(t.numberMin(0))
    }),
    WalkAnimationReferenceSpeed = t.optional(t.numberPositive),
    Rarity = Rarity.Types.DefaultConfig,
    BaseModelScale = t.number,
    LimitedEggViewportScale = t.numberPositive,
    LimitedEggViewportVerticalOffset = t.number,
    BaseModelColor = t.Color3,
    PossibleModelColors = t.array(t.array(t.union(t.Color3, t.number))),
    PlaceSound = t.optional(Audio.__types.SoundFile),
    WalkSound = t.optional(Audio.__types.SoundFile),
    RandomIdleSound = t.optional(Audio.__types.SoundFile),
    LuckyBlockDropTable = t.optional(t.array(t.array(t.union(t.string, t.number)))),
    LuckyBlockDropTableType = t.optional(t.literal("AssetCategories", "RarityTokens")),
    LuckyBlockLevelRange = t.optional(t.array(t.number)),
    LuckyBlockOpenDuration = t.optional(t.number),
    IsTradable = t.optional(t.boolean),
    DontRoll = t.optional(t.boolean),
    CannotFuse = t.optional(t.boolean),
    GenderLocked = t.optional(v2),
    AlbinosColorFullWhite = t.optional(t.boolean)
});

return v1;