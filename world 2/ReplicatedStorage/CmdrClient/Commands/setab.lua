-- Decompiled with Potassium's decompiler.

return {
    Name = "setab",
    Description = "Override an A/B attribute by key/value for testing this session. Sets a player-level override for you (your client + server reads) AND a server-wide job-level override (server GetJobAttribute), so it works for player- and job-scoped tests. Omit the value to clear.",
    Group = "DefaultAdmin",
    Aliases = { "setab", "abset" },
    Args = { {
            Type = "string",
            Name = "Key",
            Description = "Attribute key, e.g. Garden.Likes.Enabled or Players.CollisionsEnabled"
        }, {
            Type = "string",
            Name = "Value",
            Description = "true/false, a number, or text. Omit to clear the override.",
            Optional = true
        } }
};