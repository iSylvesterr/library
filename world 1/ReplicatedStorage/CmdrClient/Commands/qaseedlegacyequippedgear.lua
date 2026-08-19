-- Decompiled with Potassium's decompiler.

return {
    Name = "qaseedlegacyequippedgear",
    Description = "QA: seed a pre-update save shape (legacy EquippedGear string set, EquippedGears empty, migration flag cleared) on a player so rejoining exercises the one-time multi-equip migration. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose profile to seed the legacy equipped-gear state on.",
            Default = "me"
        }, {
            Type = "string",
            Name = "GearName",
            Description = "Equippable gear to mark as the legacy single-equipped gear (e.g. Sign, Megaphone, Wheelbarrow). Default Sign.",
            Optional = true
        } }
};