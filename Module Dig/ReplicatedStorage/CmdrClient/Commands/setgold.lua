-- Decompiled with Potassium's decompiler.

return {
    Name = "setgold",
    Description = "Set a player\'s gold to any value (admin only).",
    Group = "Admin",
    Args = { {
            Type = "player",
            Name = "Target",
            Description = "The player whose gold to set"
        }, {
            Type = "number",
            Name = "Amount",
            Description = "The gold value to set"
        } }
};