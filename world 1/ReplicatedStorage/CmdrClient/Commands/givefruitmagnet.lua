-- Decompiled with Potassium's decompiler.

return {
    Name = "givefruitmagnet",
    Description = "Gives the Fruit Magnet (equippable gear) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givefruitmagnet" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the Fruit Magnet to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "Ignored -- the Fruit Magnet is owned once (kept for compatibility)",
            Optional = true
        } }
};