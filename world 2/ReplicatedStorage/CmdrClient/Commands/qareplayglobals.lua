-- Decompiled with Potassium's decompiler.

return {
    Name = "qareplayglobals",
    Description = "QA: show what a server booting right now would pick up from the persisted global-event store -- the Admin Party and any running minigame, with the time left on each. Reports without touching anything by default; pass true to actually join them on THIS server, which is the boot path a fresh lobby takes. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "boolean",
            Name = "Apply",
            Description = "true = actually start what the store says is running, exactly as a booting server would. Omit to just look.",
            Optional = true
        } }
};