-- Decompiled with Potassium's decompiler.

return {
    Name = "testbird",
    Description = "Makes all birds online (placed birds + bird pets) attempt to eat fruit far more often, for testing. Pass 1 to reset.",
    Group = "DefaultAdmin",
    Aliases = { "testbird" },
    Args = { {
            Type = "number",
            Name = "Multiplier",
            Description = "How much more often birds try to eat (default 20, use 1 to reset).",
            Optional = true
        } }
};