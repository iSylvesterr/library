-- Decompiled with Potassium's decompiler.

return {
    Name = "givemaxpet",
    Description = "Increases the player\'s MaxEquippedPets cap (one extra pet slot per call by default).",
    Group = "DefaultAdmin",
    Aliases = { "givemaxpet", "givepetslot" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to grant pet slots to"
        }, {
            Type = "positiveInteger",
            Name = "Slots",
            Description = "How many extra pet slots to grant (default 1)",
            Optional = true
        } }
};