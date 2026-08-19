-- Decompiled with Potassium's decompiler.

return {
    Name = "globalnotification",
    Description = "Send a notification to all players across all servers",
    Group = "Admin",
    Aliases = { "gn" },
    Args = { {
            Type = "string",
            Name = "Message",
            Description = "The notification message"
        }, {
            Type = "notificationColor",
            Name = "Color",
            Description = "The notification color"
        } }
};