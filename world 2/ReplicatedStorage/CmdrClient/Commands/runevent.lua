-- Decompiled with Potassium's decompiler.

return {
    Name = "runevent",
    Description = "Start a registered event / minigame on THIS server by name (e.g. JandelsBeanstalk).",
    Group = "DefaultAdmin",
    Aliases = { "runevent" },
    Args = { {
            Type = "event",
            Name = "EventName",
            Description = "The registered event to start."
        }, {
            Type = "number",
            Name = "Duration",
            Description = "Optional duration in seconds (event-specific).",
            Optional = true
        } }
};