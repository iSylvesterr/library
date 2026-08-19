-- Decompiled with Potassium's decompiler.

return {
    Name = "gotoworld",
    Description = "Teleports you (or listed players) to a world\'s place (Main, FallHarvest). Only worlds registered for this environment are reachable.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "World",
            Description = "World id: Main or FallHarvest."
        }, {
            Type = "players",
            Name = "Players",
            Description = "Players to teleport (defaults to you).",
            Optional = true
        } }
};