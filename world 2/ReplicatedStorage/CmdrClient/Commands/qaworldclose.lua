-- Decompiled with Potassium's decompiler.

return {
    Name = "qaworldclose",
    Description = "QA: fake the date the Fall Harvest world shuts down, so the closing countdown on Ethan\'s travel menu can be watched running out instead of sitting on \'59d 3h\'. Affects this server only, and only the countdown -- nothing actually closes the world. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "Seconds",
            Description = "Seconds until the world closes (e.g. 90). Use 0 to show the ended state right away, or `off` to put the real closing date back."
        } }
};