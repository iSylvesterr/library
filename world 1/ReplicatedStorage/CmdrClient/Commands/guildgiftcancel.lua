-- Decompiled with Potassium's decompiler.

return {
    Name = "guildgiftcancel",
    Description = "Cancels a player\'s open guild-feed gifting request (donations stop everywhere).",
    Group = "DefaultAdmin",
    Aliases = { "gfcancel" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose open request to cancel",
            Default = "me"
        } }
};