-- Decompiled with Potassium's decompiler.

local STARTER_ISLAND_ID = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").STARTER_ISLAND_ID;
local u1 = CFrame.new(
    -0.00828552246,
    -1.24461174,
    -2.78112793,
    0,
    0,
    -1,
    0.882947505,
    0.469471693,
    0,
    0.469471693,
    -0.882947505,
    0
);
local u2 = CFrame.new(
    0.810668945,
    -0.752300262,
    -0.00927734375,
    0,
    0,
    1,
    0.694658399,
    0.719339848,
    0,
    -0.719339848,
    0.694658339,
    0
);

local function detector(p3, p4, p5, p6, p7, p8, p9) -- Line: 10
    -- upvalues: STARTER_ISLAND_ID (copy), u1 (copy), u2 (copy)
    if p9 == nil then
        p9 = STARTER_ISLAND_ID;
    end;

    return {
        holdAnimationId = "rbxassetid://95353436234566",
        gripNudge = Vector3.new(0, 0, 0),
        displayName = p3,
        assetName = p3,
        cost = p4,
        luck = p5,
        rarityBias = p6,
        range = p7,
        junkFloor = p8,
        islandId = p9,
        equippedPivotC0 = u1,
        sidePivotC0 = u2
    };
end;

local u10 = {};
local v11 = nil;

if v11 == nil then
    v11 = STARTER_ISLAND_ID;
end;

u10.rusty = {
    displayName = "Rusty Detector",
    assetName = "Rusty Detector",
    cost = 0,
    luck = 1,
    rarityBias = 28,
    range = 7,
    junkFloor = 0,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v11,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v12 = nil;

if v12 == nil then
    v12 = STARTER_ISLAND_ID;
end;

u10.copper = {
    displayName = "Copper Detector",
    assetName = "Copper Detector",
    cost = 500,
    luck = 3,
    rarityBias = 34,
    range = 7.5,
    junkFloor = 1.5,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v12,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v13 = nil;

if v13 == nil then
    v13 = STARTER_ISLAND_ID;
end;

u10.silver = {
    displayName = "Silver Detector",
    assetName = "Silver Detector",
    cost = 5000,
    luck = 5,
    rarityBias = 42,
    range = 8,
    junkFloor = 1.95,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v13,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v14 = nil;

if v14 == nil then
    v14 = STARTER_ISLAND_ID;
end;

u10.gold = {
    displayName = "Gold Detector",
    assetName = "Gold Detector",
    cost = 28000,
    luck = 8,
    rarityBias = 52,
    range = 8.5,
    junkFloor = 2.15,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v14,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v15 = nil;

if v15 == nil then
    v15 = STARTER_ISLAND_ID;
end;

u10.platinum = {
    displayName = "Platinum Detector",
    assetName = "Platinum Detector",
    cost = 140000,
    luck = 12,
    rarityBias = 65,
    range = 9,
    junkFloor = 2.25,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v15,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v16 = "island2";

if v16 == nil then
    v16 = STARTER_ISLAND_ID;
end;

u10.onyx = {
    displayName = "Onyx Detector",
    assetName = "Onyx Detector",
    cost = 330000,
    luck = 18,
    rarityBias = 82,
    range = 9.5,
    junkFloor = 2.35,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v16,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v17 = "island2";

if v17 == nil then
    v17 = STARTER_ISLAND_ID;
end;

u10.sapphire = {
    displayName = "Sapphire Detector",
    assetName = "Sapphire Detector",
    cost = 530000,
    luck = 28,
    rarityBias = 105,
    range = 10,
    junkFloor = 2.45,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v17,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v18 = "island2";

if v18 == nil then
    v18 = STARTER_ISLAND_ID;
end;

u10.jade = {
    displayName = "Jade Detector",
    assetName = "Jade Detector",
    cost = 1000000,
    luck = 44,
    rarityBias = 135,
    range = 10.75,
    junkFloor = 2.5,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v18,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v19 = "island2";

if v19 == nil then
    v19 = STARTER_ISLAND_ID;
end;

u10.topaz = {
    displayName = "Topaz Detector",
    assetName = "Topaz Detector",
    cost = 2300000,
    luck = 70,
    rarityBias = 175,
    range = 11.5,
    junkFloor = 2.55,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = v19,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};
local v20 = "island2";

if v20 ~= nil then
    STARTER_ISLAND_ID = v20;
end;

u10.crystal = {
    displayName = "Crystal Detector",
    assetName = "Crystal Detector",
    cost = 6400000,
    luck = 110,
    rarityBias = 225,
    range = 12,
    junkFloor = 2.6,
    holdAnimationId = "rbxassetid://95353436234566",
    gripNudge = Vector3.new(0, 0, 0),
    islandId = STARTER_ISLAND_ID,
    equippedPivotC0 = u1,
    sidePivotC0 = u2
};

return {
    DETECTOR_SWEEP_SECONDS = 0.8,
    DETECTOR_PING_SECONDS = 0.93,
    NO_DETECTOR = "none",
    DEFAULT_DETECTOR_ID = "rusty",

    isDetectorId = function(p21) -- Line: 44, Name: isDetectorId
        -- upvalues: u10 (copy)
        return u10[p21] ~= nil;
    end,

    Detectors = u10,
    DETECTOR_TIER_ORDER = { "rusty", "copper", "silver", "gold", "platinum", "onyx", "sapphire", "jade", "topaz", "crystal" }
};