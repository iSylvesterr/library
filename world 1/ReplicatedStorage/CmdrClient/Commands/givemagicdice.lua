-- Decompiled with Potassium's decompiler.

return {
    Name = "givemagicdice",
    Description = "Gives a Magic Dice to a player",
    Group = "DefaultAdmin",
    Aliases = { "givemagicdice", "givedice" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the Magic Dice to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of Magic Dice to give (default 1)",
            Optional = true
        } }
};