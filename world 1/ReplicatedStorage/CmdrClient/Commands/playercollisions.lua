-- Decompiled with Potassium's decompiler.

return {
    Name = "playercollisions",
    Description = "Force player-to-player collisions on/off for this server (testing). Run with no argument to clear the override (back to the A/B test).",
    Group = "DefaultAdmin",
    Aliases = { "playercollisions", "collisions" },
    Args = { {
            Type = "boolean",
            Name = "Enabled",
            Description = "true = players collide, false = players pass through each other. Omit to clear the override.",
            Optional = true
        } }
};