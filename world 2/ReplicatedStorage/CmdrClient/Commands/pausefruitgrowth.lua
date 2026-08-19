-- Decompiled with Potassium's decompiler.

return {
    Name = "pausefruitgrowth",
    Description = "Pause/resume fruit growth on this server (testing). While paused, existing fruit stop growing and no new fruit spawn. Run with no argument to pause.",
    Group = "DefaultAdmin",
    Aliases = { "pausefruitgrowth", "freezefruit", "pausefruit" },
    Args = { {
            Type = "boolean",
            Name = "Enabled",
            Description = "true = pause fruit growth, false = resume. Omit to pause.",
            Optional = true
        } }
};