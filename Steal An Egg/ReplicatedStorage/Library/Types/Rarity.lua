-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    Rarity = t.union(t.literal("Common"), t.literal("Uncommon"), t.literal("Rare"), t.literal("Legendary"), t.literal("Mythical"), t.literal("Divine"), t.literal("Prismatic"), t.literal("Transcendent"))
};