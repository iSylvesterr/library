-- Decompiled with Potassium's decompiler.

return {
    Name = "instantpurchases",
    Description = "Toggle instant dev-product / gamepass purchases for this server. Turning ON requires the place to allow it in Environment.config.",
    Group = "DefaultAdmin",
    Aliases = { "instantpurchases" },
    Args = { {
            Type = "boolean",
            Name = "Enabled",
            Description = "true to enable instant purchases, false to disable"
        } }
};