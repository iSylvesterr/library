-- Decompiled with Potassium's decompiler.

return {
    Name = "resetdailydeal",
    Description = "Resets a player\'s Steven daily deal cooldown in THIS world so the bonus sell is available again (other worlds keep counting down)",
    Group = "DefaultAdmin",
    Aliases = { "resetdailydeal", "cleardailydeal" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) whose daily deal should be reset"
        } }
};