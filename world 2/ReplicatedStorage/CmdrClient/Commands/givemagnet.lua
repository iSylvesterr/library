-- Decompiled with Potassium's decompiler.

return {
    Name = "giveplayermagnet",
    Description = "Gives a magnet (equippable gear -- Player Magnet or Fruit Magnet) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveplayermagnet", "givemagnet" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the magnet to"
        }, {
            Type = "magnetName",
            Name = "MagnetName",
            Description = "Which magnet to give (Player Magnet or Fruit Magnet; default Player Magnet)",
            Optional = true
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "Ignored -- the Player Magnet is owned once (kept for compatibility)",
            Optional = true
        } }
};