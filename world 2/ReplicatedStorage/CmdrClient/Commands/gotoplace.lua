-- Decompiled with Potassium's decompiler.

return {
    Name = "gotoplace",
    Description = "Teleports the executor (or specified players) to a public server of the given place (Primary, FirstSession, NewUser) in this environment.",
    Group = "DefaultAdmin",
    Aliases = { "gp" },
    Args = { {
            Type = "place",
            Name = "Place",
            Description = "Destination place type."
        }, {
            Type = "players",
            Name = "Players",
            Description = "Player(s) to teleport. Defaults to the executor.",
            Optional = true
        } }
};