-- Decompiled with Potassium's decompiler.

return {
    Name = "guildgrantcoins",
    Description = "Grant Guild Coins to a guild\'s leader balance (testing only).",
    Group = "DefaultAdmin",
    Aliases = { "guildgrantcoins", "ggrant" },
    Args = { {
            Type = "string",
            Name = "GuildId",
            Description = "Guild id."
        }, {
            Type = "integer",
            Name = "Amount",
            Description = "Amount of Guild Coins to grant (negative to deduct)."
        } }
};