-- Decompiled with Potassium's decompiler.

return {
    Name = "forcerestock",
    Description = "Forces a shop restock (or stocks one specific item) and pings the gag2-api icon endpoint.",
    Group = "DefaultAdmin",
    Aliases = { "forcerestock", "restock" },
    Args = { {
            Type = "string",
            Name = "Shop",
            Description = "Which shop: seed | gear | crate | all"
        }, {
            Type = "string",
            Name = "Item",
            Description = "Optional specific item name (e.g. Acorn). Omit to roll the full restock.",
            Optional = true
        }, {
            Type = "integer",
            Name = "Qty",
            Description = "Optional qty when stocking a specific item (defaults to 1). The item stays on the shelf until that shop\'s next restock, natural or forced.",
            Optional = true
        } }
};