-- Decompiled with Potassium's decompiler.

return {
    Name = "cornvariant",
    Description = "Spawns Corn variant 0 (original) and variant 1 (new) side by side for visual comparison, ignoring the wall-clock cutover (dev only)",
    Group = "DefaultAdmin",
    Aliases = { "cv" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Player to spawn the comparison in front of",
            Default = "me"
        }, {
            Type = "number",
            Name = "SizeMultiplier",
            Description = "Size multiplier applied to both corns (default 1)",
            Optional = true
        } }
};