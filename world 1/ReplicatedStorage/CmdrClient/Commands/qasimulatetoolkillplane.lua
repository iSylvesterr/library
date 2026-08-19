-- Decompiled with Potassium's decompiler.

return {
    Name = "qasimulatetoolkillplane",
    Description = "Simulates the equipped tool\'s Handle (or the whole tool) falling through the map / kill plane, to test the tool-disappear self-heal (dev only)",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose currently-equipped tool to break",
            Default = "me"
        }, {
            Type = "string",
            Name = "What",
            Description = "\'handle\' (default) orphans just the Handle (husk case); \'tool\' orphans the whole tool",
            Optional = true
        } }
};