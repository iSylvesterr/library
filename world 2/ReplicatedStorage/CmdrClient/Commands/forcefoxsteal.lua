-- Decompiled with Potassium's decompiler.

return {
    Name = "forcefoxsteal",
    Description = "Forces equipped Foxes to immediately attempt a seed-steal run, skipping the random roll and per-pet cooldown. Normal steal rules still apply (night + an online player outside their garden/safe zone who holds a seed). Omit the player arg to force everyone\'s foxes.",
    Group = "DefaultAdmin",
    Aliases = { "forcefoxsteal" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose Foxes should steal (default: everyone).",
            Optional = true
        } }
};