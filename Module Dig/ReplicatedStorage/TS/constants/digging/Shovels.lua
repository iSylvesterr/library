-- Decompiled with Potassium's decompiler.

local STARTER_ISLAND_ID = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").STARTER_ISLAND_ID;
local u1 = CFrame.new(
    -0.503967285,
    -0.511281967,
    -1.429437256,
    0.898794413,
    -0.438371301,
    0,
    0.438371271,
    0.898794293,
    0,
    0,
    0,
    1
);
local u2 = CFrame.new(
    0.005767822,
    -0.274448395,
    0.604675293,
    -0.74314481,
    -0.669130862,
    0,
    0.669130683,
    -0.743144989,
    0,
    0,
    0,
    1
);

local function shovel(p3, p4, p5, p6, p7) -- Line: 12
    -- upvalues: STARTER_ISLAND_ID (copy), u1 (copy), u2 (copy)
    if p7 == nil then
        p7 = STARTER_ISLAND_ID;
    end;

    return {
        holdAnimationId = "rbxassetid://107504291462193",
        digAnimationId = "rbxassetid://113131667360668",
        gripNudge = Vector3.new(-0.2, 0, 0),
        displayName = p3,
        assetName = p3,
        cost = p4,
        power = p5,
        walkSpeedPercent = p6,
        islandId = p7,
        equippedPivotC0 = u1,
        backPivotC0 = u2
    };
end;

local u8 = {};
local v9 = nil;

if v9 == nil then
    v9 = STARTER_ISLAND_ID;
end;

u8.plasticShovel = {
    displayName = "Plastic Shovel",
    assetName = "Plastic Shovel",
    cost = 0,
    power = 1,
    walkSpeedPercent = 0,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v9,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v10 = nil;

if v10 == nil then
    v10 = STARTER_ISLAND_ID;
end;

u8.woodShovel = {
    displayName = "Wood Shovel",
    assetName = "Wood Shovel",
    cost = 250,
    power = 2,
    walkSpeedPercent = 5,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v10,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v11 = nil;

if v11 == nil then
    v11 = STARTER_ISLAND_ID;
end;

u8.stoneShovel = {
    displayName = "Stone Shovel",
    assetName = "Stone Shovel",
    cost = 1600,
    power = 3,
    walkSpeedPercent = 10,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v11,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v12 = nil;

if v12 == nil then
    v12 = STARTER_ISLAND_ID;
end;

u8.metalShovel = {
    displayName = "Metal Shovel",
    assetName = "Metal Shovel",
    cost = 9000,
    power = 5,
    walkSpeedPercent = 15,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v12,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v13 = nil;

if v13 == nil then
    v13 = STARTER_ISLAND_ID;
end;

u8.goldShovel = {
    displayName = "Gold Shovel",
    assetName = "Gold Shovel",
    cost = 45000,
    power = 7,
    walkSpeedPercent = 20,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v13,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v14 = nil;

if v14 == nil then
    v14 = STARTER_ISLAND_ID;
end;

u8.amethystShovel = {
    displayName = "Amethyst Shovel",
    assetName = "Amethyst Shovel",
    cost = 190000,
    power = 9,
    walkSpeedPercent = 25,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v14,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v15 = "island2";

if v15 == nil then
    v15 = STARTER_ISLAND_ID;
end;

u8.titaniumShovel = {
    displayName = "Titanium Shovel",
    assetName = "Titanium Shovel",
    cost = 390000,
    power = 14,
    walkSpeedPercent = 30,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v15,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v16 = "island2";

if v16 == nil then
    v16 = STARTER_ISLAND_ID;
end;

u8.cobaltShovel = {
    displayName = "Cobalt Shovel",
    assetName = "Cobalt Shovel",
    cost = 650000,
    power = 17,
    walkSpeedPercent = 35,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v16,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v17 = "island2";

if v17 == nil then
    v17 = STARTER_ISLAND_ID;
end;

u8.carbonShovel = {
    displayName = "Carbon Shovel",
    assetName = "Carbon Shovel",
    cost = 1300000,
    power = 21,
    walkSpeedPercent = 40,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v17,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v18 = "island2";

if v18 == nil then
    v18 = STARTER_ISLAND_ID;
end;

u8.rubyShovel = {
    displayName = "Ruby Shovel",
    assetName = "Ruby Shovel",
    cost = 2900000,
    power = 26,
    walkSpeedPercent = 45,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = v18,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};
local v19 = "island2";

if v19 ~= nil then
    STARTER_ISLAND_ID = v19;
end;

u8.diamondShovel = {
    displayName = "Diamond Shovel",
    assetName = "Diamond Shovel",
    cost = 9200000,
    power = 40,
    walkSpeedPercent = 50,
    holdAnimationId = "rbxassetid://107504291462193",
    digAnimationId = "rbxassetid://113131667360668",
    gripNudge = Vector3.new(-0.2, 0, 0),
    islandId = STARTER_ISLAND_ID,
    equippedPivotC0 = u1,
    backPivotC0 = u2
};

return {
    DIG_ZONE_TAG = "DigZone",
    DIG_AREA_NAME = "DigArea",
    BASE_WALK_SPEED = 16,
    DEFAULT_SHOVEL_ID = "plasticShovel",

    isShovelId = function(p20) -- Line: 45, Name: isShovelId
        -- upvalues: u8 (copy)
        return u8[p20] ~= nil;
    end,

    Shovels = u8,
    SHOVEL_TIER_ORDER = { "plasticShovel", "woodShovel", "stoneShovel", "metalShovel", "goldShovel", "amethystShovel", "titaniumShovel", "cobaltShovel", "carbonShovel", "rubyShovel", "diamondShovel" }
};