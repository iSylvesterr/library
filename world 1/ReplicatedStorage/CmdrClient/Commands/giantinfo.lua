-- Decompiled with Potassium's decompiler.

return {
    Name = "giantinfo",
    Description = "Dumps the stored forever-growth state (FinishedGrowingAt, elapsed, size) of every grows-forever fruit in a garden",
    Group = "DefaultAdmin",
    Aliases = { "giantinfo" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose garden to inspect (defaults to you)",
            Optional = true
        } }
};