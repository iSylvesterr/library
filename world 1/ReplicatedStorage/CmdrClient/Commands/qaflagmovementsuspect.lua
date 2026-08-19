-- Decompiled with Potassium's decompiler.

return {
    Name = "qaflagmovementsuspect",
    Description = "Flags a player as movement-suspect (as if they just tripped the teleport/speed anti-cheat) on a loop for a duration, so the seed-claim / steal / harvest gates reject them on demand (dev only)",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Who to flag as movement-suspect",
            Default = "me"
        }, {
            Type = "number",
            Name = "Seconds",
            Description = "How long to keep them flagged so you can attempt loot actions (default 20, max 120)",
            Optional = true
        } }
};