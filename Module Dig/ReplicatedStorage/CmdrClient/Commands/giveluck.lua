-- Decompiled with Potassium's decompiler.

return {
    Name = "giveluck",
    Description = "Give a player a timed luck boost (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player to give the luck boost to"
        }, {
            Type = "number",
            Name = "Multiplier",
            Description = "The luck multiplier to add"
        }, {
            Type = "number",
            Name = "Duration",
            Description = "How long the boost lasts, in seconds"
        } }
};