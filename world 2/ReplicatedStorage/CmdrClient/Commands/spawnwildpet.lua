-- Decompiled with Potassium's decompiler.

return {
    Name = "spawnwildpet",
    Description = "Spawn a wild pet of the given species (optionally with a size / type) at a random valid spot inside workspace.Map.PetSpawn (or near you with `here`). For testing the SpawnPetService taming flow without waiting for the natural spawn loop.",
    Group = "DefaultAdmin",
    Aliases = { "spawnwildpet", "spawnpet" },
    Args = { {
            Type = "pet",
            Name = "PetName",
            Description = "Pet species key from PetData (e.g. Raccoon)"
        }, {
            Type = "positiveInteger",
            Name = "Count",
            Description = "How many to spawn (default 1)",
            Optional = true
        }, {
            Type = "petSize",
            Name = "Size",
            Description = "Pet size: \"Big\" (2x) or \"Huge\"/Mega (4x). Blank for normal.",
            Optional = true
        }, {
            Type = "petType",
            Name = "Type",
            Description = "Pet type: \"Rainbow\". Blank for none.",
            Optional = true
        } }
};