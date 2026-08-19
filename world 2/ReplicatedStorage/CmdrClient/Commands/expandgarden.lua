-- Decompiled with Potassium's decompiler.

return {
    Name = "expandgarden",
    Description = "Sets a player\'s garden expansion level (defaults to max if no level given)",
    Group = "DefaultAdmin",
    Aliases = { "expandgarden", "setgardensize", "eg" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to expand the garden for",
            Default = "me"
        }, {
            Type = "positiveInteger",
            Name = "Level",
            Description = "Target expansion level (1..max). Omit for max.",
            Optional = true
        } }
};