-- Decompiled with Potassium's decompiler.

return {
    Name = "removesheckles",
    Description = "Removes sheckles (currency) from a player",
    Group = "DefaultAdmin",
    Aliases = { "removesheckles", "removemoney" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to remove sheckles from"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The amount of sheckles to remove"
        } }
};