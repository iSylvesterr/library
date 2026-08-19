-- Decompiled with Potassium's decompiler.

return {
    Name = "givefreezeray",
    Description = "Gives FreezeRay(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "givefreezeray" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give FreezeRays to"
        }, {
            Type = "string",
            Name = "FreezeRayName",
            Description = "The name of the FreezeRay (e.g. FreezeRay)"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of FreezeRays to give (default 1)",
            Optional = true
        } }
};