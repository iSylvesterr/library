-- Decompiled with Potassium's decompiler.

return {
    Name = "giveeagle",
    Description = "Gives a Bald Eagle to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveeagle" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the Bald Eagle to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of Bald Eagles to give (default 1)",
            Optional = true
        } }
};