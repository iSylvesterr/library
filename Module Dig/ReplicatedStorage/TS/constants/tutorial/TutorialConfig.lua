-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local itemValueFor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").itemValueFor;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "npc", "VisitorConstants");
local INCOME_PERCENT_PER_MINUTE = v1.INCOME_PERCENT_PER_MINUTE;
local MIN_TIP = v1.MIN_TIP;
local TIP_POT_FRACTION = v1.TIP_POT_FRACTION;
local v2 = {
    GoToDigZone = 0,
    DetectItem = 1,
    GoToDigSpot = 2,
    StartDig = 3,
    SpamDig = 4,
    GoClean = 5,
    SprayDirt = 6,
    Reveal = 7,
    PlaceItem = 8,
    Tourists = 9,
    BuyShovel = 10,
    Done = 11
};
local v3 = itemValueFor("duck", "ok") * (INCOME_PERCENT_PER_MINUTE / 60) * 30 * TIP_POT_FRACTION;
local v4 = math.floor(v3);
local v5 = math.max(MIN_TIP, v4) * 3;

local function _(p6, p7, p8) -- Line: 57
    if p7 == nil then
        p7 = p6;
    end;

    if p8 == nil then
        p8 = p6;
    end;

    return {
        pc = p6,
        mobile = p7,
        console = p8
    };
end;

local v9 = {};
local v10 = nil;
local v11 = nil;
v9[v2.GoToDigZone] = {
    pc = "Head to the dig zone!",
    mobile = v10 == nil and "Head to the dig zone!" or v10,
    console = v11 == nil and "Head to the dig zone!" or v11
};
local v12 = nil;
local v13 = nil;
v9[v2.DetectItem] = {
    pc = "Detect your first item!",
    mobile = v12 == nil and "Detect your first item!" or v12,
    console = v13 == nil and "Detect your first item!" or v13
};
local v14 = nil;
local v15 = nil;
v9[v2.GoToDigSpot] = {
    pc = "Go dig up your item!",
    mobile = v14 == nil and "Go dig up your item!" or v14,
    console = v15 == nil and "Go dig up your item!" or v15
};
local v16 = "Press dig to start digging!";
local v17 = "Press R2 to start digging!";
v9[v2.StartDig] = {
    pc = "Click anywhere to start digging!",
    mobile = v16 == nil and "Click anywhere to start digging!" or v16,
    console = v17 == nil and "Click anywhere to start digging!" or v17
};
local v18 = "Spam tap to dig up the item!";
local v19 = "Spam (R2, L2) to dig up the item!";
v9[v2.SpamDig] = {
    pc = "Spam click to dig up the item!",
    mobile = v18 == nil and "Spam click to dig up the item!" or v18,
    console = v19 == nil and "Spam click to dig up the item!" or v19
};
local v20 = nil;
local v21 = nil;
v9[v2.GoClean] = {
    pc = "Go clean your item!",
    mobile = v20 == nil and "Go clean your item!" or v20,
    console = v21 == nil and "Go clean your item!" or v21
};
local v22 = "Spray off all the dirt!";
local v23 = "Hold R2 to spray off all the dirt!";
v9[v2.SprayDirt] = {
    pc = "Spray off all the dirt!",
    mobile = v22 == nil and "Spray off all the dirt!" or v22,
    console = v23 == nil and "Spray off all the dirt!" or v23
};
local v24 = nil;
local v25 = nil;
v9[v2.PlaceItem] = {
    pc = "Put your first item on display!",
    mobile = v24 == nil and "Put your first item on display!" or v24,
    console = v25 == nil and "Put your first item on display!" or v25
};
local v26 = nil;
local v27 = nil;
v9[v2.Tourists] = {
    pc = "Wait for some tourists to visit your plot!",
    mobile = v26 == nil and "Wait for some tourists to visit your plot!" or v26,
    console = v27 == nil and "Wait for some tourists to visit your plot!" or v27
};
local v28 = nil;
local v29 = nil;
v9[v2.BuyShovel] = {
    pc = "Use your gold to buy a new shovel!",
    mobile = v28 == nil and "Use your gold to buy a new shovel!" or v28,
    console = v29 == nil and "Use your gold to buy a new shovel!" or v29
};
local v30 = nil;
local v31 = nil;
v9[v2.Done] = {
    pc = "Good job finishing the tutorial, have fun!",
    mobile = v30 == nil and "Good job finishing the tutorial, have fun!" or v30,
    console = v31 == nil and "Good job finishing the tutorial, have fun!" or v31
};

return {
    TutorialStep = v2,
    TUTORIAL_DIG_ITEM = "duck",
    TUTORIAL_ITEM_CONDITION = "ok",
    TUTORIAL_SHOVEL_ID = "woodShovel",
    TUTORIAL_PEDESTAL_SLOT = 1,
    TUTORIAL_DETECT_DELAY = 4,
    TUTORIAL_NODE_MIN_DISTANCE = 5,
    TUTORIAL_NODE_MAX_DISTANCE = 9,
    TUTORIAL_NODE_RANGE_FRACTION = 0.7,
    TUTORIAL_NODE_PLACEMENT_TRIES = 12,
    TUTORIAL_DIG_SPOT_RANGE = 8,
    TUTORIAL_DIG_SPOT_SLACK = 2,
    TUTORIAL_DIG_SPOT_MESSAGE = "Dig at your dig spot!",
    TUTORIAL_DIG_SPOT_DURATION = 3,
    TUTORIAL_DIG_DIFFICULTY = {
        clickPower = 0.023,
        decay = 0.012
    },
    TUTORIAL_PROGRESS_FLOOR = 0.12,
    TUTORIAL_DIRT_TOUGHNESS = 0.75,
    TUTORIAL_TOURIST_COUNT = 3,
    TUTORIAL_TOURIST_SPREAD = 3,
    TUTORIAL_TOURIST_STAGGER_MIN = 0.5,
    TUTORIAL_TOURIST_STAGGER_MAX = 1,
    TUTORIAL_TOURIST_ENTER_STAGGER_MIN = 0.5,
    TUTORIAL_TOURIST_ENTER_STAGGER_MAX = 0.8,
    TUTORIAL_TOURIST_ARRIVE_SECONDS = 3.5,
    TUTORIAL_TOURIST_PAY_DELAY = 5.5,
    TUTORIAL_TOURIST_MAX_SPEED = 30,
    TUTORIAL_TOURIST_LIFETIME = 60,
    TUTORIAL_TOURIST_FADE_SECONDS = 1,
    TUTORIAL_TIP_TOTAL = v5,
    FOLLOW_TUTORIAL_MESSAGE = "Follow tutorial!",
    FOLLOW_TUTORIAL_DURATION = 3,
    TUTORIAL_TEXTS = v9,
    ONBOARDING_FUNNEL_NAME = "OnboardingB",
    ONBOARDING_JOIN_STEP_NAME = "PlayerJoined",
    ONBOARDING_FUNNEL_ORDER = { "PlayerJoined", "ReachedDigZone", "DetectedItem", "ReachedDigSpot", "StartedDig", "DugItem", "StartedCleaning", "CleanedItem", "RevealedItem", "PlacedItem", "TouristsPaid", "TutorialComplete" },
    TUTORIAL_FUNNEL_STEP_NAMES = {
        [v2.DetectItem] = "ReachedDigZone",
        [v2.GoToDigSpot] = "DetectedItem",
        [v2.StartDig] = "ReachedDigSpot",
        [v2.SpamDig] = "StartedDig",
        [v2.GoClean] = "DugItem",
        [v2.SprayDirt] = "StartedCleaning",
        [v2.Reveal] = "CleanedItem",
        [v2.PlaceItem] = "RevealedItem",
        [v2.Tourists] = "PlacedItem",
        [v2.BuyShovel] = "TouristsPaid",
        [v2.Done] = "TutorialComplete"
    },
    LEGACY_ONBOARDING_COMPLETE_KEY = "Tutorial_TutorialComplete",
    LEGACY_ONBOARDING_TOURISTS_KEY = "Tutorial_TouristsPaid"
};