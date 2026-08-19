-- Decompiled with Potassium's decompiler.

return {
    Name = "globalnotify",
    Description = "GLOBAL: send a notification toast to EVERY player on EVERY live server. Quote multi-word messages, e.g. globalnotify \"Rainbow Moon incoming!\".",
    Group = "DefaultAdmin",
    Aliases = { "globalnotify" },
    Args = { {
            Type = "string",
            Name = "Message",
            Description = "The message to toast to everyone (quote multi-word messages)."
        } }
};