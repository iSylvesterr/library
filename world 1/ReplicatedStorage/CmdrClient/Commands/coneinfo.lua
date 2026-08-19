-- Decompiled with Potassium's decompiler.

return {
    Name = "coneinfo",
    Description = "Dumps the Conifer Cone self-seeding state of a garden: every Conifer Cone / Sapling with its Generation, size and ripe cones, the per-generation sapling counts vs the cap, the live drop odds, and whether a drop could happen right now",
    Group = "DefaultAdmin",
    Aliases = { "coneinfo", "conifercone" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose garden to inspect (defaults to you)",
            Optional = true
        } }
};