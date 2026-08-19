-- Decompiled with Potassium's decompiler.

return {
    Name = "removewateringcan",
    Description = "Removes a watering can from a player",
    Group = "DefaultAdmin",
    Aliases = { "removewateringcan", "removecan" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to remove the watering can from"
        }, {
            Type = "wateringCanName",
            Name = "WateringCanName",
            Description = "The name of the watering can"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of watering cans to remove (default 1)",
            Optional = true
        } }
};