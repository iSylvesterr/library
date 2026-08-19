-- Decompiled with Potassium's decompiler.

return {
    Name = "givepettool",
    Description = "Gives a pet to a player (one Tool per pet, via DataService:AddPet)",
    Group = "DefaultAdmin",
    Aliases = { "givepettool" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the pet tool to"
        }, {
            Type = "pet",
            Name = "PetName",
            Description = "The name of the pet (must match PetData.<Name> and Assets.<Name>)"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "How many of the pet to give (default 1)",
            Optional = true
        } }
};