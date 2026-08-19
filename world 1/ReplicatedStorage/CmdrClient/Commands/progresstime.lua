-- Decompiled with Potassium's decompiler.

return {
    Name = "progresstime",
    Description = "Advances plant lifecycle by the specified number of seconds for player(s)",
    Group = "DefaultAdmin",
    Aliases = { "progresstime" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to progress time for"
        }, {
            Type = "number",
            Name = "Seconds",
            Description = "Number of seconds to advance the plant lifecycle"
        } }
};