-- Decompiled with Potassium's decompiler.

return {
    Name = "giveweatherstaff",
    Description = "Gives Weather Staff(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveweatherstaff", "givestaff" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the Weather Staff to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of Weather Staffs to give (default 1)",
            Optional = true
        } }
};