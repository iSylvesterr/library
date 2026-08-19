-- Decompiled with Potassium's decompiler.

return {
    Name = "qaworldrelease",
    Description = "QA: put a fake Fall Harvest launch countdown on every Dev server so the release gates can be tested without waiting for the real date. Dev is normally wide open; arming this makes it behave exactly like Live -- Ethan counts down, travel is refused, and anyone who reaches the world place is bounced home until the countdown hits zero. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "Seconds",
            Description = "Seconds until the world opens (e.g. 90). Use 0 for open right now, or `off` to drop the fake countdown and go back to a normal Dev server."
        }, {
            Type = "boolean",
            Name = "MenuSwitch",
            Description = "Stands in for the Game.Explorer.TravelMenuEnabled switch. Default true, which is launch day (switch on early, timer still running). Pass false to check that the switch being off keeps Ethan counting down even after zero.",
            Optional = true
        } }
};