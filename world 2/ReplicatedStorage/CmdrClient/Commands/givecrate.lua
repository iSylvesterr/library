-- Decompiled with Potassium's decompiler.

return {
    Name = "givecrate",
    Description = "Gives crate(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givecrate" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give crates to"
        }, {
            Type = "crateName",
            Name = "CrateName",
            Description = "The name of the crate"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of crates to give (default 1)",
            Optional = true
        } }
};