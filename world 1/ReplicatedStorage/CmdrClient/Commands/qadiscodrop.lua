-- Decompiled with Potassium's decompiler.

return {
    Name = "qadiscodrop",
    Description = "QA: play the Disco bass-drop camera kick on demand -- the FOV punches out and settles, with no disco running and no drop to wait for. Always plays, so it can be reviewed on its own before judging whether the music detection is finding the drops. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "Who feels it. Defaults to you.",
            Optional = true
        } }
};