-- Decompiled with Potassium's decompiler.

return {
    Name = "turkeyseedchance",
    Description = "Sets the server-wide per-second chance for Turkeys to peck up a seed. e.g. 1 = every second. Pass a negative number to reset to defaults.",
    Group = "DefaultAdmin",
    Aliases = { "turkeyseedchance" },
    Args = { {
            Type = "number",
            Name = "ChancePerSecond",
            Description = "Per-second dig chance, 0-1 (1 = every second). Negative resets to species default."
        } }
};