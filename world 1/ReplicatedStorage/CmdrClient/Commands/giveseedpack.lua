-- Decompiled with Potassium's decompiler.

return {
    Name = "giveseedpack",
    Description = "Gives seed pack(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveseedpack" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give seed packs to"
        }, {
            Type = "seedPackName",
            Name = "PackName",
            Description = "The name of the seed pack"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of seed packs to give (default 1)",
            Optional = true
        } }
};