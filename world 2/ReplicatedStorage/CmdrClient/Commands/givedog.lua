-- Decompiled with Potassium's decompiler.

return {
    Name = "givedog",
    Description = "Adds Dog follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "givedog" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the dog to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of dogs to give (default 1)",
            Optional = true
        } }
};