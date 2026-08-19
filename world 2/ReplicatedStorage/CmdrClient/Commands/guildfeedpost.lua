-- Decompiled with Potassium's decompiler.

return {
    Name = "guildfeedpost",
    Description = "Posts a test accomplishment to a player\'s guild feed (bypasses the gameplay gates, not the flags).",
    Group = "DefaultAdmin",
    Aliases = { "gfpost" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose guild feed gets the post",
            Default = "me"
        }, {
            Type = "string",
            Name = "Kind",
            Description = "RecordWeight | FoundPet | RareMutation | BigSale | HatchedEgg",
            Optional = true
        }, {
            Type = "string",
            Name = "Detail",
            Description = "The {Detail} slot (number for weights/sales, text for mutations)",
            Optional = true
        }, {
            Type = "string",
            Name = "ItemKey",
            Description = "The {Item} slot (e.g. Carrot)",
            Optional = true
        } }
};