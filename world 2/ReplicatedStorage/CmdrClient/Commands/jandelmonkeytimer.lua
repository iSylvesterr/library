-- Decompiled with Potassium's decompiler.

return {
    Name = "jandelmonkeytimer",
    Description = "Retimes a player\'s equipped Jandel Monkeys so their weather summon comes due soon instead of on the full 15 minute interval. Also clears the server-wide summon cooldown, which would otherwise swallow the summon.",
    Group = "DefaultAdmin",
    Aliases = { "jmtimer" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "Whose Jandel Monkeys to retime",
            Default = "me"
        }, {
            Type = "timeSpan",
            Name = "Time",
            Description = "How long until they summon: 15s, 2m, 1h (omit to make them due right away)",
            Optional = true
        } }
};