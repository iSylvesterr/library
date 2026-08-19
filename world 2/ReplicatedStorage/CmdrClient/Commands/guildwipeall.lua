-- Decompiled with Potassium's decompiler.

return {
    Name = "guildwipeall",
    Description = "DESTRUCTIVE admin reset: enumerate every guild in the GuildIndex_ByCreatedAt OrderedDataStore and force-disband each via GuildService:DisbandById. Releases all name/tag reservations, kicks every online member, deletes every guild row. Requires literal confirmation token CONFIRM.",
    Group = "DefaultAdmin",
    Aliases = { "guildwipeall", "gwipeall" },
    Args = { {
            Type = "string",
            Name = "Confirm",
            Description = "Type CONFIRM (uppercase) to authorize the wipe."
        } }
};