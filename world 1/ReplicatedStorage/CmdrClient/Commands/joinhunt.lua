-- Decompiled with Potassium's decompiler.

return {
    Name = "joinhunt",
    Description = "Force player(s) into the Pet Hunt queue for testing. Auto-grants a Pet Teleporter if needed. Pass MinPlayers (e.g. 1) to form a match immediately without waiting for the full group.",
    Group = "DefaultAdmin",
    Aliases = { "joinhunt", "pethuntjoin" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to queue for a hunt"
        }, {
            Type = "string",
            Name = "HuntType",
            Description = "Which hunt: Legendary, Mythic, or Super"
        }, {
            Type = "positiveInteger",
            Name = "MinPlayers",
            Description = "Min players to form the match (e.g. 1 for an instant solo match). Omit for the normal threshold.",
            Optional = true
        } }
};