-- Decompiled with Potassium's decompiler.

return {
    Name = "giverobin",
    Description = "Gives a robin to a player",
    Group = "DefaultAdmin",
    Aliases = { "giverobin" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the robin to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of robins to give (default 1)",
            Optional = true
        } }
};