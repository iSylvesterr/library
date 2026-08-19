-- Decompiled with Potassium's decompiler.

return {
    Name = "givepartypoints",
    Description = "Give Admin Party points to a player. Only works while a party is running on this server.",
    Group = "DefaultAdmin",
    Aliases = { "givepartypoints", "givepoints" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give party points to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The amount of party points to give"
        } }
};