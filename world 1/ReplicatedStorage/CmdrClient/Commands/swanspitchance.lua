-- Decompiled with Potassium's decompiler.

return {
    Name = "swanspitchance",
    Description = "Sets the server-wide per-second chance for Swans to spit water. e.g. 1 = every second. Pass a negative number to reset to defaults.",
    Group = "DefaultAdmin",
    Aliases = { "swanspitchance" },
    Args = { {
            Type = "number",
            Name = "ChancePerSecond",
            Description = "Per-second spit chance, 0-1 (1 = every second). Negative resets to the flag default."
        } }
};