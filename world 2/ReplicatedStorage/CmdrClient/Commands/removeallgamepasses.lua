-- Decompiled with Potassium's decompiler.

return {
    Name = "removeallgamepasses",
    Description = "Removes ALL gamepasses from a player and kicks them so they relog",
    Group = "DefaultAdmin",
    Aliases = { "removeallgamepasses" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to remove all gamepasses from"
        } }
};