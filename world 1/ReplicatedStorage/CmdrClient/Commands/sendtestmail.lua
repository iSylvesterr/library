-- Decompiled with Potassium's decompiler.

return {
    Name = "sendtestmail",
    Description = "Delivers player-sourced test mail (counts toward the 100 mailbox cap) to a player.",
    Group = "DefaultAdmin",
    Aliases = { "mailtest" },
    Args = { {
            Type = "player",
            Name = "Recipient",
            Description = "Who receives the test mail",
            Default = "me"
        }, {
            Type = "integer",
            Name = "Count",
            Description = "How many separate mails to send (default 1, max 150)",
            Optional = true
        } }
};