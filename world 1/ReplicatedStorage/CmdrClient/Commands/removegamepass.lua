-- Decompiled with Potassium's decompiler.

return {
    Name = "removegamepass",
    Description = "Removes a gamepass from a player and kicks them so they relog",
    Group = "DefaultAdmin",
    Aliases = { "removegamepass" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to remove the gamepass from"
        }, {
            Type = "gamepassName",
            Name = "Gamepass",
            Description = "The gamepass display name"
        } }
};