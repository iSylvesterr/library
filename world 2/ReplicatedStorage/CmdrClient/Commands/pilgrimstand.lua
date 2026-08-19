-- Decompiled with Potassium's decompiler.

return {
    Name = "pilgrimstand",
    Description = "Force the wandering Pilgrim NPC on or off in-session for QA, overriding the Game.Pilgrim.Enabled flag / world gate. \'off\' hides him far below the map; \'on\' drops him back onto the plaza. Use \'clear\' to revert to the flag-driven default.",
    Group = "DefaultAdmin",
    Aliases = { "pilgrimstand", "pilgrimstandoverride" },
    Args = { {
            Type = "string",
            Name = "Mode",
            Description = "on | off | clear"
        } }
};