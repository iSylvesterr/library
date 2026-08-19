-- Decompiled with Potassium's decompiler.

return {
    Name = "syncdevproducts",
    Description = "Sync developer products to Roblox via Open Cloud and store mapping in DataStore",
    Group = "DefaultAdmin",
    Aliases = { "syncdevproducts" },
    Args = { {
            Type = "string",
            Name = "PlaceId",
            Description = "Place id, \"dev\", or \"prod\". Cross-universe is allowed (e.g. run \"prod\" from Dev Studio) — the mapping is written via Open Cloud."
        }, {
            Type = "boolean",
            Name = "Force",
            Description = "Write even if config products/variants are missing a real id (overrides the missing/regression safety abort). Default false.",
            Optional = true
        } }
};