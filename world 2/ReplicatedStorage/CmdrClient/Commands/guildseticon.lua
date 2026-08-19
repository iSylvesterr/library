-- Decompiled with Potassium's decompiler.

return {
    Name = "guildseticon",
    Description = "Set a guild\'s icon image asset id (admin).",
    Group = "DefaultAdmin",
    Aliases = { "guildseticon", "gseticon" },
    Args = { {
            Type = "string",
            Name = "GuildId",
            Description = "Guild id."
        }, {
            Type = "integer",
            Name = "IconId",
            Description = "Image asset id to set as the guild icon (positive integer)."
        } }
};