-- Decompiled with Potassium's decompiler.

return {
    Name = "giveegg",
    Description = "Gives egg(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveegg" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give eggs to"
        }, {
            Type = "eggName",
            Name = "EggName",
            Description = "The name of the egg"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of eggs to give (default 1)",
            Optional = true
        } }
};