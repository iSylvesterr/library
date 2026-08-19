-- Decompiled with Potassium's decompiler.

return {
    Name = "fillgarden",
    Description = "Clears the garden and fills it with random mature plants, then triggers the offline cutscene",
    Group = "DefaultAdmin",
    Aliases = { "fg" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to fill",
            Default = "me"
        } }
};