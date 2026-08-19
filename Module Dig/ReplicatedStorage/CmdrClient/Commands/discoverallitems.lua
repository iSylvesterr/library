-- Decompiled with Potassium's decompiler.

return {
    Name = "discoverallitems",
    Description = "Mark every item in the game as discovered in a player\'s collection (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player whose collection to fill in",
            Optional = true
        } }
};