-- Decompiled with Potassium's decompiler.

return {
    Name = "surfaceitem",
    Description = "Surface an item in a dig zone right now, optionally forcing a rarity (admin only).",
    Group = "Admin",
    Args = { {
            Type = "itemRarity",
            Name = "Rarity",
            Description = "The rarity to surface (omit to roll normally)",
            Optional = true
        } }
};