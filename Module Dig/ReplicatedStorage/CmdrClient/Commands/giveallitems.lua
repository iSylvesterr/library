-- Decompiled with Potassium's decompiler.

return {
    Name = "giveallitems",
    Description = "Give a player one dirty copy of every item in the game (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player to give every item to",
            Optional = true
        } }
};