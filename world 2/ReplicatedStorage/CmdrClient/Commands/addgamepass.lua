-- Decompiled with Potassium's decompiler.

return {
    Name = "addgamepass",
    Description = "Grants a gamepass to a player using the real purchase pipeline",
    Group = "DefaultAdmin",
    Aliases = { "addgamepass", "givegamepass" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to grant the gamepass to"
        }, {
            Type = "gamepassName",
            Name = "Gamepass",
            Description = "The gamepass display name"
        } }
};