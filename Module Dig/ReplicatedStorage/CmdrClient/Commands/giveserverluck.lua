-- Decompiled with Potassium's decompiler.

return {
    Name = "giveserverluck",
    Description = "Give the whole server a timed luck boost (admin only).",
    Group = "Admin",
    Args = { {
            Type = "number",
            Name = "Multiplier",
            Description = "The luck multiplier to add"
        }, {
            Type = "number",
            Name = "Duration",
            Description = "How long the boost lasts, in seconds"
        } }
};