-- Decompiled with Potassium's decompiler.

return {
    Name = "globalLuckBoost",
    Description = "Gives a luck boost to all servers.",
    Group = "Admin",
    Aliases = { "" },
    Args = { {
            Type = "integer",
            Name = "Duration",
            Description = "The duration in seconds."
        }, {
            Type = "integer",
            Name = "Multiplier",
            Description = "The multiplier to apply (x2 - x32)",
            Optional = true
        } }
};