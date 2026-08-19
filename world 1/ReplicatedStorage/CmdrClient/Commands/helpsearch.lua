-- Decompiled with Potassium's decompiler.

return {
    Name = "helpsearch",
    Description = "Lists every command whose name, alias, group, or description contains the given string.",
    Group = "DefaultAdmin",
    Aliases = { "helpsearch", "findcmd", "searchcmd" },
    Args = { {
            Type = "string",
            Name = "Query",
            Description = "Substring to search for across all registered commands."
        } }
};