-- Decompiled with Potassium's decompiler.

return {
    Name = "givechest",
    Description = "Gives chest(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givechest" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give chests to"
        }, {
            Type = "chestName",
            Name = "ChestName",
            Description = "The name of the chest"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of chests to give (default 1)",
            Optional = true
        } }
};