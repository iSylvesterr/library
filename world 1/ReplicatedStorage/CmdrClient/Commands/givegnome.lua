-- Decompiled with Potassium's decompiler.

return {
    Name = "givegnome",
    Description = "Gives gnome(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givegnome" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give gnomes to"
        }, {
            Type = "gnomeName",
            Name = "GnomeName",
            Description = "The name of the gnome"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of gnomes to give (default 1)",
            Optional = true
        } }
};