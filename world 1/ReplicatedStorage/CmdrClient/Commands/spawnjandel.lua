-- Decompiled with Potassium's decompiler.

return {
    Name = "spawnjandel",
    Description = "Spawns Jandel\'s avatar as an NPC in front of a player, cycling through every dance in JandelDanceData every 3s. Replaces any previously spawned one; despawnjandel removes it.",
    Group = "DefaultAdmin",
    Aliases = { "spawnjandel", "jandelnpc" },
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Player to spawn Jandel in front of",
            Default = "me"
        }, {
            Type = "playerId",
            Name = "User",
            Description = "Username, or #<userId>, whose avatar to use instead of Jandel\'s.",
            Optional = true
        }, {
            Type = "boolean",
            Name = "R6",
            Description = "Spawn an R6 rig instead of R15 (default false). Note the dances are R15 animations, so an R6 rig won\'t visibly move.",
            Optional = true
        } }
};