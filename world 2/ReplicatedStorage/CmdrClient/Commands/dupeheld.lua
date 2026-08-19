-- Decompiled with Potassium's decompiler.

return {
    Name = "dupeheld",
    Description = "Duplicates the GUID-bearing item you are currently holding (harvested fruit or pet) onto target player(s), preserving its GUID, so dupe detection can be tested end-to-end. Then runs an immediate dupe scan.",
    Group = "DefaultAdmin",
    Aliases = { "dupeheld", "dupeitem", "testdupe" },
    Args = { {
            Type = "players",
            Name = "Recipients",
            Description = "Player(s) to receive a same-GUID copy of your held item. The executor is skipped (a same-container same-GUID dupe is impossible); target an alt/second player."
        }, {
            Type = "boolean",
            Name = "RunScanNow",
            Description = "Run a server-wide dupe scan immediately after duping so the dupe is flagged right away (default true). Set false to test the periodic/login scan path instead.",
            Optional = true
        } }
};