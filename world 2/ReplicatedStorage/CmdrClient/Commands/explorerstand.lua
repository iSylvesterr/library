-- Decompiled with Potassium's decompiler.

return {
    Name = "explorerstand",
    Description = "Force the whole explorer (booth + NPC prompt) on or off in-session for QA, overriding the Game.Traveler.Enabled flags. Lets you watch the stand appear/disappear (and the ring re-space) at its new circle position without waiting on a live flag change. Use \'clear\' to revert to the flag-driven default.",
    Group = "DefaultAdmin",
    Aliases = { "explorerstand", "explorerstandoverride" },
    Args = { {
            Type = "string",
            Name = "Mode",
            Description = "on | off | clear"
        } }
};