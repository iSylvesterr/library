-- Decompiled with Potassium's decompiler.

return {
    Name = "kickall",
    Description = "Kicks every player currently online from this server.",
    Group = "DefaultAdmin",
    Aliases = { "kickall" },
    Args = { {
            Type = "string",
            Name = "Reason",
            Description = "Optional reason shown to kicked players.",
            Optional = true
        } }
};