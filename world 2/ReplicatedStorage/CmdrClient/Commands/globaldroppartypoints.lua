-- Decompiled with Potassium's decompiler.

return {
    Name = "globaldroppartypoints",
    Description = "GLOBAL: drop party-point hats on the ground near players on EVERY live server at once (fanned out via MessagingService). Each hat pays its points to whoever walks over it, and a rare golden one pays 10x. Only lands where a party is actually running -- a server without one reports that it dropped nothing. One-shot: servers that boot later won\'t replay it. Use the admin panel\'s Party Points action instead to put points straight into everyone\'s total.",
    Group = "DefaultAdmin",
    Aliases = { "globaldroppartypoints", "gdroppoints" },
    Args = { {
            Type = "positiveInteger",
            Name = "Count",
            Description = "How many hats to drop per server (capped at 50, shared with whatever is already on the floor)."
        } }
};