-- Decompiled with Potassium's decompiler.

return {
    Name = "giveraccoon",
    Description = "Gives raccoon(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveraccoon" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give raccoon to"
        }, {
            Type = "string",
            Name = "RaccoonName",
            Description = "The name of the Raccoon (e.g. Raccoon)"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of raccoons to give (default 1)",
            Optional = true
        } }
};