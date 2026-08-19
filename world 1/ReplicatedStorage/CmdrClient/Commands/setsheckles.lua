-- Decompiled with Potassium's decompiler.

return {
    Name = "setsheckles",
    Description = "Sets a player\'s sheckles (currency) to an exact amount",
    Group = "DefaultAdmin",
    Aliases = { "setsheckles", "setmoney" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to set sheckles for"
        }, {
            Type = "nonNegativeInteger",
            Name = "Amount",
            Description = "The amount of sheckles to set"
        } }
};