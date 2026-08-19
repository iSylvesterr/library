-- Decompiled with Potassium's decompiler.

return {
    Name = "givecrowbar",
    Description = "Gives a crowbar to a player",
    Group = "DefaultAdmin",
    Aliases = { "givecrowbar", "givet" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the crowbar to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of crowbars to give (default 1)",
            Optional = true
        } }
};