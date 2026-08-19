-- Decompiled with Potassium's decompiler.

return {
    Name = "dailydealtime",
    Description = "Shows Steven\'s daily deal status (available, or time until it resets) in every world the player has visited",
    Group = "DefaultAdmin",
    Aliases = { "dailydealtime", "checkdailydeal", "dailydealstatus" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to check"
        } }
};