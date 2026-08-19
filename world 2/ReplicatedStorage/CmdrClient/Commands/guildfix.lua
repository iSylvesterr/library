-- Decompiled with Potassium's decompiler.

return {
    Name = "guildfix",
    Description = "Repairs a player\'s guild membership when their profile lost its guild link (the on-join reconciler bug). Re-links the profile to the guild and restores attributes + beanstalk. Pass a guild id, tag, or name; if omitted, auto-detects from the player\'s surviving link or guilds loaded on this server.",
    Group = "DefaultAdmin",
    Aliases = { "guildfix", "fixguild", "guildrepair" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "Player(s) to repair (use \'me\' for yourself)."
        }, {
            Type = "string",
            Name = "Guild",
            Description = "Guild id, tag, or name. Optional if the guild is cached on this server.",
            Optional = true
        } }
};