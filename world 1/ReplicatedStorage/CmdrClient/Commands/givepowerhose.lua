-- Decompiled with Potassium's decompiler.

return {
    Name = "givepowerhose",
    Description = "Gives PowerHose(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givepowerhose" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give PowerHoses to"
        }, {
            Type = "string",
            Name = "PowerHoseName",
            Description = "The name of the PowerHose (e.g. PowerHose)"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of PowerHoses to give (default 1)",
            Optional = true
        } }
};