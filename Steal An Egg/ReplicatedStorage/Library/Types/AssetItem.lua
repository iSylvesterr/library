-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Parent.Directory.Assets.Types.Personality);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = {};
local v2 = t.union(t.literal("Male"), t.literal("Female"));
v1.AssetItemData = t.interface({
    Category = t.string,
    Mutations = t.array(t.string),
    BaseMutation = t.optional(t.string),
    Scale = t.number,
    Gender = t.optional(v2),
    EyeColor = t.optional(t.string),
    ColorSeed = t.optional(t.number),
    ColorIndex = t.optional(t.number),
    IsFavorite = t.optional(t.boolean),
    GeneratedMoney = t.optional(t.number),
    LastTick = t.optional(t.number),
    PendingEggName = t.optional(t.string),
    Claimed = t.optional(t.boolean),
    LuckyBlockUnlockTimestamp = t.optional(t.number),
    LuckyBlockUnlockDuration = t.optional(t.number),
    LuckyBlockInstantUnlock = t.optional(t.boolean),
    InFuse = t.optional(t.boolean),
    SpecialLuckyBlockColumn = t.optional(t.number),
    SpecialLuckyBlockCapturedAt = t.optional(t.number),
    Personality = t.optional(t.string),
    HasBeenFirstPlaced = t.optional(t.boolean),
    IsStolenDNA = t.optional(t.boolean)
});
v1.AssetItemDataArray = t.array(v1.AssetItemData);
v1.SerializedAssetItemData = t.interface({
    Category = t.string,
    Mutations = t.array(t.string),
    BaseMutation = t.optional(t.string),
    Scale = t.number,
    Gender = t.optional(v2),
    EyeColor = t.optional(t.string),
    ColorSeed = t.optional(t.number),
    ColorIndex = t.optional(t.number),
    IsFavorite = t.optional(t.boolean),
    GeneratedMoney = t.optional(t.number),
    LastTick = t.optional(t.number),
    PendingEggName = t.optional(t.string),
    Claimed = t.optional(t.boolean),
    LuckyBlockUnlockTimestamp = t.optional(t.number),
    LuckyBlockUnlockDuration = t.optional(t.number),
    LuckyBlockInstantUnlock = t.optional(t.boolean),
    InFuse = t.optional(t.boolean),
    SpecialLuckyBlockColumn = t.optional(t.number),
    SpecialLuckyBlockCapturedAt = t.optional(t.number),
    Personality = t.optional(t.string),
    HasBeenFirstPlaced = t.optional(t.boolean),
    IsStolenDNA = t.optional(t.boolean)
});

return v1;