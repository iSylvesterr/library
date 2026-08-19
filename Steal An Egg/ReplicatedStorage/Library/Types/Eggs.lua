-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
require(ReplicatedStorage.Directory.Assets.Types.Personality);
require(ReplicatedStorage.Library.Types.AssetItem);
local v1 = {
    MAX_INVENTORY = 115
};
local v2 = t.interface({
    LocalCFrame = t.CFrame,
    PlacedAt = t.number,
    GrowthDuration = t.optional(t.number),
    GrowthCreditSeconds = t.optional(t.number),
    NightGrowthPeriodIndex = t.optional(t.number),
    NightGrowthCreditSeconds = t.optional(t.number),
    ReadyAt = t.optional(t.number)
});
local v3 = t.interface({
    LocalCFrame = t.array(t.number),
    PlacedAt = t.number,
    GrowthDuration = t.optional(t.number),
    GrowthCreditSeconds = t.optional(t.number),
    NightGrowthPeriodIndex = t.optional(t.number),
    NightGrowthCreditSeconds = t.optional(t.number),
    ReadyAt = t.optional(t.number)
});
local v4 = t.interface({
    AssetCategory = t.string,
    AssetScale = t.number,
    AssetEyeColor = t.string,
    AssetColorSeed = t.number,
    AssetColorIndex = t.number,
    Mutations = t.optional(t.array(t.string)),
    BaseMutation = t.optional(t.string),
    AssetGender = t.optional(t.union(t.literal("Male"), t.literal("Female"))),
    AssetPersonality = t.optional(t.string),
    IsStolenDNA = t.optional(t.boolean),
    Placement = t.optional(v2)
});
local v5 = t.interface({
    AssetCategory = t.string,
    AssetScale = t.number,
    AssetEyeColor = t.string,
    AssetColorSeed = t.number,
    AssetColorIndex = t.number,
    Mutations = t.optional(t.array(t.string)),
    BaseMutation = t.optional(t.string),
    AssetGender = t.optional(t.union(t.literal("Male"), t.literal("Female"))),
    AssetPersonality = t.optional(t.string),
    IsStolenDNA = t.optional(t.boolean),
    Placement = t.optional(v3)
});
local v6 = t.interface({
    AssetCategory = t.string,
    AssetScale = t.number,
    AssetEyeColor = t.string,
    AssetColorSeed = t.number,
    AssetColorIndex = t.number,
    Mutations = t.optional(t.array(t.string)),
    BaseMutation = t.optional(t.string),
    AssetGender = t.optional(t.union(t.literal("Male"), t.literal("Female"))),
    AssetPersonality = t.optional(t.string),
    IsStolenDNA = t.optional(t.boolean),
    Placement = t.optional(v2),
    GrowthSpeedMultiplier = t.number
});
v1.SchemaValidation = {
    EggPlacement = v2,
    EggInventory = t.map(t.string, v5),
    PlaceEggRequest = t.interface({
        Uid = t.string,
        LocalCFrame = t.CFrame
    }),
    RuntimeEggOwnerClear = t.interface({
        OwnerUserId = t.number
    }),
    RuntimeEggOwnerUpdate = t.interface({
        OwnerUserId = t.number,
        Records = t.map(t.string, v6)
    }),
    RuntimeEggSnapshot = t.array(t.interface({
        OwnerUserId = t.number,
        Records = t.map(t.string, v6)
    })),
    RuntimeEggRecord = v6,
    SavedEgg = v4,
    SerializedEggPlacement = v3,
    SerializedSavedEgg = v5
};

return v1;