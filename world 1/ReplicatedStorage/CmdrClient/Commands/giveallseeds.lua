-- Decompiled with Potassium's decompiler.

return {
    Name = "giveallseeds",
    Description = "Gives 1 of every seed in the game to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveallseeds", "allseeds" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give all seeds to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of each seed to give (default 1)",
            Optional = true
        } }
};