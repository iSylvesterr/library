-- Decompiled with Potassium's decompiler.

return {
    Name = "guildinspect",
    Description = "Inspect a guild via a player or a guild id.",
    Group = "DefaultAdmin",
    Aliases = { "guildinspect", "ginspect" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Player whose guild to inspect.",
            Optional = true
        }, {
            Type = "string",
            Name = "GuildId",
            Description = "Guild id (overrides Player).",
            Optional = true
        } }
};