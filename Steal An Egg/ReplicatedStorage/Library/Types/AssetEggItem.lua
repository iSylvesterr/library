-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    AssetEggItemData = t.strictInterface({
        EggName = t.string,
        Mutations = t.array(t.string),
        IsFavorite = t.optional(t.boolean),
        CFrame = t.optional(t.CFrame),
        IsActive = t.optional(t.boolean),
        Scale = t.optional(t.number),
        CreationTime = t.optional(t.number),
        NestSlotIndex = t.optional(t.number),
        GrowthStartedAt = t.optional(t.number),
        GrowthDuration = t.optional(t.number),
        GrowthInitialProgress = t.optional(t.number)
    }),
    SerializedAssetEggItemData = t.strictInterface({
        EggName = t.string,
        Mutations = t.array(t.string),
        IsFavorite = t.optional(t.boolean),
        CFrame = t.optional(t.array(t.number)),
        IsActive = t.optional(t.boolean),
        Scale = t.optional(t.number),
        CreationTime = t.optional(t.number),
        NestSlotIndex = t.optional(t.number),
        GrowthStartedAt = t.optional(t.number),
        GrowthDuration = t.optional(t.number),
        GrowthInitialProgress = t.optional(t.number)
    })
};