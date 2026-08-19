-- Decompiled with Potassium's decompiler.

return {
    Name = "givefrog",
    Description = "Adds Frog follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "givefrog" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the frog to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of frogs to give (default 1)",
            Optional = true
        } }
};