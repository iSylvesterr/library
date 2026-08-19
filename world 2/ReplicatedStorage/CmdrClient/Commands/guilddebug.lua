-- Decompiled with Potassium's decompiler.

return {
    Name = "guilddebug",
    Description = "Dump full state of a guild across every storage layer (DataStore, OrderedDataStore indices, reservations, in-memory caches, Auction manifest, online member presence). Pass either a player (resolves to their guild) or a guild id directly. Output goes to the server console pretty-printed; a short summary is returned here.",
    Group = "DefaultAdmin",
    Aliases = { "guilddebug", "gdebug" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Player whose guild to inspect (resolves their GuildId).",
            Optional = true
        }, {
            Type = "string",
            Name = "GuildId",
            Description = "Guild id to inspect (overrides Player if both are given).",
            Optional = true
        } }
};