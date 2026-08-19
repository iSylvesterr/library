-- Decompiled with Potassium's decompiler.

return {
    Name = "givedeer",
    Description = "Adds Deer follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "givedeer" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the deer to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of deer to give (default 1)",
            Optional = true
        } }
};