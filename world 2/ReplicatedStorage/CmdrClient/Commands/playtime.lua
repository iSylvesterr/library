-- Decompiled with Potassium's decompiler.

return {
    Name = "playtime",
    Description = "Print a player\'s playtime: the account total, how much of it belongs to each world, and the current session. Defaults to you.",
    Group = "DefaultAdmin",
    Aliases = { "playtime", "worldplaytime" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Player whose playtime to inspect (defaults to you).",
            Optional = true
        } }
};