-- Decompiled with Potassium's decompiler.

return {
    Name = "mailrandom",
    Description = "Send a fabricated mailbox gift from a randomly selected sender to the target player. Useful for visually validating mailbox UI without setting up a real Send/Claim flow. Bypasses sender-inventory debit and SEND_COOLDOWN.",
    Group = "DefaultAdmin",
    Aliases = { "mailrandom", "randmail" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Target player to receive the random mail."
        } }
};