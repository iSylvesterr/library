-- Decompiled with Potassium's decompiler.

return {
    Name = "testdragoneat",
    Description = "Bumps YOUR Black Dragons\' per-second eat chance for this session (default 0.2 instead of the normal 0.02). Pass 0.02 to reset.",
    Group = "DefaultAdmin",
    Aliases = { "testdragoneat" },
    Args = { {
            Type = "number",
            Name = "Chance",
            Description = "Per-second eat chance 0-1 (default 0.2; pass 0.02 to reset).",
            Optional = true
        } }
};