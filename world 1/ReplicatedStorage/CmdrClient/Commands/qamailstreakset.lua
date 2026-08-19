-- Decompiled with Potassium's decompiler.

return {
    Name = "qamailstreakset",
    Description = "QA: seed a mail streak on a player\'s profile for a given partner userId so streak display / pinning / at-risk / increment / break can be tested without waiting real UTC days. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = { "qamailstreakset", "mailstreakset" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose profile to set the streak on (the account whose mailbox Send list will show it).",
            Default = "me"
        }, {
            Type = "integer",
            Name = "PartnerUserId",
            Description = "The other player\'s UserId. Can be offline / any id -- it gets injected at the top of the send list.",
            Default = 0
        }, {
            Type = "integer",
            Name = "Count",
            Description = "Streak number to set (e.g. 7).",
            Default = 0
        }, {
            Type = "string",
            Name = "State",
            Description = "today = kept today (shows 🔥); yesterday = at-risk eligible (shows ⏳ near reset); broken = lapsed/hidden until re-mailed. Default today.",
            Optional = true
        } }
};