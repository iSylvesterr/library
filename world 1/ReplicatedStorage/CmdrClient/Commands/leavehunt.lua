-- Decompiled with Potassium's decompiler.

return {
    Name = "leavehunt",
    Description = "Force player(s) out of the Pet Hunt queue, refunding their escrowed teleporter.",
    Group = "DefaultAdmin",
    Aliases = { "leavehunt", "pethuntleave" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to remove from the hunt queue"
        } }
};