-- Decompiled with Potassium's decompiler.

return {
    Name = "growall",
    Description = "Grows a player\'s garden",
    Group = "DefaultAdmin",
    Aliases = { "growall" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to grow all"
        }, {
            Type = "timeSpan",
            Name = "Time",
            Description = "How much growth time to skip: 60s, 10m, 2h, 5d, 3w, 3mo, 1y, or 1d12h (default 1d)",
            Optional = true
        } }
};