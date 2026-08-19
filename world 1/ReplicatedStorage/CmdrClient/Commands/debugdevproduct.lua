-- Decompiled with Potassium's decompiler.

return {
    Name = "debugdevproduct",
    Description = "Look up a developer product by name in the sync DataStore",
    Group = "DefaultAdmin",
    Aliases = { "debugdevproduct" },
    Args = { {
            Type = "string",
            Name = "ProductName",
            Description = "Product name to search for (partial match, case-insensitive)"
        } }
};