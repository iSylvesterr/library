-- Decompiled with Potassium's decompiler.

return {
    Name = "globalStartEvent",
    Description = "Start an event in all servers",
    Group = "Moderator",
    Args = { {
            Type = "adminEventType",
            Name = "Event Name"
        }, {
            Type = "number",
            Name = "Duration"
        } }
};