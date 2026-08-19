-- Decompiled with Potassium's decompiler.

return {
    Name = "kill",
    Description = "Kills a player or set of players.",
    Group = "DefaultAdmin",
    Aliases = { "slay" },
    Args = { {
            Type = "players",
            Name = "victims",
            Description = "The players to kill."
        } }
};