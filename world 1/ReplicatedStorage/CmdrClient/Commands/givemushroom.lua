-- Decompiled with Potassium's decompiler.

return {
    Name = "givemushroom",
    Description = "Gives mushroom(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givemushroom" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give mushrooms to"
        }, {
            Type = "mushroomName",
            Name = "MushroomName",
            Description = "The name of the mushroom"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of mushrooms to give (default 1)",
            Optional = true
        } }
};