-- Decompiled with Potassium's decompiler.

return {
    Name = "squirrelgrabmult",
    Description = "Multiplies the Squirrel grab-fruit chance for everyone (Squirrels only). Pass 1 to reset.",
    Group = "DefaultAdmin",
    Aliases = { "squirrelgrabmult" },
    Args = { {
            Type = "number",
            Name = "Multiplier",
            Description = "How much more often Squirrels grab a ripe fruit (default 50, use 1 to reset).",
            Optional = true
        } }
};