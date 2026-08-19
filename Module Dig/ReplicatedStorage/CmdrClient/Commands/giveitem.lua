-- Decompiled with Potassium's decompiler.

return {
    Name = "giveitem",
    Description = "Give a player a dirty copy of any item (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player to give the item to"
        }, {
            Type = "itemId",
            Name = "Item",
            Description = "The item to give"
        } }
};