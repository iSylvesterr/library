-- Decompiled with Potassium's decompiler.

return {
    Name = "auctioneerstock",
    Description = "DEV/QA: decrease a live Auctioneer lot\'s stock (authoritative, global on the next tick). Use it to test sold-out display without buying the lot down.",
    Group = "DefaultAdmin",
    Aliases = { "auctioneerstock" },
    Args = { {
            Type = "string",
            Name = "Lot",
            Description = "Which lot: a 1-based board index (1/2/3) or part of the item name (e.g. \"venom\", \"watering\")."
        }, {
            Type = "integer",
            Name = "Amount",
            Description = "How much to decrease the stock by (default 1; pass a number >= current stock to sell it out).",
            Optional = true
        } }
};