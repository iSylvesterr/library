-- Decompiled with Potassium's decompiler.

return {
    Name = "goldrainbowmult",
    Description = "Multiplies the server-wide Gold (Golden Dragonfly) and Rainbow (Unicorn) mutation chance for everyone. Pass 1 to reset.",
    Group = "DefaultAdmin",
    Aliases = { "goldrainbowmult" },
    Args = { {
            Type = "number",
            Name = "Multiplier",
            Description = "How much more often Gold/Rainbow mutations roll (default 50, use 1 to reset).",
            Optional = true
        } }
};