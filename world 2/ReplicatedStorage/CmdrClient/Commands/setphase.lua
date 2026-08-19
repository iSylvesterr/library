-- Decompiled with Potassium's decompiler.

return {
    Name = "setphase",
    Description = "Sets the server phase",
    Group = "DefaultAdmin",
    Aliases = { "setphase" },
    Args = { {
            Type = "phase",
            Name = "Phase",
            Description = "The Phase"
        }, {
            Type = "number",
            Name = "Duration",
            Description = "Override the phase\'s duration in seconds (default: the phase\'s normal duration)",
            Optional = true
        } }
};