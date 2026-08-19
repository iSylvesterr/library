-- Decompiled with Potassium's decompiler.

return {
    Name = "qamailpaircap",
    Description = "QA: read or seed a player\'s per-recipient daily mail counters (Game.Mailbox.PerRecipientDailyLimit) so the cap can be hit without sending 5 gifts through the 10s cooldown. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = { "qamailpaircap", "mailpaircap" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose sending counters to read/seed.",
            Default = "me"
        }, {
            Type = "integer",
            Name = "RecipientUserId",
            Description = "Optional. The recipient\'s UserId. Omit to print every counter the player has today.",
            Optional = true
        }, {
            Type = "integer",
            Name = "Count",
            Description = "Optional. Set this pair\'s counter (e.g. 4 = one gift left before the cap, 0 = reset). Omit to only read.",
            Optional = true
        }, {
            Type = "string",
            Name = "Day",
            Description = "today = counters count as today\'s (default); yesterday = stamp them stale so the next gift proves the daily rollover.",
            Optional = true
        } }
};