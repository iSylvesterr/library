-- Decompiled with Potassium's decompiler.

return {
    Name = "forceweather",
    Description = "GLOBAL: force a weather on EVERY live server (and servers that boot during the window, via MemoryStore). Use for release-day bad-RNG insurance.",
    Group = "DefaultAdmin",
    Aliases = { "forceweather" },
    Args = { {
            Type = "weather",
            Name = "Weather",
            Description = "The weather to force everywhere."
        }, {
            Type = "number",
            Name = "Duration",
            Description = "How long the weather lasts in seconds (default: the weather\'s normal duration).",
            Optional = true
        } }
};