-- Decompiled with Potassium's decompiler.

return {
    Name = "qagivetokens",
    Description = "QA: set a player\'s Tokens balance so the Tokens-vs-Robux prompt can be exercised. Tokens are account-scoped (shared across every world), and the prompt only appears when the player can afford the item in Tokens -- so without a balance there is no way to tell a blocked product from an unaffordable one. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose Tokens balance to set.",
            Default = "me"
        }, {
            Type = "integer",
            Name = "Amount",
            Description = "Tokens to set the balance to. Default 100000, enough for any product in the shop.",
            Optional = true
        } }
};