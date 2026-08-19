-- Decompiled with Potassium's decompiler.

return {
    Name = "testrainbowmoonpets",
    Description = "Bumps the chance that wild pets spawning during a Rainbow Moon roll the Rainbow PetType. Defaults to 50%. Pass false to reset to the normal 2%.",
    Group = "DefaultAdmin",
    Aliases = { "testrainbowmoonpets" },
    Args = { {
            Type = "boolean",
            Name = "Enabled",
            Description = "true (default) bumps the odds to 50%; false resets to the default 2%.",
            Optional = true
        } }
};