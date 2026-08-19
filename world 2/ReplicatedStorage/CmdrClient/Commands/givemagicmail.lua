-- Decompiled with Potassium's decompiler.

return {
    Name = "givemagicmail",
    Description = "Gives Magic Mail item(s) to player(s) for testing (Rare, Legendary, Super, or all).",
    Group = "DefaultAdmin",
    Aliases = { "givemagicmail", "givemail" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give Magic Mail to"
        }, {
            Type = "string",
            Name = "Tier",
            Description = "Which tier: Rare, Legendary, Super, or all"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "How many of each to give (default 1)",
            Optional = true
        } }
};