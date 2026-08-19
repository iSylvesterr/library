-- Decompiled with Potassium's decompiler.

return {
    Name = "qamailstreakperiod",
    Description = "QA: override the mail-streak \'day\' length server-wide so increment / break / at-risk can be tested in minutes instead of days. Pass seconds (e.g. 180 = 3 minutes); 0 or negative resets to the real 1-day period. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = { "qamailstreakperiod", "mailstreakperiod" },
    Args = { {
            Type = "integer",
            Name = "Seconds",
            Description = "New streak-day length in seconds (e.g. 180 = 3 minutes). 0 or negative resets to 86400 (1 real day)."
        } }
};