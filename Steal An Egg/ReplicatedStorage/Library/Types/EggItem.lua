-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    EggItemData = t.strictInterface({
        EggName = t.string,
        IsFavorite = t.optional(t.boolean),
        CFrame = t.optional(t.CFrame),
        TimeToHatch = t.optional(t.number),
        HatchEndTime = t.optional(t.number),
        IsActive = t.optional(t.boolean),
        SlotIndex = t.optional(t.number),
        Scale = t.optional(t.number)
    }),
    SerializedEggItemData = t.strictInterface({
        EggName = t.string,
        IsFavorite = t.optional(t.boolean),
        CFrame = t.optional(t.array(t.number)),
        TimeToHatch = t.optional(t.number),
        HatchEndTime = t.optional(t.number),
        IsActive = t.optional(t.boolean),
        SlotIndex = t.optional(t.number),
        Scale = t.optional(t.number)
    })
};