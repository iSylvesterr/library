-- Decompiled with Potassium's decompiler.

return {
    Name = "dogcratechance",
    Description = "Sets the server-wide per-second chance for Dogs to dig up a crate. e.g. 1 = every second. Pass a negative number to reset to defaults.",
    Group = "DefaultAdmin",
    Aliases = { "dogcratechance" },
    Args = { {
            Type = "number",
            Name = "ChancePerSecond",
            Description = "Per-second dig chance, 0-1 (1 = every second). Negative resets to species default."
        } }
};