-- Decompiled with Potassium's decompiler.

return {
    Name = "copyuserdata",
    Description = "Copies another user\'s saved data ONTO YOUR OWN account (by userId) so you can browse their garden/inventory, then kicks you to reload. OVERWRITES your data -- use an admin/alt account. Your Guild section is preserved to avoid desyncing the guild row.",
    Group = "DefaultAdmin",
    Aliases = { "copyuser" },
    Args = { {
            Type = "playerId",
            Name = "User",
            Description = "Username, or #<userId>, of the player whose data to copy onto you."
        } }
};