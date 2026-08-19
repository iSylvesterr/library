-- Decompiled with Potassium's decompiler.

return {
    Name = "jandelmonkeyinfo",
    Description = "Dumps Jandel Monkey weather-ability state: each equipped monkey\'s size, summon interval and time until it fires, plus the server-wide summon cooldown.",
    Group = "DefaultAdmin",
    Aliases = { "jminfo" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose Jandel Monkeys to inspect (defaults to you)",
            Optional = true
        } }
};