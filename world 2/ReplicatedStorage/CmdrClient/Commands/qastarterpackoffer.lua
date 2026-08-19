-- Decompiled with Potassium's decompiler.

return {
    Name = "qastarterpackoffer",
    Description = "QA: flip this world\'s Starter Pack one-time purchase lock. The pack is offered until it\'s bought, so clearing the lock brings the row back after a test purchase (no rejoin needed) and setting it checks that buying retires the offer. Clearing it also re-arms the once-per-world promo toast. Per-world: run it on Fall Harvest to test the fall pack, on Main for Main\'s. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Player",
            Description = "Whose offer to change.",
            Default = "me"
        }, {
            Type = "boolean",
            Name = "Offered",
            Description = "true (default) clears the purchase lock and the promo flag so the pack is on offer again; false marks it purchased so the row disappears.",
            Optional = true
        } }
};