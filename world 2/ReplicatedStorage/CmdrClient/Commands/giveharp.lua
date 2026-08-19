-- Decompiled with Potassium's decompiler.

return {
    Name = "giveharp",
    Description = "Gives a Harp to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveharp" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the Harp to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of Harps to give (default 1)",
            Optional = true
        } }
};