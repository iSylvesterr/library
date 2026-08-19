-- Decompiled with Potassium's decompiler.

return {
    Name = "huntinfo",
    Description = "Print a player\'s Pet Hunt escrow: whether they\'re queued, the hunt type/item, expiry countdown, target place, and GUID. Defaults to you.",
    Group = "DefaultAdmin",
    Aliases = { "huntinfo", "pethuntinfo" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Player whose hunt escrow to inspect (defaults to you).",
            Optional = true
        } }
};