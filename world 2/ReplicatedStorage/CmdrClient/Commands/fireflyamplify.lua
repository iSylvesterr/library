-- Decompiled with Potassium's decompiler.

return {
    Name = "fireflyamplify",
    Description = "Testing: scales the Firefly global plant-size boost by a multiplier (1 = normal, 0 = off). A Firefly must be equipped somewhere for the boost to be non-zero. Only affects crops planted AFTER running this.",
    Group = "DefaultAdmin",
    Aliases = { "fireflyamplify", "amplifyfirefly" },
    Args = { {
            Type = "number",
            Name = "Multiplier",
            Description = "How much to amplify the Firefly effect (e.g. 100). 1 = normal."
        } }
};