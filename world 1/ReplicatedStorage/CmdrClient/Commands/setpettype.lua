-- Decompiled with Potassium's decompiler.

return {
    Name = "setpettype",
    Description = "Sets (or clears) the PetType on a player\'s equipped pets of a given species",
    Group = "DefaultAdmin",
    Aliases = { "setpettype", "rainbowpet" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose pets to retype"
        }, {
            Type = "string",
            Name = "Species",
            Description = "Pet species to retype (e.g. \"Bunny\"). Affects that player\'s equipped pets of this species."
        }, {
            Type = "string",
            Name = "Type",
            Description = "Pet type to set: \"Rainbow\", or blank/\"none\" to clear",
            Optional = true
        } }
};