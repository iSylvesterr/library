-- Decompiled with Potassium's decompiler.

return {
    Name = "givefruit",
    Description = "Gives a harvested fruit to a player\'s inventory",
    Group = "DefaultAdmin",
    Aliases = { "givefruit", "givecrop" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the fruit to"
        }, {
            Type = "fruitName",
            Name = "FruitName",
            Description = "The name of the fruit"
        }, {
            Type = "fruitWeight",
            Name = "Weight",
            Description = "The weight of the fruit in grams (\'.\' = base weight)",
            Optional = true
        }, {
            Type = "mutationName",
            Name = "Mutation",
            Description = "The mutation to apply (\'.\' = None)",
            Optional = true
        }, {
            Type = "fruitSeed",
            Name = "Seed",
            Description = "RNG seed for fruit appearance (\'.\' = random)",
            Optional = true
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "How many of the fruit to give (default 1)",
            Optional = true,
            Default = 1
        } }
};