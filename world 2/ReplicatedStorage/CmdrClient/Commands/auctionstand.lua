-- Decompiled with Potassium's decompiler.

return {
    Name = "auctionstand",
    Description = "Force the whole Auctioneer (booth + NPC prompt + HUD button) on or off in-session for QA, overriding the Game.Auctioneer.Enabled/OpenEnabled flags. Lets you watch the stand appear/disappear (and the ring re-space) at its new circle position without waiting on a live flag change. Use \'clear\' to revert to the flag-driven default.",
    Group = "DefaultAdmin",
    Aliases = { "auctionstand", "auctionstandoverride" },
    Args = { {
            Type = "string",
            Name = "Mode",
            Description = "on | off | clear"
        } }
};