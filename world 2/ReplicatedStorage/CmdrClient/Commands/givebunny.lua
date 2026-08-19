-- Decompiled with Potassium's decompiler.

return {
    Name = "givebunny",
    Description = "Adds Bunny follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "givebunny" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the bunny to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of bunnies to give (default 1)",
            Optional = true
        } }
};