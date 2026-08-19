-- Decompiled with Potassium's decompiler.

return {
    Name = "partyevent",
    Description = "Start or stop the Admin Party on THIS server. Omit the argument to toggle.",
    Group = "DefaultAdmin",
    Aliases = { "partyevent", "adminparty" },
    Args = { {
            Type = "boolean",
            Name = "Enabled",
            Description = "true = start the party, false = end it. Omit to toggle the current state.",
            Optional = true
        }, {
            Type = "number",
            Name = "Duration",
            Description = "Optional length in seconds, defaults to 45 minutes. The party ends itself when it lands.",
            Optional = true
        } }
};