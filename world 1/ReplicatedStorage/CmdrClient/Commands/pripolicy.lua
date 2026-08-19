-- Decompiled with Potassium's decompiler.

return {
    Name = "pripolicy",
    Description = "QA: simulate the paid-random-items policy restriction (hides shop Restock buttons + Starter Pack, blocks their purchase).",
    Group = "DefaultAdmin",
    Aliases = { "pripolicy" },
    Args = { {
            Type = "string",
            Name = "Mode",
            Description = "on = simulate restricted, off = clear override, status = show current state"
        }, {
            Type = "player",
            Name = "Player",
            Description = "Target player (defaults to you)",
            Optional = true
        } }
};