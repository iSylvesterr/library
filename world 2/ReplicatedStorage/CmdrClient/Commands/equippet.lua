-- Decompiled with Potassium's decompiler.

return {
    Name = "equippet",
    Description = "Equips a pet on a player. Runtime-only -- not saved by auto-save, only persisted on leave.",
    Group = "DefaultAdmin",
    Aliases = { "equippet" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose pet to equip"
        }, {
            Type = "string",
            Name = "PetId",
            Description = "Full pet GUID, or any unique prefix of one (e.g. first 8 chars)"
        }, {
            Type = "boolean",
            Name = "UnequipOthers",
            Description = "Force-unequip all other pets first (default true)",
            Optional = true
        } }
};