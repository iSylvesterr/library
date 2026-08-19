-- Decompiled with Potassium's decompiler.

return {
    Name = "globalmessage",
    Description = "Broadcast a global announcement to all servers",
    Group = "Admin",
    Aliases = { "gm" },
    Args = { {
            Type = "string",
            Name = "Message",
            Description = "The announcement message"
        } }
};