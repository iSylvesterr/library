-- Decompiled with Potassium's decompiler.

return {
    Name = "givespray",
    Description = "Unlock and equip any spray bottle for a player (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player to give the spray to"
        }, {
            Type = "sprayId",
            Name = "Spray",
            Description = "The spray bottle to give"
        } }
};