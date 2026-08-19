-- Decompiled with Potassium's decompiler.

return {
    Name = "givelantern",
    Description = "QA-only: grants the removed Lantern gear (owned + equipped) so you can verify it is stripped on relog",
    Group = "DefaultAdmin",
    Aliases = { "givelantern" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the Lantern to"
        } }
};