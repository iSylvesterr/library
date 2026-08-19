-- Decompiled with Potassium's decompiler.

return {
    Name = "giveunicorn",
    Description = "Adds Unicorn follower pet(s) to a player\'s Pets data",
    Group = "DefaultAdmin",
    Aliases = { "giveunicorn" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give the unicorn to"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of unicorns to give (default 1)",
            Optional = true
        } }
};