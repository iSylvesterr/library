-- Decompiled with Potassium's decompiler.

return {
    Name = "givedetector",
    Description = "Unlock and equip any metal detector for a player (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player to give the detector to"
        }, {
            Type = "detectorId",
            Name = "Detector",
            Description = "The detector to give"
        } }
};