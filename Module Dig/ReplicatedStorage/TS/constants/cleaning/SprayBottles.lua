-- Decompiled with Potassium's decompiler.

local STARTER_ISLAND_ID = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").STARTER_ISLAND_ID;
local identity = CFrame.identity;
local u1 = CFrame.Angles(0, 0, 0.8552113334772214);

local function sprayBottle(p2, p3, p4, p5, p6, p7) -- Line: 13
    -- upvalues: identity (copy), STARTER_ISLAND_ID (copy)
    return {
        holdDistance = 2.2,
        barrelRoll = 0,
        displayName = p2,
        assetName = p2,
        cost = p3,
        dissolveRate = p4,
        rangeRating = p5,
        dissolveRadius = p5 * 0.06,
        beamWidth = p6,
        pressurePitch = p7,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    };
end;

local function pressureWasher(p8, p9, p10, p11, p12, p13) -- Line: 29
    -- upvalues: identity (copy), STARTER_ISLAND_ID (copy), u1 (copy)
    local v14 = table.clone({
        holdDistance = 2.2,
        barrelRoll = 0,
        displayName = p8,
        assetName = p8,
        cost = p9,
        dissolveRate = p10,
        rangeRating = p11,
        dissolveRadius = p11 * 0.06,
        beamWidth = p12,
        pressurePitch = p13,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    });
    setmetatable(v14, nil);
    v14.holdDistance = 4.5;
    v14.barrelRoll = 4.71238898038469;
    v14.viewportRotation = u1;
    v14.islandId = "island2";

    return v14;
end;

local u15 = {
    basic = {
        displayName = "Basic Spray Bottle",
        assetName = "Basic Spray Bottle",
        cost = 0,
        dissolveRate = 1.95,
        rangeRating = 22,
        dissolveRadius = 1.3199999999999998,
        beamWidth = 1,
        pressurePitch = 1,
        holdDistance = 2.2,
        barrelRoll = 0,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    },
    rubber = {
        displayName = "Rubber Spray Bottle",
        assetName = "Rubber Spray Bottle",
        cost = 900,
        dissolveRate = 2.09,
        rangeRating = 24,
        dissolveRadius = 1.44,
        beamWidth = 1.1,
        pressurePitch = 1.05,
        holdDistance = 2.2,
        barrelRoll = 0,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    },
    plastic = {
        displayName = "Plastic Spray Bottle",
        assetName = "Plastic Spray Bottle",
        cost = 5500,
        dissolveRate = 2.35,
        rangeRating = 26,
        dissolveRadius = 1.56,
        beamWidth = 1.2,
        pressurePitch = 1.1,
        holdDistance = 2.2,
        barrelRoll = 0,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    },
    copper = {
        displayName = "Copper Spray Bottle",
        assetName = "Copper Spray Bottle",
        cost = 26000,
        dissolveRate = 2.53,
        rangeRating = 28,
        dissolveRadius = 1.68,
        beamWidth = 1.3,
        pressurePitch = 1.2,
        holdDistance = 2.2,
        barrelRoll = 0,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    },
    steel = {
        displayName = "Steel Spray Bottle",
        assetName = "Steel Spray Bottle",
        cost = 100000,
        dissolveRate = 2.63,
        rangeRating = 30,
        dissolveRadius = 1.7999999999999998,
        beamWidth = 1.45,
        pressurePitch = 1.3,
        holdDistance = 2.2,
        barrelRoll = 0,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    },
    gold = {
        displayName = "Gold Spray Bottle",
        assetName = "Gold Spray Bottle",
        cost = 220000,
        dissolveRate = 2.74,
        rangeRating = 32,
        dissolveRadius = 1.92,
        beamWidth = 1.55,
        pressurePitch = 1.4,
        holdDistance = 2.2,
        barrelRoll = 0,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    },
    turquoise = {
        displayName = "Turquoise Spray Bottle",
        assetName = "Turquoise Spray Bottle",
        cost = 400000,
        dissolveRate = 2.75,
        rangeRating = 34,
        dissolveRadius = 2.04,
        beamWidth = 1.7,
        pressurePitch = 1.5,
        holdDistance = 2.2,
        barrelRoll = 0,
        viewportRotation = identity,
        islandId = STARTER_ISLAND_ID
    }
};
local v16 = table.clone({
    displayName = "Plastic Pressure Washer",
    assetName = "Plastic Pressure Washer",
    cost = 640000,
    dissolveRate = 2.94,
    rangeRating = 36,
    dissolveRadius = 2.16,
    beamWidth = 1.85,
    pressurePitch = 1.6,
    holdDistance = 2.2,
    barrelRoll = 0,
    viewportRotation = identity,
    islandId = STARTER_ISLAND_ID
});
setmetatable(v16, nil);
v16.holdDistance = 4.5;
v16.barrelRoll = 4.71238898038469;
v16.viewportRotation = u1;
v16.islandId = "island2";
u15.plasticWasher = v16;
local v17 = table.clone({
    displayName = "Metal Pressure Washer",
    assetName = "Metal Pressure Washer",
    cost = 1000000,
    dissolveRate = 3.16,
    rangeRating = 38,
    dissolveRadius = 2.28,
    beamWidth = 2,
    pressurePitch = 1.7,
    holdDistance = 2.2,
    barrelRoll = 0,
    viewportRotation = identity,
    islandId = STARTER_ISLAND_ID
});
setmetatable(v17, nil);
v17.holdDistance = 4.5;
v17.barrelRoll = 4.71238898038469;
v17.viewportRotation = u1;
v17.islandId = "island2";
u15.metalWasher = v17;
local v18 = table.clone({
    displayName = "Obsidian Pressure Washer",
    assetName = "Obsidian Pressure Washer",
    cost = 1600000,
    dissolveRate = 3.4,
    rangeRating = 40,
    dissolveRadius = 2.4,
    beamWidth = 2.2,
    pressurePitch = 1.8,
    holdDistance = 2.2,
    barrelRoll = 0,
    viewportRotation = identity,
    islandId = STARTER_ISLAND_ID
});
setmetatable(v18, nil);
v18.holdDistance = 4.5;
v18.barrelRoll = 4.71238898038469;
v18.viewportRotation = u1;
v18.islandId = "island2";
u15.obsidianWasher = v18;
local v19 = table.clone({
    displayName = "Opal Pressure Washer",
    assetName = "Opal Pressure Washer",
    cost = 2800000,
    dissolveRate = 3.7,
    rangeRating = 42,
    dissolveRadius = 2.52,
    beamWidth = 2.4,
    pressurePitch = 1.9,
    holdDistance = 2.2,
    barrelRoll = 0,
    viewportRotation = identity,
    islandId = STARTER_ISLAND_ID
});
setmetatable(v19, nil);
v19.holdDistance = 4.5;
v19.barrelRoll = 4.71238898038469;
v19.viewportRotation = u1;
v19.islandId = "island2";
u15.opalWasher = v19;
local v20 = table.clone({
    displayName = "Garnet Pressure Washer",
    assetName = "Garnet Pressure Washer",
    cost = 5200000,
    dissolveRate = 4.09,
    rangeRating = 44,
    dissolveRadius = 2.6399999999999997,
    beamWidth = 2.6,
    pressurePitch = 2,
    holdDistance = 2.2,
    barrelRoll = 0,
    viewportRotation = identity,
    islandId = STARTER_ISLAND_ID
});
setmetatable(v20, nil);
v20.holdDistance = 4.5;
v20.barrelRoll = 4.71238898038469;
v20.viewportRotation = u1;
v20.islandId = "island2";
u15.garnetWasher = v20;

return {
    CLEAN_AREA_EXPONENT = 0.5,
    CLEAN_REFERENCE_AREA = 6.7,
    DEFAULT_SPRAY_ID = "basic",

    isSprayBottleId = function(p21) -- Line: 54, Name: isSprayBottleId
        -- upvalues: u15 (copy)
        return u15[p21] ~= nil;
    end,

    SprayBottles = u15,
    SPRAY_TIER_ORDER = { "basic", "rubber", "plastic", "copper", "steel", "gold", "turquoise", "plasticWasher", "metalWasher", "obsidianWasher", "opalWasher", "garnetWasher" }
};