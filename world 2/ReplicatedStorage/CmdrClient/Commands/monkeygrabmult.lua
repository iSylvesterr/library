-- Decompiled with Potassium's decompiler.

return {
    Name = "monkeygrabmult",
    Description = "Multiplies the server-wide Monkey grab-fruit chance for everyone. Pass 1 to reset.",
    Group = "DefaultAdmin",
    Aliases = { "monkeygrabmult" },
    Args = { {
            Type = "number",
            Name = "Multiplier",
            Description = "How much more often Monkeys grab a ripe fruit (default 50, use 1 to reset).",
            Optional = true
        } }
};