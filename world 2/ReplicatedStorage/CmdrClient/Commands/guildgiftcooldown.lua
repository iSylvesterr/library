-- Decompiled with Potassium's decompiler.

return {
    Name = "guildgiftcooldown",
    Description = "Resets a player\'s 24h guild gifting-request cooldown (they can immediately open a new request).",
    Group = "DefaultAdmin",
    Aliases = { "gfcooldown" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose request cooldown to reset",
            Default = "me"
        } }
};