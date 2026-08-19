-- Decompiled with Potassium's decompiler.

return {
    Name = "amberchance",
    Description = "Sets the server-wide Amber mutation chance for ripening Amber Cranberry fruit, for testing. Immediately re-decides fruit that has already ripened, so raising it retrofits existing gardens. Pass a negative number to reset to the Game.AmberCranberry.RipeMutationChance flag.",
    Group = "DefaultAdmin",
    Aliases = { "amberchance" },
    Args = { {
            Type = "number",
            Name = "Chance",
            Description = "Amber chance from 0 to 1 (e.g. 1 = every ripe Amber Cranberry fruit). Negative resets to the flag default. Default 1.",
            Optional = true
        } }
};