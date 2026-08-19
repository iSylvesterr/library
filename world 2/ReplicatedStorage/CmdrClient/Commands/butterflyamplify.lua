-- Decompiled with Potassium's decompiler.

return {
    Name = "butterflyamplify",
    Description = "Testing: scales the Butterfly global growth boost by a multiplier (1 = normal, 0 = off). A Butterfly must be equipped somewhere for the boost to be non-zero.",
    Group = "DefaultAdmin",
    Aliases = { "butterflyamplify", "amplifybutterfly" },
    Args = { {
            Type = "number",
            Name = "Multiplier",
            Description = "How much to amplify the Butterfly effect (e.g. 100). 1 = normal."
        } }
};