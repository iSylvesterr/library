-- Decompiled with Potassium's decompiler.

return {
    Name = "robinaction",
    Description = "Forces every Robin pet currently just wandering the garden to immediately perform a chosen action (perch, eat, circle, or dropseed) for testing. Robins mid-action and other species are left alone.",
    Group = "DefaultAdmin",
    Aliases = { "robinaction" },
    Args = { {
            Type = "robinAction",
            Name = "Action",
            Description = "What the wandering Robins should do: perch, eat, circle, or dropseed."
        } }
};