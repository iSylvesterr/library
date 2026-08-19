-- Decompiled with Potassium's decompiler.

return {
    Name = "guildgiftrequest",
    Description = "Opens a guild-feed gifting request as a player (same server-side validation as the client path).",
    Group = "DefaultAdmin",
    Aliases = { "gfrequest" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Who opens the request",
            Default = "me"
        }, {
            Type = "string",
            Name = "Category",
            Description = "Seeds | Crates | SeedPacks | Eggs",
            Optional = true
        }, {
            Type = "string",
            Name = "ItemKey",
            Description = "The item to request (e.g. Carrot)",
            Optional = true
        }, {
            Type = "integer",
            Name = "Goal",
            Description = "How many to ask for (default 10)",
            Optional = true
        } }
};