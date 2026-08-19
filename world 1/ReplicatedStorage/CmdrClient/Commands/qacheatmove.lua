-- Decompiled with Potassium's decompiler.

return {
    Name = "qacheatmove",
    Description = "Simulates movement cheating WITHOUT anti-cheat exemption: a single far teleport hop, or a ~3s speed-hack stream of hops. Trips the Teleport/Velocity detections so QA can verify the conform snap-back and the persisted ViolationScore (dev only).",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose character to cheat-move",
            Default = "me"
        }, {
            Type = "string",
            Name = "Mode",
            Description = "teleport = one far hop; speed = ~3s stream of hops; score = print the ViolationScore; reset = zero the live + saved score",
            Default = "teleport"
        }, {
            Type = "number",
            Name = "Studs",
            Description = "Hop distance in studs (default: 300 for teleport, 30 per hop for speed)",
            Optional = true
        } }
};