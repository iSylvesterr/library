-- Decompiled with Potassium's decompiler.

return {
    Name = "removecosmetic",
    Description = "Removes a cosmetic/prop from a player",
    Group = "DefaultAdmin",
    Aliases = { "removecosmetic", "removeprop" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to remove the cosmetic from"
        }, {
            Type = "cosmeticName",
            Name = "CosmeticName",
            Description = "The name of the cosmetic"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of cosmetics to remove (default 1)",
            Optional = true
        } }
};