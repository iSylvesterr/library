-- Decompiled with Potassium's decompiler.

return {
    Name = "qamailstreakclear",
    Description = "QA: clear a player\'s mail streak(s) -- one partner userId, or all of them when omitted. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = { "qamailstreakclear", "mailstreakclear" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose streaks to clear.",
            Default = "me"
        }, {
            Type = "integer",
            Name = "PartnerUserId",
            Description = "Optional. Clear only the streak with this UserId; omit to clear ALL of the player\'s streaks.",
            Optional = true
        } }
};