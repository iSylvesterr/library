-- Decompiled with Potassium's decompiler.

return {
    Name = "purgeblacklist",
    Description = "Sweeps all online players and deletes items whose GUIDs are in the Game.Security.DupeDetection.BlacklistedGUIDs FFlag (optionally plus one ad-hoc GUID).",
    Group = "DefaultAdmin",
    Aliases = { "purgeblacklist" },
    Args = { {
            Type = "string",
            Name = "ExtraGuid",
            Description = "Optional ad-hoc GUID to purge in addition to the FFlag blacklist",
            Optional = true
        } }
};