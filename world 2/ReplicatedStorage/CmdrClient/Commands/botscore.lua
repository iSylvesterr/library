-- Decompiled with Potassium's decompiler.

return {
    Name = "botscore",
    Description = "Show the BotScore (0-100 botness estimate) for player(s): score, component breakdown, override, matchmaking segment, plus the server segment and average",
    Group = "DefaultAdmin",
    Aliases = { "botscore", "bs" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to inspect",
            Default = "me"
        } }
};