-- Decompiled with Potassium's decompiler.

return {
    Name = "competitionreload",
    Description = "Reload guild-competition config from disk on the backend (rescans COMPETITIONS_DIR + bumps competitionsVersion so servers refetch). Pass a competition id to ALSO force an early finalize of that competition (test-only: streams its bracket rewards into the mail outbox; idempotent via the rewarded marker).",
    Group = "DefaultAdmin",
    Aliases = { "competitionreload", "creload", "competitionfinalize" },
    Args = { {
            Type = "string",
            Name = "Competition",
            Description = "Optional competition id to force-finalize (test). Omit to only reload config.",
            Optional = true
        } }
};