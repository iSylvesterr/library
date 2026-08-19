-- Decompiled with Potassium's decompiler.

return {
    Name = "mailboxstats",
    Description = "Print mailbox state for online players (or a specific player) plus this server\'s flusher / cache / flag state. Reads MemoryStore MailIndex + DataStore inbox shards when a player is targeted.",
    Group = "DefaultAdmin",
    Aliases = { "mailboxstats", "mailstats", "mbstats" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Optional player. With one given, dumps profile + MailIndex + per-shard DataStore counts. Without, prints global server state and a summary line per online player.",
            Optional = true
        } }
};