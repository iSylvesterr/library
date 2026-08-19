-- Decompiled with Potassium's decompiler.

return {
    Name = "setrobuxspent",
    Description = "Force a player\'s KnownRobuxSpent snapshot (the BotScore spender-exemption input; persisted on the save) so the exemption can be tested without a real purchase. Note: real analytics spend max-merges back in on the next recompute, so lowering below real spend won\'t stick.",
    Group = "DefaultAdmin",
    Aliases = { "setrobuxspent" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to set"
        }, {
            Type = "integer",
            Name = "Amount",
            Description = "Lifetime Robux spend to record (0 to reset)"
        } }
};