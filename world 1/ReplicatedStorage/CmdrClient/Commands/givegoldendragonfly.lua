-- Decompiled with Potassium's decompiler.

return {
    Name = "givegoldendragonfly",
    Description = "Adds Golden Dragonfly follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "givegoldendragonfly" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the golden dragonfly to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of golden dragonflies to give (default 1)",
            Optional = true
        } }
};