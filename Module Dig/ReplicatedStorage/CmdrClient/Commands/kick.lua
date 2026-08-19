-- Decompiled with Potassium's decompiler.

return {
    Name = "kick",
    Description = "Kick a player from the server",
    Group = "Admin",
    Aliases = { "boot" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to kick"
        }, {
            Type = "string",
            Name = "Reason",
            Description = "The kick reason",
            Optional = true,
            Default = "Kicked by an administrator."
        } }
};