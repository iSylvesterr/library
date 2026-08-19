-- Decompiled with Potassium's decompiler.

return {
    Name = "powerspray",
    Description = "Toggle an overpowered spray bottle that blasts dirt off instantly (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player to toggle powerful spray on",
            Optional = true
        }, {
            Type = "boolean",
            Name = "Enabled",
            Description = "Force powerful spray on/off (omit to toggle)",
            Optional = true
        } }
};