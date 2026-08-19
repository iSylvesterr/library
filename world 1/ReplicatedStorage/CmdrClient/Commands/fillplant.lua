-- Decompiled with Potassium's decompiler.

return {
    Name = "fillplant",
    Description = "Clears the garden and fills it with X fully-grown copies of a single plant, using the same size distribution a normal player would roll (no sprinkler luck)",
    Group = "DefaultAdmin",
    Aliases = { "fp", "showcaseplant", "plantshowcase", "fillgardenwith", "fgw" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to fill the garden for"
        }, {
            Type = "seedName",
            Name = "SeedName",
            Description = "The seed type to plant"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "How many plants to plant (default 25)",
            Optional = true
        }, {
            Type = "number",
            Name = "Weight",
            Description = "Force every plant to this exact weight in kg (optional; random if omitted)",
            Optional = true
        }, {
            Type = "string",
            Name = "Mutation",
            Description = "Force a mutation: Gold, Rainbow, Electric (optional)",
            Optional = true
        } }
};