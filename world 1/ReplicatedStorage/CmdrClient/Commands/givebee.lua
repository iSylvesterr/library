-- Decompiled with Potassium's decompiler.

return {
    Name = "givebee",
    Description = "Adds Bee follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "givebee" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the bee to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of bees to give (default 1)",
            Optional = true
        } }
};