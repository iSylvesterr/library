-- Decompiled with Potassium's decompiler.

return {
    Name = "sellmode",
    Description = "Force the A/B sell-gamble arm at Steven: Bargain (control) or DoubleOrNothing (variant). Use \'clear\' to revert to the A/B assignment.",
    Group = "DefaultAdmin",
    Aliases = { "sellmode", "setsellmode" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to override"
        }, {
            Type = "string",
            Name = "Mode",
            Description = "Bargain | DoubleOrNothing | clear"
        } }
};