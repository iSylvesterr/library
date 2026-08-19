-- Decompiled with Potassium's decompiler.

return {
    Name = "qabadge",
    Description = "QA: list every badge this server has TRIED to award a player this session, how many times each trigger fired, and what came back. Badges exist only in the production universe, so on a dev place awarding is inert and a broken trigger looks exactly like a working one -- this is the only way to tell them apart. Read-only, and per-server: the list resets on rejoin.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose badge attempts to list.",
            Default = "me"
        } }
};