-- Decompiled with Potassium's decompiler.

return {
    Name = "afkdebug",
    Description = "Override your anti-AFK idle threshold (seconds) for this session. Use 0 to clear.",
    Group = "DefaultAdmin",
    Aliases = { "afkdebug" },
    Args = { {
            Type = "number",
            Name = "Seconds",
            Description = "Idle seconds before the anti-AFK hop triggers (0 = clear override, back to default)."
        } }
};