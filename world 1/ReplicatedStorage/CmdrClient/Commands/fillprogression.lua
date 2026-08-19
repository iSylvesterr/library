-- Decompiled with Potassium's decompiler.

return {
    Name = "fillprogression",
    Description = "Clears the garden and fills it with random mature plants steered to hit a target GardenProgression value, then triggers the offline cutscene (dev only)",
    Group = "DefaultAdmin",
    Aliases = { "fillprog", "fprog" },
    Args = { {
            Type = "positiveInteger",
            Name = "TargetProgression",
            Description = "The GardenProgression value to fill the garden toward"
        }, {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to fill",
            Default = "me"
        } }
};