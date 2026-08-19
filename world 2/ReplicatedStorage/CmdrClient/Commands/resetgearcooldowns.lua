-- Decompiled with Potassium's decompiler.

return {
    Name = "resetgearcooldowns",
    Description = "Clears every gear re-use cooldown for a player (Wind Staff, Bull Horn, magnets, Flashbang, Grappling Hook, ...) so the gear can be used again right away.",
    Group = "DefaultAdmin",
    Aliases = { "resetcooldowns", "rgc" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "Whose gear cooldowns to reset",
            Default = "me"
        } }
};