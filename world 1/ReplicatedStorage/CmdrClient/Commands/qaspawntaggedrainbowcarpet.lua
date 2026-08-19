-- Decompiled with Potassium's decompiler.

return {
    Name = "qaspawntaggedrainbowcarpet",
    Description = "Spawns a tagged RainbowCarpet in the workspace so a joining player reproduces the carpet-controller load behavior without a second player actively flying (dev only)",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Character the test carpet attaches its sway to",
            Default = "me"
        }, {
            Type = "number",
            Name = "Seconds",
            Description = "How long the test carpet stays before auto-removing (default 180)",
            Optional = true
        } }
};