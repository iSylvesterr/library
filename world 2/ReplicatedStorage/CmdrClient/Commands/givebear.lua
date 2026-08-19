-- Decompiled with Potassium's decompiler.

return {
    Name = "givebear",
    Description = "Adds Bear follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "givebear" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the bear to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of bears to give (default 1)",
            Optional = true
        } }
};