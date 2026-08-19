-- Decompiled with Potassium's decompiler.

return {
    Name = "guildjoin",
    Description = "Force a player to join a guild (admin override; bypasses invite checks).",
    Group = "DefaultAdmin",
    Aliases = { "guildjoin" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Target player."
        }, {
            Type = "string",
            Name = "GuildId",
            Description = "Guild id."
        } }
};