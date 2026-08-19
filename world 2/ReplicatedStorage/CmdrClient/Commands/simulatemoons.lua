-- Decompiled with Potassium's decompiler.

return {
    Name = "simulatemoons",
    Description = "Simulates the natural moon roll for the next N nights starting after a Unix time (default: now). Read-only; does not touch the live cycle. Ignores admin/global overrides.",
    Group = "DefaultAdmin",
    Aliases = { "simulatemoons", "simmoons" },
    Args = { {
            Type = "number",
            Name = "After",
            Description = "Unix timestamp to start simulating after (default: current server time)",
            Optional = true
        }, {
            Type = "positiveInteger",
            Name = "Count",
            Description = "How many moons to simulate (default 20, max 200)",
            Optional = true
        } }
};