-- Decompiled with Potassium's decompiler.

return {
    Name = "qaseeddupe",
    Description = "QA: duplicate one of your existing item GUIDs (a pet, or newest harvested fruit) into ANOTHER world\'s bucket, so the cross-world dupe scan can be exercised. Relog to trigger the login scan (ServerDupeFlagEvent + DupeFlagged stamps). Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose profile to seed the cross-world dupe on.",
            Default = "me"
        }, {
            Type = "string",
            Name = "TargetWorld",
            Description = "World bucket to copy the item INTO (default: FallHarvest when run on Main, Main when run elsewhere).",
            Optional = true
        } }
};