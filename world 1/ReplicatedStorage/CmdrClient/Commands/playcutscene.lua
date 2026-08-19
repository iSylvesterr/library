-- Decompiled with Potassium's decompiler.

return {
    Name = "playcutscene",
    Description = "Plays a cutscene",
    Group = "DefaultAdmin",
    Aliases = { "playcutscene" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to play for"
        }, {
            Type = "cutscene",
            Name = "Cutscene",
            Description = "The Cutscene"
        } }
};