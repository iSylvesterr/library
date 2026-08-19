-- Decompiled with Potassium's decompiler.

return {
    Name = "competitionaddscore",
    Description = "Add to (or, with a negative amount, subtract from) a guild member\'s competition score in the backend admin store. Convenience wrapper over competitionsetscore\'s \"+N\"/\"-N\" form. Note: the backend max-merges scores, so a result LOWER than the player\'s profile score is restored on their next tick. Pass the competition id, the guild\'s TAG or guild_id UUID, a UserId or username, and a numeric amount.",
    Group = "DefaultAdmin",
    Aliases = { "competitionaddscore", "caddscore" },
    Args = { {
            Type = "string",
            Name = "Competition",
            Description = "Competition id (the *.json5 filename minus extension), e.g. most_carrots."
        }, {
            Type = "string",
            Name = "Guild",
            Description = "Guild tag (e.g. JOE) or full guild_id UUID."
        }, {
            Type = "string",
            Name = "Player",
            Description = "Numeric UserId or Roblox username (resolved via GetUserIdFromNameAsync)."
        }, {
            Type = "string",
            Name = "Amount",
            Description = "Amount to add; negative to subtract. Decimals allowed."
        } }
};