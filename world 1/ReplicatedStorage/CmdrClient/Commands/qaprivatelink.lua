-- Decompiled with Potassium's decompiler.

return {
    Name = "qaprivatelink",
    Description = "QA: pretend this server is a private server, so cross-world travel puts you in your own private copy of the destination world instead of a public one. Real private servers can\'t be switched on for Dev, so this is the only way to test it here. Everyone on THIS server who travels lands in the same copy -- run it once, then have both testers travel. Dev only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "Tag",
            Description = "Any short label for the group, e.g. `team1`. Two testers who use the SAME tag (on different servers) end up in the same private copy. Pass `off` to go back to a normal server."
        } }
};