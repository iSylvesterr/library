-- Decompiled with Potassium's decompiler.

local v1 = {
    MoonIcon = "rbxassetid://91446334780160",
    SunIcon = "rbxassetid://100486757307207",
    SleepIconFadeSeconds = 0.2,
    NightIconFadeOutSeconds = 1,
    NightLightingTransitionSeconds = 5,
    NightLightingStartDelaySeconds = 2,
    DayLightingTransitionSeconds = 5,
    WallCountdownDelayAfterDayStartsSeconds = 2,
    WallCountdownSeconds = 3,
    WallServerEntryGuardStartDelaySeconds = 0.25,
    WallEntryPenetrationBufferStuds = 3,
    WallEntryReturnBufferStuds = 3,
    WallEntryRollbackSampleMaxAgeSeconds = 1,
    TeleportFadeSeconds = 0.2,
    TeleportFadeHoldSeconds = 0.2,
    MusicTransitionSeconds = 1,
    LightingModifierPriority = 100,
    DayTransitionSoundId = nil,
    NightLighting = {
        Brightness = 3,
        ClockTime = 3.1,
        Ambient = Color3.fromRGB(210, 210, 210),
        ColorShift_Bottom = Color3.fromRGB(41, 50, 171),
        ColorShift_Top = Color3.fromRGB(154, 204, 250),
        OutdoorAmbient = Color3.fromRGB(89, 107, 102)
    },
    NightMusic = {
        Id = 130775373,
        Volume = 0.5
    }
};

return table.freeze(v1);