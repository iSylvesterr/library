-- Decompiled with Potassium's decompiler.

return {
    Name = "givepetteleporter",
    Description = "Gives Pet Teleporter item(s) to player(s) for testing (Legendary, Mythic, Super, or all).",
    Group = "DefaultAdmin",
    Aliases = { "givepetteleporter", "givepetteleport" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give Pet Teleporters to"
        }, {
            Type = "string",
            Name = "Rarity",
            Description = "Which tier: Legendary, Mythic, Super, or all"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "How many of each to give (default 1)",
            Optional = true
        } }
};