-- Decompiled with Potassium's decompiler.

return {
    Name = "giveskillpoints",
    Description = "Gives skillpoints (currency) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveskillpoints", "givemoney" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give skillpoints to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The amount of skillpoints to give"
        } }
};