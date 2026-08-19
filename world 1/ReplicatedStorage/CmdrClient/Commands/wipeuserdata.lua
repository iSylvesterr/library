-- Decompiled with Potassium's decompiler.

return {
    Name = "wipeuserdata",
    Description = "Wipes a user\'s saved data by userId. Default resets the profile to a fresh-player template (Guild preserved); pass HardDelete=true to delete the DataStore key entirely. Works on offline users and evicts/steals a live session if the target is online.",
    Group = "DefaultAdmin",
    Aliases = { "wipeuser" },
    Args = { {
            Type = "playerId",
            Name = "User",
            Description = "Username, or #<userId>, of the player whose data to wipe."
        }, {
            Type = "boolean",
            Name = "HardDelete",
            Description = "If true, hard-delete the DataStore key (RemoveAsync) instead of resetting to template.",
            Optional = true
        } }
};