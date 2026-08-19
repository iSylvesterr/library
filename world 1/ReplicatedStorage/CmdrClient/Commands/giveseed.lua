-- Decompiled with Potassium's decompiler.

return {
    Name = "giveseed",
    Description = "Gives seed(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveseed" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give seeds to"
        }, {
            Type = "seedName",
            Name = "SeedName",
            Description = "The name of the seed"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of seeds to give (default 1)",
            Optional = true
        } }
};