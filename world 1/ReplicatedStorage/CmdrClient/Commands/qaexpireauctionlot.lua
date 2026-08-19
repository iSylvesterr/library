-- Decompiled with Potassium's decompiler.

return {
    Name = "qaexpireauctionlot",
    Description = "QA: force a live Auctioneer lot\'s timer to 0 so it renders EXPIRED with stock remaining (to test the SOLD OUT vs EXPIRED display). Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "Lot",
            Description = "Which lot: a 1-based board index (1/2/3) or part of the item name (e.g. \"fence\", \"venom\")."
        } }
};