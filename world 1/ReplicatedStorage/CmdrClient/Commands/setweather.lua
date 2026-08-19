-- Decompiled with Potassium's decompiler.

return {
    Name = "setweather",
    Description = "Sets the server weather",
    Group = "DefaultAdmin",
    Aliases = { "setweather" },
    Args = { {
            Type = "weather",
            Name = "Weather",
            Description = "The Weather"
        }, {
            Type = "number",
            Name = "Duration",
            Description = "How long the weather lasts in seconds (default: the weather\'s normal duration).",
            Optional = true
        } }
};