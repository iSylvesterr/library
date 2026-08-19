-- Decompiled with Potassium's decompiler.

return {
    Name = "qaauctionrare",
    Description = "QA: announce a live Auctioneer lot as RARE (toast + restock ding to everyone on this server), without waiting for a genuinely rare lot to roll. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "Lot",
            Description = "Which lot: a 1-based board index (1/2/3) or part of the item name (e.g. \"hypno\", \"raccoon\"). Defaults to the first lot on the board. Pass \"clear\" to drop every forced mark.",
            Default = "1"
        } }
};