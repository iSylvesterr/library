-- Decompiled with Potassium's decompiler.

return {
    Name = "givetrowel",
    Description = "Gives a trowel to a player",
    Group = "DefaultAdmin",
    Aliases = { "givetrowel", "givet" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the trowel to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of trowels to give (default 1)",
            Optional = true
        } }
};