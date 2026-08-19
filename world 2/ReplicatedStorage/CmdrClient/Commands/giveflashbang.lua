-- Decompiled with Potassium's decompiler.

return {
    Name = "giveflashbang",
    Description = "Gives a flashbang to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveflashbang", "givefb" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the flashbang to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of flashbangs to give (default 1)",
            Optional = true
        } }
};