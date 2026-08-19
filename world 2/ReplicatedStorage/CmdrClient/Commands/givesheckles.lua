-- Decompiled with Potassium's decompiler.

return {
    Name = "givesheckles",
    Description = "Gives sheckles (currency) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givesheckles", "givemoney" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give sheckles to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The amount of sheckles to give"
        } }
};