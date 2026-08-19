-- Decompiled with Potassium's decompiler.

return {
    Name = "giveteleporter",
    Description = "Gives teleporter(s) to a player",
    Group = "DefaultAdmin",
    Aliases = { "giveteleporter" },
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to give teleporters to"
        }, {
            Type = "string",
            Name = "TeleporterName",
            Description = "The name of the teleporter (e.g. Teleporter)"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of teleporters to give (default 1)",
            Optional = true
        } }
};