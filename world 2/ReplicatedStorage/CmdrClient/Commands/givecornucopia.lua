-- Decompiled with Potassium's decompiler.

return {
    Name = "givecornucopia",
    Description = "Gives cornucopia(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givecornucopia" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give cornucopias to"
        }, {
            Type = "cornucopiaName",
            Name = "CornucopiaName",
            Description = "The name of the cornucopia"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of cornucopias to give (default 1)",
            Optional = true
        } }
};