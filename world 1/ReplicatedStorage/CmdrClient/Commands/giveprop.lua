-- Decompiled with Potassium's decompiler.

return {
    Name = "givecosmetic",
    Description = "Gives a cosmetic/prop to a player",
    Group = "DefaultAdmin",
    Aliases = { "givecosmetic", "giveprop" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the cosmetic to"
        }, {
            Type = "cosmeticName",
            Name = "CosmeticName",
            Description = "The name of the cosmetic"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of cosmetics to give (default 1)",
            Optional = true
        } }
};