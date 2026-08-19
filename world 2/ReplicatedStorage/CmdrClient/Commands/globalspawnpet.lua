-- Decompiled with Potassium's decompiler.

return {
    Name = "globalspawnpet",
    Description = "GLOBAL: spawn wild pet(s) of the given species on EVERY live server at once (fanned out via MessagingService). One-shot -- servers that boot later won\'t replay it. Optionally pin a size/type.",
    Group = "DefaultAdmin",
    Aliases = { "globalspawnpet", "gspawnpet" },
    Args = { {
            Type = "pet",
            Name = "PetName",
            Description = "Pet species to spawn (e.g. Raccoon)."
        }, {
            Type = "positiveInteger",
            Name = "Count",
            Description = "How many to spawn per server (default 1, capped).",
            Optional = true
        }, {
            Type = "string",
            Name = "Size",
            Description = "Pet size: \"Big\" (2x), \"Huge\" (4x), or blank/none for normal.",
            Optional = true
        }, {
            Type = "string",
            Name = "Type",
            Description = "Pet type: \"Rainbow\", or blank/none for no type.",
            Optional = true
        } }
};