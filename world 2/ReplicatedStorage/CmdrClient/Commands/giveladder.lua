-- Decompiled with Potassium's decompiler.

return {
    Name = "giveladder",
    Description = "Gives ladder(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveladder" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give ladders to"
        }, {
            Type = "string",
            Name = "LadderName",
            Description = "The name of the ladder (e.g. Ladder)"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of ladders to give (default 1)",
            Optional = true
        } }
};