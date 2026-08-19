-- Decompiled with Potassium's decompiler.

return {
    Name = "announce",
    Description = "Makes a server-wide announcement.",
    Group = "DefaultAdmin",
    Aliases = { "m" },
    Args = { {
            Type = "string",
            Name = "text",
            Description = "The announcement text."
        } }
};