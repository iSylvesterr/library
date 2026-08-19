-- Decompiled with Potassium's decompiler.

return {
    Name = "forcespawnpet",
    Description = "Forces wild pet(s) to spawn in the map using the natural spawning mechanics (weighted-random species at a random valid PetSpawn spot). Bypasses the population cap. Optionally pin a specific pet (with size/type, like givepet) instead of the random roll.",
    Group = "DefaultAdmin",
    Aliases = { "forcespawnpet" },
    Args = { {
            Type = "positiveInteger",
            Name = "Count",
            Description = "How many to spawn (default 1)",
            Optional = true
        }, {
            Type = "pet",
            Name = "PetName",
            Description = "Pet species to spawn. Omit for a random natural spawn.",
            Optional = true
        }, {
            Type = "string",
            Name = "Size",
            Description = "Pet size: \"Big\" (2x), \"Huge\" (4x), or blank/none for normal. Only used with PetName.",
            Optional = true
        }, {
            Type = "string",
            Name = "Type",
            Description = "Pet type: \"Rainbow\", or blank/none for no type. Only used with PetName.",
            Optional = true
        } }
};