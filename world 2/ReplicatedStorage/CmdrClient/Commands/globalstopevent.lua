-- Decompiled with Potassium's decompiler.

return {
    Name = "globalstopevent",
    Description = "GLOBAL: stop a registered event / minigame on EVERY live server at once (fanned out via MessagingService), and drop its persisted run so servers booting later don\'t rejoin it.",
    Group = "DefaultAdmin",
    Aliases = { "globalstopevent", "gstopevent" },
    Args = { {
            Type = "event",
            Name = "EventName",
            Description = "The registered event to stop everywhere."
        } }
};