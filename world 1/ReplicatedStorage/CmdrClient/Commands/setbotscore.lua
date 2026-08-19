-- Decompiled with Potassium's decompiler.

return {
    Name = "setbotscore",
    Description = "Force-override a player\'s BotScore (persisted on the save, survives rejoin) so bot matchmaking can be tested. Pass \'off\' to clear back to the computed score. The \'bot\' segment only applies while the Game.BotScore.SegmentEnabled flag is on.",
    Group = "DefaultAdmin",
    Aliases = { "setbotscore" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to override"
        }, {
            Type = "string",
            Name = "Score",
            Description = "0-100 to force, or \'off\' to clear the override"
        } }
};