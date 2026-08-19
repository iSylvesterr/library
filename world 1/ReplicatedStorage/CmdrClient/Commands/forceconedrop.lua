-- Decompiled with Potassium's decompiler.

return {
    Name = "forceconedrop",
    Description = "Forces a fully-grown Conifer Cone with a ripe cone to drop that cone and plant a Conifer Cone Sapling. Only skips the night gate and the odds roll -- every real precondition (ripe cone, per-generation cap, plot capacity, free soil) still applies, and when one blocks the drop it reports which one instead of planting anything.",
    Group = "DefaultAdmin",
    Aliases = { "forceconedrop", "dropcone", "forcesapling" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose garden to drop in (defaults to you)",
            Optional = true
        }, {
            Type = "integer",
            Name = "Count",
            Description = "How many saplings to drop, one ripe cone each (default 1). Stops at the first one that can\'t happen and tells you why.",
            Optional = true
        } }
};