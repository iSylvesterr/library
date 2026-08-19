-- Decompiled with Potassium's decompiler.

return {
    Name = "givesprinkler",
    Description = "Gives a sprinkler to a player",
    Group = "DefaultAdmin",
    Aliases = { "givesprinkler" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the sprinkler to"
        }, {
            Type = "sprinklerName",
            Name = "SprinklerName",
            Description = "The name of the sprinkler"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of sprinklers to give (default 1)",
            Optional = true
        } }
};