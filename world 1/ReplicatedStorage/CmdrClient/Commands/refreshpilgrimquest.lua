-- Decompiled with Potassium's decompiler.

return {
    Name = "refreshpilgrimquest",
    Description = "Restart the player\'s Pilgrim daily quests: wipes progress, step, and the reward claim so the day can be replayed. Quest contents are deterministic per day, so the same quests return with fresh progress. FallHarvest only.",
    Group = "DefaultAdmin",
    Aliases = { "refreshpilgrimquest", "resetpilgrimquest" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose Pilgrim day to restart"
        } }
};