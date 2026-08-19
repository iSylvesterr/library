-- Decompiled with Potassium's decompiler.

return {
    Name = "qapresentdrop",
    Description = "QA: drop one Disco present in front of you, with no Disco running. The landing thud and camera bump fade out with distance, so a present that lands across the plaza is meant to be barely felt -- this puts one close enough to judge. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "players",
            Name = "Players",
            Description = "Who gets a present dropped in front of them. Defaults to you.",
            Optional = true
        } }
};