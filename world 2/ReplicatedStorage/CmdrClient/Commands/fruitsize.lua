-- Decompiled with Potassium's decompiler.

return {
    Name = "fruitsize",
    Description = "Spawns a fully-grown collectible fruit at a forced SizeMultiplier on the player\'s plant(s). For testing oversized-fruit behavior (e.g. the CanCollide-off threshold).",
    Group = "DefaultAdmin",
    Aliases = { "bigfruit", "forcefruit" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to spawn the fruit for"
        }, {
            Type = "number",
            Name = "SizeMultiplier",
            Description = "Fruit size multiplier (1 = normal). Use a big value like 50 to test oversized behavior"
        }, {
            Type = "seedName",
            Name = "SeedName",
            Description = "Only spawn on plants of this seed (optional; default: any plant with a free fruit slot)",
            Optional = true
        }, {
            Type = "positiveInteger",
            Name = "Count",
            Description = "How many fruits to spawn per player (default 1)",
            Optional = true
        } }
};