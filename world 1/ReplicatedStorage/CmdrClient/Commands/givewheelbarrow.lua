-- Decompiled with Potassium's decompiler.

return {
    Name = "givewheelbarrow",
    Description = "Gives a wheelbarrow to a player",
    Group = "DefaultAdmin",
    Aliases = { "givewheelbarrow", "givewb" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the wheelbarrow to"
        }, {
            Type = "wheelbarrowName",
            Name = "WheelbarrowName",
            Description = "The name of the wheelbarrow to give"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number to give (default 1)",
            Optional = true
        } }
};