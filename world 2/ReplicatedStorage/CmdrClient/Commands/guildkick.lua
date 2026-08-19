-- Decompiled with Potassium's decompiler.

return {
    Name = "guildkick",
    Description = "Force-eject a player from their guild (admin override).",
    Group = "DefaultAdmin",
    Aliases = { "guildkick" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Target player to remove."
        } }
};