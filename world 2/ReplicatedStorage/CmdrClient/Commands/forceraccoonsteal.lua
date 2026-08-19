-- Decompiled with Potassium's decompiler.

return {
    Name = "forceraccoonsteal",
    Description = "Forces equipped Raccoons to immediately attempt a steal run, skipping the random roll and per-pet cooldown. Normal steal rules still apply (night + an eligible empty garden with ripe fruit). Omit the player arg to force everyone\'s raccoons.",
    Group = "DefaultAdmin",
    Aliases = { "forceraccoonsteal" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose Raccoons should steal (default: everyone).",
            Optional = true
        } }
};