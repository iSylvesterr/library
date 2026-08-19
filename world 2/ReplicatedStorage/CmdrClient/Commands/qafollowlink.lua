-- Decompiled with Potassium's decompiler.

return {
    Name = "qafollowlink",
    Description = "QA: pretend you joined the game from the Roblox friends list, following a particular player. Roblox refuses a friends-list join into a private-server copy of another world, so the game finishes the join itself and moves you to your friend -- this is the only way to test that on Dev, because the real \'who did I follow\' value can\'t be set by code. Run it while standing in a normal public server, naming someone who is currently in a private copy of a world. Dev only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Who is doing the following, i.e. who should get moved.",
            Default = "me"
        }, {
            Type = "integer",
            Name = "TargetUserId",
            Description = "The Roblox user id of the friend to follow. Pass 0 to clear it -- which also prints your own user id, since that\'s the number the other tester needs.",
            Default = 0
        } }
};