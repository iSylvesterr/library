-- Decompiled with Potassium's decompiler.

return {
    RARITY_FIRST_FOUND_EVENT = "RarityFirstFound",
    CONDITION_FIRST_FOUND_EVENT = "ConditionFirstFound",
    CLEANED_MILESTONE_EVENT = "CleanedMilestone",
    DISPLAY_MILESTONE_EVENT = "DisplayMilestone",
    PLAYTIME_MILESTONE_EVENT = "PlaytimeMilestone",
    RARITY_FUNNEL_NAME = "RarityProgression",
    PLAYTIME_FUNNEL_NAME = "PlaytimeProgression",
    PLAYTIME_SCAN_INTERVAL = 30,
    ECONOMY_FLUSH_INTERVAL = 60,
    INVENTORY_BULK_SKU = "InventoryBulk",
    VISITOR_TIP_SKU = "VisitorTip",
    TUTORIAL_TIP_SKU = "TutorialTip",
    CLEANED_MILESTONES = { 1, 5, 10, 25, 50, 100, 250, 500, 1000 },
    DISPLAY_MILESTONES = { 1, 2, 3, 5, 8, 12 },
    PLAYTIME_MILESTONES = { {
            seconds = 300,
            label = "5m"
        }, {
            seconds = 900,
            label = "15m"
        }, {
            seconds = 1800,
            label = "30m"
        }, {
            seconds = 3600,
            label = "1h"
        }, {
            seconds = 7200,
            label = "2h"
        }, {
            seconds = 14400,
            label = "4h"
        }, {
            seconds = 28800,
            label = "8h"
        }, {
            seconds = 57600,
            label = "16h"
        }, {
            seconds = 115200,
            label = "32h"
        } }
};