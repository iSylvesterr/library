-- Decompiled with Potassium's decompiler.

return {
    Name = "removeseed",
    Description = "Removes seed(s) from a player",
    Group = "DefaultAdmin",
    Aliases = { "removeseed" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to remove seeds from"
        }, {
            Type = "seedName",
            Name = "SeedName",
            Description = "The name of the seed"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of seeds to remove (default 1)",
            Optional = true
        } }
};