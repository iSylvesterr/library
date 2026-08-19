-- Decompiled with Potassium's decompiler.

return {
    Name = "giveguildcrate",
    Description = "Gives guild crate(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveguildcrate" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give guild crates to"
        }, {
            Type = "guildCrateName",
            Name = "GuildCrateName",
            Description = "The name of the guild crate"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of guild crates to give (default 1)",
            Optional = true
        } }
};