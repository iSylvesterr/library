-- Decompiled with Potassium's decompiler.

return {
    Name = "qasessionstats",
    Description = "QA: print the Shared.* snapshot this player\'s analytics session is reporting -- the world, wallet and counts that ride every session row -- beside the live values for the world you are standing in, and a verdict. The WORLD must agree; the numbers are expected to drift, since the snapshot rebuilds only at join and at leave. Read-only.",
    Group = "DefaultAdmin",
    Aliases = { "sessionstats" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose session snapshot to print.",
            Default = "me"
        } }
};