-- Decompiled with Potassium's decompiler.

return {
    Name = "testproplimit",
    Description = "Overrides the per-garden prop placement limit to a specific amount for testing (transient; resets on rejoin).",
    Group = "DefaultAdmin",
    Aliases = { "testproplimit", "setproplimit" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to set the prop limit for"
        }, {
            Type = "integer",
            Name = "Limit",
            Description = "The prop limit to set (>=0). Place count is blocked once the garden reaches this."
        } }
};