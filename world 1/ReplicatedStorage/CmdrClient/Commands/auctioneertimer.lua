-- Decompiled with Potassium's decompiler.

return {
    Name = "auctioneertimer",
    Description = "GLOBAL: shift the Auctioneer restock countdown (time until the next refresh) by N seconds on every live server (positive = delay the refresh, negative = bring it sooner; a large enough negative refreshes now).",
    Group = "DefaultAdmin",
    Aliases = { "auctioneertimer" },
    Args = { {
            Type = "integer",
            Name = "Seconds",
            Description = "Seconds to shift the restock countdown; positive delays the next refresh, negative brings it sooner (e.g. -300 to refresh 5 minutes earlier)."
        } }
};