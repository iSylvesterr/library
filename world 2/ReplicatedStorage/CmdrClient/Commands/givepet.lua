-- Decompiled with Potassium's decompiler.

return {
    Name = "givepet",
    Description = "Adds a pet to a player\'s saved Pets data store",
    Group = "DefaultAdmin",
    Aliases = { "givepet" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the pet to"
        }, {
            Type = "pet",
            Name = "Name",
            Description = "Pet name / species (e.g. \"Dog\")"
        }, {
            Type = "string",
            Name = "Mutation",
            Description = "Pet mutation, or \"none\" / blank for none",
            Optional = true
        }, {
            Type = "boolean",
            Name = "Equipped",
            Description = "Whether the pet is equipped on grant (default false)",
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
        } }
};