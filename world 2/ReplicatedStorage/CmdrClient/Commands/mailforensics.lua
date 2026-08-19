-- Decompiled with Potassium's decompiler.

return {
    Name = "mailforensics",
    Description = "Print dupe-forensics state for a player: pet/fruit Src/SrcFrom/DupeFlagged stamps, OutboxPending ages vs the stale cutoff, DupeNotifiedGUIDs, and the outbox-retry flag values.",
    Group = "DefaultAdmin",
    Aliases = { "mailforensics", "mailfx" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose profile to inspect (default: you).",
            Default = "me"
        } }
};