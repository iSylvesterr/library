-- Decompiled with Potassium's decompiler.

return {
    Name = "guilddisband",
    Description = "Admin-forced disband of a guild by id. Releases reservations.",
    Group = "DefaultAdmin",
    Aliases = { "guilddisband", "gdisband" },
    Args = { {
            Type = "string",
            Name = "GuildId",
            Description = "Guild id."
        } }
};