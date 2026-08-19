-- Decompiled with Potassium's decompiler.

return {
    Name = "beanstalkshake",
    Description = "Force Jandel\'s Beanstalk to shake right now, for everyone currently inside it.",
    Group = "DefaultAdmin",
    Aliases = { "beanstalkshake", "shakebeanstalk" },
    Args = { {
            Type = "number",
            Name = "Duration",
            Description = "Optional length in seconds. Defaults to the configured shake length.",
            Optional = true
        } }
};