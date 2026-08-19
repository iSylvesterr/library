-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local DEFAULT_SPRAY_ID = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "SprayBottles").DEFAULT_SPRAY_ID;
local DEFAULT_DETECTOR_ID = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").DEFAULT_DETECTOR_ID;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels");
local DEFAULT_SHOVEL_ID = v1.DEFAULT_SHOVEL_ID;
local Shovels = v1.Shovels;
local TUTORIAL_SHOVEL_ID = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "tutorial", "TutorialConfig").TUTORIAL_SHOVEL_ID;
local STARTER_ISLAND_ID = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").STARTER_ISLAND_ID;

return {
    DataTemplate = {
        Gold = Shovels[TUTORIAL_SHOVEL_ID].cost,
        RobuxSpent = 0,
        LastLogin = 0,
        LastLogout = 0,
        Playtime = 0,
        ItemsCleaned = 0,
        ItemsDug = 0,
        Info = {
            CanSendInvite = true
        },
        Settings = {},
        ProductTimers = {},
        LuckBoosts = {},
        LoggedFunnels = {},
        Badges = {},
        Gamepasses = {},
        Purchases = {},
        ProcessedReceipts = {},
        Inventory = {},
        FreeSkips = 0,
        GroupRewardClaimed = false,
        SprayUpgradeHintSeen = false,
        StarterPackOwned = false,
        StarterOfferShown = false,
        ShopOpened = false,
        TutorialStep = 0,
        TutorialDoneAt = 0,
        LegendaryHookDone = false,
        Discovered = {},
        Collection = {},
        EquippedShovel = DEFAULT_SHOVEL_ID,
        OwnedShovels = { DEFAULT_SHOVEL_ID },
        EquippedSpray = DEFAULT_SPRAY_ID,
        OwnedSprays = { DEFAULT_SPRAY_ID },
        EquippedDetector = DEFAULT_DETECTOR_ID,
        OwnedDetectors = { DEFAULT_DETECTOR_ID },
        UnlockedIslands = { STARTER_ISLAND_ID },
        CurrentIsland = STARTER_ISLAND_ID,
        UnlockedSections = {},
        PolisherLevels = {},
        OwnedPolishers = 1
    }
};