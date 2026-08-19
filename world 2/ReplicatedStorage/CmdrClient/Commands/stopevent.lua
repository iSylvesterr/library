-- Decompiled with Potassium's decompiler.

return {
    Name = "stopevent",
    Description = "Stop a registered event / minigame on THIS server by name.",
    Group = "DefaultAdmin",
    Aliases = { "stopevent" },
    Args = { {
            Type = "event",
            Name = "EventName",
            Description = "The registered event to stop."
        } }
};