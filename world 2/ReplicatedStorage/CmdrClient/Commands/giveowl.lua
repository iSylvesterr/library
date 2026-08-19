-- Decompiled with Potassium's decompiler.

return {
    Name = "giveowl",
    Description = "Adds Owl follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "giveowl" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the owl to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of owls to give (default 1)",
            Optional = true
        } }
};