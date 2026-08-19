-- Decompiled with Potassium's decompiler.

return {
    Name = "givepot",
    Description = "Gives pot to a player",
    Group = "DefaultAdmin",
    Aliases = { "givepot" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give pot to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of pots to give (default 1)",
            Optional = true
        } }
};