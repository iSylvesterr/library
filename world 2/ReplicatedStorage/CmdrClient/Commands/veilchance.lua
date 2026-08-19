-- Decompiled with Potassium's decompiler.

return {
    Name = "veilchance",
    Description = "Sets the server-wide Shadow Dragon BASE Veil-on-plant chance for testing. Still scaled by the best equipped dragon\'s size/type (x2 Big, x3 Huge, x1.25 Rainbow) and clamped to 1, so the size curve stays testable. Applies to anyone with a Shadow Dragon equipped. Pass a negative number to reset to the Game.Pets.ShadowDragon.VeilChance flag.",
    Group = "DefaultAdmin",
    Aliases = { "veilchance" },
    Args = { {
            Type = "number",
            Name = "Chance",
            Description = "Veil chance from 0 to 1 (e.g. 1 = always veil). Negative resets to the flag default. Default 1.",
            Optional = true
        } }
};