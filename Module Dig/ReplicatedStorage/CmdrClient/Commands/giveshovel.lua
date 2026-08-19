-- Decompiled with Potassium's decompiler.

return {
    Name = "giveshovel",
    Description = "Unlock and equip any shovel for a player (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player to give the shovel to"
        }, {
            Type = "shovelId",
            Name = "Shovel",
            Description = "The shovel to give"
        } }
};