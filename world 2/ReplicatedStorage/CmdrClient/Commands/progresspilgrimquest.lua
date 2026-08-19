-- Decompiled with Potassium's decompiler.

return {
    Name = "progresspilgrimquest",
    Description = "Force-complete the player\'s current Pilgrim quest, advancing the daily chain (grants the reward if it was the final stage). FallHarvest only.",
    Group = "DefaultAdmin",
    Aliases = { "progresspilgrimquest", "skippilgrimquest" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose current Pilgrim quest to skip"
        } }
};