-- Decompiled with Potassium's decompiler.

return {
    Name = "ban",
    Description = "Ban a player by name or userId. Duration in seconds, -1 for permanent.",
    Group = "Admin",
    Args = { {
            Type = "string",
            Name = "Target",
            Description = "Player name or UserId"
        }, {
            Type = "number",
            Name = "Duration",
            Description = "Duration in seconds (-1 = permanent)"
        }, {
            Type = "string",
            Name = "Reason",
            Description = "The ban reason",
            Optional = true,
            Default = "Banned by an administrator."
        } }
};