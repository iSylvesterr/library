-- Decompiled with Potassium's decompiler.

return {
    Name = "givesquirrel",
    Description = "Gives a Squirrel pet to a player",
    Group = "DefaultAdmin",
    Aliases = { "givesquirrel" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the Squirrel to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of Squirrels to give (default 1)",
            Optional = true
        }, {
            Type = "string",
            Name = "Size",
            Description = "Pet size: \"Big\" (2x), \"Huge\" (4x), or blank/none for normal",
            Optional = true
        }, {
            Type = "string",
            Name = "Type",
            Description = "Pet type: \"Rainbow\", or blank/none for no type",
            Optional = true
        }, {
            Type = "boolean",
            Name = "Equipped",
            Description = "Whether the Squirrel is equipped on grant (default true)",
            Optional = true
        } }
};