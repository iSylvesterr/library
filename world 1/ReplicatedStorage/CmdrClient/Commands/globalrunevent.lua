-- Decompiled with Potassium's decompiler.

return {
    Name = "globalrunevent",
    Description = "GLOBAL: start a registered event / minigame on EVERY live server at once (fanned out via MessagingService). The run is persisted, so servers that boot mid-event join it too, with whatever time is left. Stop it with globalstopevent, or let it end on its own.",
    Group = "DefaultAdmin",
    Aliases = { "globalrunevent", "grunevent" },
    Args = { {
            Type = "event",
            Name = "EventName",
            Description = "The registered event to start everywhere."
        }, {
            Type = "number",
            Name = "Duration",
            Description = "Optional duration in seconds (event-specific).",
            Optional = true
        } }
};