-- Decompiled with Potassium's decompiler.

return {
    Name = "givewateringcan",
    Description = "Gives a watering can to a player",
    Group = "DefaultAdmin",
    Aliases = { "givewateringcan", "givecan" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the watering can to"
        }, {
            Type = "wateringCanName",
            Name = "WateringCanName",
            Description = "The name of the watering can"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of watering cans to give (default 1)",
            Optional = true
        } }
};