-- Decompiled with Potassium's decompiler.

return {
    Name = "clearinventory",
    Description = "Clears all items from a player\'s inventory (seeds, tools, fruits, crates, etc.)",
    Group = "DefaultAdmin",
    Aliases = { "clearinv", "wipeinventory", "wipeinv" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to clear inventory for"
        } }
};