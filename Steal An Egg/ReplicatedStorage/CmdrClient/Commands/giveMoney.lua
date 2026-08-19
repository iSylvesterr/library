-- Decompiled with Potassium's decompiler.

return {
    Name = "giveMoney",
    Description = "Gives the player money.",
    Group = "Admin",
    Aliases = { "" },
    Args = { {
            Type = "players",
            Name = "Player",
            Description = "The players to give money to."
        }, {
            Type = "integer",
            Name = "Amount",
            Description = "The amount of money to give."
        } }
};