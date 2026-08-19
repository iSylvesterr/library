-- Decompiled with Potassium's decompiler.

return {
    Name = "respawn",
    Description = "Kills a player and respawns them at their plot -- exactly what Roblox\'s reset button does. Defaults to you.",
    Group = "DefaultAdmin",
    Aliases = { "reset", "kill", "slay" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "Who to respawn",
            Default = "me"
        } }
};