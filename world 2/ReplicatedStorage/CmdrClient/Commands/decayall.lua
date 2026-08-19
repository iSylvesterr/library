-- Decompiled with Potassium's decompiler.

return {
    Name = "decayall",
    Description = "Forces all plants in a player\'s garden into the fully decayed (worst) state",
    Group = "DefaultAdmin",
    Aliases = { "decayall" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose plants should be fully decayed"
        } }
};