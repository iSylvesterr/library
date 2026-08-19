-- Decompiled with Potassium's decompiler.

return {
    Name = "fillbotgarden",
    Description = "Clears the garden and plants a bot-style uniform ~1-stud grid of mature cheap plants to drive the BotScore Grid component (dev only)",
    Group = "DefaultAdmin",
    Aliases = { "fillbot", "fbg" },
    Args = { {
            Type = "positiveInteger",
            Name = "Count",
            Description = "How many plants to place (default 400)",
            Optional = true
        }, {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose garden to fill",
            Default = "me"
        } }
};