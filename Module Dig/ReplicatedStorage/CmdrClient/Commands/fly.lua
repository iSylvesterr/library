-- Decompiled with Potassium's decompiler.

return {
    Name = "fly",
    Description = "Toggle fly mode for a player",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player to toggle fly on",
            Optional = true
        }, {
            Type = "boolean",
            Name = "Enabled",
            Description = "Force fly on/off (omit to toggle)",
            Optional = true
        } }
};