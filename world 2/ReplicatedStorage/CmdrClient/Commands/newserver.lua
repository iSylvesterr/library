-- Decompiled with Potassium's decompiler.

return {
    Name = "newserver",
    Description = "Reserves a fresh private server in the current place and teleports the executor (or specified players) to it.",
    Group = "DefaultAdmin",
    Aliases = { "newserver", "newprivateserver", "ps" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "Player(s) to send to the new private server. Defaults to the executor.",
            Optional = true
        } }
};