-- Decompiled with Potassium's decompiler.

return {
    Name = "loadproddata",
    Description = "DEV ONLY: Fetches a user\'s PRODUCTION save via the Open Cloud proxy and loads it ONTO YOUR OWN account (whale-save QA), then kicks you to reload. OVERWRITES your dev data -- use an admin/alt account. Your Guild section is preserved.",
    Group = "DefaultAdmin",
    Aliases = { "loadprod" },
    Args = { {
            Type = "playerId",
            Name = "User",
            Description = "Username, or #<userId>, of the player whose PROD data to load onto you."
        } }
};