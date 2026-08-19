-- Decompiled with Potassium's decompiler.

return {
    Name = "tptouser",
    Description = "Teleports YOU into the live server (place + jobId) that the given user is currently playing on. Cross-server via MessagingService; pass a username or #<userId>. Fails if the user is offline or doesn\'t answer in time.",
    Group = "DefaultAdmin",
    Aliases = { "tpu" },
    Args = { {
            Type = "playerId",
            Name = "User",
            Description = "Username, or #<userId>, of the player whose server to join."
        } }
};