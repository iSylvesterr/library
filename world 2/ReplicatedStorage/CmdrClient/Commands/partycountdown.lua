-- Decompiled with Potassium's decompiler.

return {
    Name = "partycountdown",
    Description = "Arm the Admin Party countdown on EVERY live server. Every player sees a \'PARTY IN\' banner and the party starts on its own when it lands. The durable way to schedule ahead is the Game.AdminParty.StartAtUnix flag; this is the in-game override for a show or a test.",
    Group = "DefaultAdmin",
    Aliases = { "partycountdown", "partytimer" },
    Args = { {
            Type = "string",
            Name = "Seconds",
            Description = "Seconds until the party starts (e.g. 90). Use `off` to drop the countdown."
        } }
};