-- Decompiled with Potassium's decompiler.

return {
    Name = "giveglobalprop",
    Description = "GLOBAL: gives a prop/cosmetic to EVERY player on EVERY live server at once (fanned out via MessagingService) and toasts each of them. One-shot -- servers that boot later won\'t replay it.",
    Group = "DefaultAdmin",
    Aliases = { "giveglobalprop", "gglobalprop" },
    Args = { {
            Type = "cosmeticName",
            Name = "Prop",
            Description = "The name of the prop/cosmetic to give"
        }, {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "The number of props to give each player (default 1)",
            Optional = true
        } }
};