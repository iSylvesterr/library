-- Decompiled with Potassium's decompiler.

return {
    Name = "guildownerban",
    Description = "Run the banned-owner succession pass on a guild now: if its owner is permanently banned, hand ownership to a random Elder (or a random Member if there are no Elders). Bypasses the normal per-guild throttle.",
    Group = "DefaultAdmin",
    Aliases = { "guildownerban", "guildsuccession" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Player whose guild to check (defaults to you).",
            Optional = true
        }, {
            Type = "boolean",
            Name = "SimulateBanned",
            Description = "Pretend the owner is permanently banned so the transfer runs without actually banning anyone (default false). Everything else — election, the guild-row write, the rank fanouts — is real.",
            Optional = true
        }, {
            Type = "string",
            Name = "GuildId",
            Description = "Guild id to target instead of the player\'s own guild.",
            Optional = true
        } }
};