-- Decompiled with Potassium's decompiler.

return {
    Name = "setmoon",
    Description = "Sets the moon type for the next night phase",
    Group = "DefaultAdmin",
    Aliases = { "setmoon" },
    Args = { {
            Type = "moonType",
            Name = "MoonType",
            Description = "The moon type (e.g. Moon, Bloodmoon, Goldmoon, Rainbow Moon)"
        } }
};