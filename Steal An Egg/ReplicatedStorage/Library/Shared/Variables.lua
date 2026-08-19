-- Decompiled with Potassium's decompiler.

return {
    ExclusiveEggSpacingRadius = 4,
    ExclusiveEggRadiusStep = 1,
    ExclusiveEggRadiusBuffer = 5,
    ExclusiveEggMaxHeight = 15,
    ExclusiveEggHeightOffset = 10,
    ExclusiveEggMaxHeightBuffer = 5,
    ExclusiveEggRadiusRange = Vector2.new(8, 100),
    SettingsInfo = {
        SFX = {
            displayName = "Sound Effects",
            description = "Toggle sound effects on or off.",
            default = true,
            options = {
                [true] = true,
                [false] = false
            }
        },
        Music = {
            displayName = "Music",
            description = "Toggle music playback on or off.",
            default = true,
            options = {
                [true] = true,
                [false] = false
            }
        },
        Trading = {
            displayName = "Trading",
            description = "Allow other players to send you trade requests.",
            default = true,
            options = {
                [true] = true,
                [false] = false
            }
        },
        AFK = {
            displayName = "AFK Mode",
            description = "Stay in the lobby and skip Murder Mystery rounds.",
            default = false,
            options = {
                [true] = true,
                [false] = false
            }
        },
        HideOtherPets = {
            displayName = "Hide Other Pets",
            description = "Hide other players pets.",
            default = false,
            options = {
                [true] = true,
                [false] = false
            }
        },
        DisableVideos = {
            displayName = "Disable Videos",
            description = "Disable treadmill video.",
            default = false,
            options = {
                [true] = true,
                [false] = false
            }
        }
    }
};