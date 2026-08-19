-- Decompiled with Potassium's decompiler.

return {
    Name = "qatravelfade",
    Description = "QA: play the world-travel screen transition on yourself without actually teleporting -- the screen fades to black, holds, then clears. Pass a sound name to hear a different candidate under it (Teleport, Whoosh, MagicDiceTeleport, MagicDiceOtherTeleport, RainbowPoof, WindStaffCast). Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "Sound",
            Description = "Which SoundService.SFX sound to play. Leave blank for the one the game actually ships.",
            Optional = true
        }, {
            Type = "players",
            Name = "Players",
            Description = "Who sees it. Defaults to you.",
            Optional = true
        }, {
            Type = "number",
            Name = "HoldSeconds",
            Description = "How long the screen stays black before clearing. Default 4.",
            Optional = true
        } }
};