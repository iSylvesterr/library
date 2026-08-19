-- Decompiled with Potassium's decompiler.

return {
    Name = "removesprinkler",
    Description = "Removes a sprinkler from a player",
    Group = "DefaultAdmin",
    Aliases = { "removesprinkler" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to remove the sprinkler from"
        }, {
            Type = "sprinklerName",
            Name = "SprinklerName",
            Description = "The name of the sprinkler"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of sprinklers to remove (default 1)",
            Optional = true
        } }
};