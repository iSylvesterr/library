-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local Detectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").Detectors;
local Shovels = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").Shovels;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local Items = v2.Items;
local UNDISCOVERABLE_ITEM_IDS = v2.UNDISCOVERABLE_ITEM_IDS;

local function _(p3) -- Line: 80
    -- upvalues: UNDISCOVERABLE_ITEM_IDS (copy)
    return UNDISCOVERABLE_ITEM_IDS[p3] == nil;
end;

local v4 = 0;
local u5 = {};

for i, v in v1.keys(Items) do
    local _ = i - 1;

    if UNDISCOVERABLE_ITEM_IDS[v] == nil == true then
        v4 = v4 + 1;
        u5[v4] = v;
    end;
end;

local function _(p6) -- Line: 95
    -- upvalues: Items (copy)
    return Items[p6].rarity == "legendary";
end;

local v7 = 0;
local u8 = {};

for i, v in u5 do
    local _ = i - 1;

    if Items[v].rarity == "legendary" == true then
        v7 = v7 + 1;
        u8[v7] = v;
    end;
end;

local u9 = table.create(#u8);

local function _(p10) -- Line: 109
    -- upvalues: Items (copy)
    return Items[p10].rollWeight;
end;

for i, v in u8 do
    local _ = i - 1;
    u9[i] = Items[v].rollWeight;
end;

local u11 = {
    common = 0,
    uncommon = 1,
    rare = 2,
    epic = 3,
    legendary = 4,
    mythic = 5,
    divine = 6,
    eternal = 7,
    transcendent = 8
};
local u12 = { "epic", "legendary", "mythic", "divine", "eternal", "transcendent" };
local u13 = { 100, 40, 8, 0.5, 0.03, 0.002 };
local u14 = {
    {
        minPower = 0,
        luck = 1,
        color = Color3.fromRGB(160, 170, 185)
    },
    {
        minPower = 0.4,
        luck = 2,
        color = Color3.fromRGB(48, 230, 98)
    },
    {
        minPower = 0.7,
        luck = 3,
        color = Color3.fromRGB(38, 168, 255)
    },
    {
        minPower = 0.97,
        luck = 5,
        color = Color3.fromRGB(255, 198, 28)
    }
};

local function pickWeighted(p15, p16) -- Line: 189
    local v17 = math.random();

    local function _(p18, p19) -- Line: 193
        return p18 + p19;
    end;

    local v20 = 0;

    for i = 1, #p16 do
        local _ = i - 1;
        v20 = v20 + p16[i];
    end;

    local v21 = v17 * v20;

    for i = 0, #p15 - 1 do
        v21 = v21 - p16[i + 1];

        if v21 <= 0 then
            return p15[i + 1];
        end;
    end;

    return p15[#p15];
end;

local u22 = {};

local function detectorPool(p23, p24) -- Line: 253
    -- upvalues: u22 (copy), Detectors (copy), u5 (copy), u11 (copy), Items (copy)
    local v25 = `{p23}:{p24}`;
    local v26 = u22[v25];

    if v26 ~= nil then
        return v26;
    end;

    local v27 = Detectors[p23];
    local junkFloor = v27.junkFloor;
    local v28 = v27.rarityBias * p24;
    local v29 = {};
    local v30 = {};

    for _, v in u5 do
        local v31 = u11[Items[v].rarity];
        table.insert(v29, v);
        local v32 = Items[v].rollWeight * math.pow(v28, v31 / 3.8);
        local v33 = math.max(0, junkFloor - v31);
        local v34 = v32 * math.pow(0.73, v33);
        table.insert(v30, v34);
    end;

    local v35 = {
        pool = v29,
        weights = v30
    };
    u22[v25] = v35;

    return v35;
end;

return {
    digRequirementFor = function(p36, p37) -- Line: 150, Name: digRequirementFor
        -- upvalues: Items (copy)
        if p37 == nil then
            p37 = Items[p36].averageKg;
        end;

        local v38 = Items[p36];
        local v39 = math.pow(p37 / v38.averageKg, 0.2);
        local v40 = math.clamp(v39, 0.9, 1.2);
        local v41 = math.pow(v38.displayOneIn, 0.3148) * 0.6519 * v40;

        return math.min(v41, 56);
    end,

    digDifficultyFor = function(p42, p43, p44, p45) -- Line: 158, Name: digDifficultyFor
        -- upvalues: Shovels (copy), Items (copy)
        local v46 = Shovels[p44].power * (p45 == nil and 1 or p45);

        if p43 == nil then
            p43 = Items[p42].averageKg;
        end;

        local v47 = Items[p42];
        local v48 = math.pow(p43 / v47.averageKg, 0.2);
        local v49 = math.clamp(v48, 0.9, 1.2);
        local v50 = math.pow(v47.displayOneIn, 0.3148) * 0.6519 * v49;
        local v51 = v46 / math.min(v50, 56);
        local v52 = {};
        local v53 = math.pow(v51, 0.45);
        v52.clickPower = math.clamp(v53, 0.08, 2.4) * 0.0129;
        local v54 = math.pow(v51, -1.8);
        v52.decay = math.clamp(v54, 0.7, 5) * 0.034;

        return v52;
    end,

    moundRadiusFor = function(p55) -- Line: 168, Name: moundRadiusFor
        local v56 = math.max(p55.X, p55.Z) * 0.68;

        return math.max(1.15, v56);
    end,

    digReachFor = function(p57) -- Line: 171, Name: digReachFor
        local v58 = math.max(p57.X, p57.Z) * 0.68;

        return math.max(1.15, v58) + 8;
    end,

    isDigImpossible = function(p59) -- Line: 174, Name: isDigImpossible
        return p59.decay / p59.clickPower >= 8;
    end,

    digPowerAt = function(p60) -- Line: 177, Name: digPowerAt
        local v61 = math.max(0, p60) / 0.55 * 3.141592653589793 * 2;

        return (1 - math.cos(v61)) * 0.5;
    end,

    digTierFor = function(p62) -- Line: 180, Name: digTierFor
        -- upvalues: u14 (copy)
        local v63 = u14[1];

        for _, v in u14 do
            if v.minPower <= p62 then
                v63 = v;
            end;
        end;

        return v63;
    end,

    rollSurfacedItem = function(u64, u65) -- Line: 209, Name: rollSurfacedItem
        -- upvalues: u12 (copy), u13 (copy), u11 (copy), pickWeighted (copy), Items (copy), u5 (copy)
        if u65 == nil then
            local v66 = table.create(#u12);

            local function _(p67, p68) -- Line: 214
                -- upvalues: u13 (ref), u64 (copy), u11 (ref)
                return u13[p68 + 1] * math.pow(u64, u11[p67] / 4);
            end;

            for i, v in u12 do
                v66[i] = u13[i - 1 + 1] * math.pow(u64, u11[v] / 4);
            end;

            u65 = pickWeighted(u12, v66);
        end;

        local function _(p69) -- Line: 226
            -- upvalues: Items (ref), u65 (copy)
            return Items[p69].rarity == u65;
        end;

        local v70 = 0;
        local v71 = {};

        for i, v in u5 do
            local _ = i - 1;

            if Items[v].rarity == u65 == true then
                v70 = v70 + 1;
                v71[v70] = v;
            end;
        end;

        local v72 = table.create(#v71);

        local function _(p73) -- Line: 240
            -- upvalues: Items (ref)
            return Items[p73].rollWeight;
        end;

        for i, v in v71 do
            local _ = i - 1;
            v72[i] = Items[v].rollWeight;
        end;

        return pickWeighted(v71, v72);
    end,

    rollLegendaryItem = function() -- Line: 249, Name: rollLegendaryItem
        -- upvalues: pickWeighted (copy), u8 (copy), u9 (copy)
        return pickWeighted(u8, u9);
    end,

    rollDetectorItem = function(p74, p75) -- Line: 279, Name: rollDetectorItem
        -- upvalues: detectorPool (copy), pickWeighted (copy)
        local v76 = detectorPool(p74, p75);

        return pickWeighted(v76.pool, v76.weights);
    end,

    rollDigItem = function(p77) -- Line: 283, Name: rollDigItem
        -- upvalues: u14 (copy), u5 (copy), Items (copy), u11 (copy), pickWeighted (copy)
        local v78 = math.clamp(p77, 0, 1);
        local v79 = u14[1];

        for _, v in u14 do
            if v.minPower <= v78 then
                v79 = v;
            end;
        end;

        local luck = v79.luck;
        local v80 = table.create(#u5);

        local function _(p81) -- Line: 287
            -- upvalues: Items (ref), luck (copy), u11 (ref)
            return Items[p81].rollWeight * math.pow(luck, u11[Items[p81].rarity] / 4);
        end;

        for i, v in u5 do
            local _ = i - 1;
            v80[i] = Items[v].rollWeight * math.pow(luck, u11[Items[v].rarity] / 4);
        end;

        return pickWeighted(u5, v80);
    end,

    DIG_REVEAL_SECONDS = 0.72,
    DIG_EXCLAMATION_ENABLED = false,
    DIG_POWER_BAR_ENABLED = false,
    DIG_SESSION_TIMEOUT = 45,
    DIG_POWER_PERIOD_SECONDS = 0.55,
    DIG_POWER_MIN_STOP_SECONDS = 0.12,
    DIG_POWER_MAX_SECONDS = 8,
    DIG_POWER_DEFAULT = 0.5,
    DIG_POWER_STOP_BACKDATE_LIMIT = 2,
    DIG_POWER_FUTURE_TOLERANCE = 0.25,
    DIG_PROGRESS_START = 0.33,
    DIG_LOSE_THRESHOLD = 0.0574,
    DIG_WIN_THRESHOLD = 0.985,
    DIG_CLICK_ENERGY_GAIN = 0.45,
    DIG_CLICK_ENERGY_DECAY = 1.25,
    DIG_INPUT_SEND_INTERVAL = 0.1,
    DIG_MAX_CLICKS_PER_SECOND = 50,
    DIG_MAX_CLICK_BURST = 30,
    DIG_EFFECTIVE_CLICKS_PER_SECOND = 11,
    DIG_EFFECTIVE_CLICK_BURST = 3,
    DIG_IMPOSSIBLE_CLICKS_PER_SECOND = 8,
    DIG_CLICK_GRACE = 2,
    DIG_BEGIN_COOLDOWN = 0.5,
    DIG_ATTEMPT_INTERVAL = 0.55,
    DIG_INTENT_WINDOW = 1.5,
    SURFACED_MAX_ACTIVE = 3,
    SURFACED_SPAWN_MIN_SECONDS = 240,
    SURFACED_SPAWN_MAX_SECONDS = 480,
    SURFACED_TEST_MODE = false,
    SURFACED_TEST_SPAWN_SECONDS = 5,
    MOUND_MIN_RADIUS = 1.15,
    MOUND_ITEM_RADIUS_FACTOR = 0.68,
    DIG_REACH = 8,
    BURIED_MIN_SEPARATION = 10,
    BURIED_SPAWN_PLACEMENT_TRIES = 8,
    BURIED_SEPARATION_TRIES = 6,
    BURIED_SPAWN_MIN_DISTANCE = 18,
    BURIED_SPAWN_MAX_DISTANCE = 60,
    BURIED_DESPAWN_DISTANCE = 85,
    BURIED_LIFETIME_MIN = 60,
    BURIED_LIFETIME_MAX = 120,
    BURIED_HOLD_SECONDS = 60,
    BURIED_SURFACE_SECONDS = 15,
    DIG_CLAIM_TOLERANCE = 4,
    DETECTOR_STREAM_INTERVAL = 0.4,
    GUARANTEED_MINT_DIG_INDEX = 2,
    GUARANTEED_MINT_MAX_ITEMS_CLEANED = 1,
    LEGENDARY_HOOK_TUTORIAL_DELAY = 60,
    LEGENDARY_HOOK_DETECT_SECONDS = 10,
    LEGENDARY_HOOK_AHEAD_LEAD = 6,
    LEGENDARY_HOOK_PLACEMENT_TRIES = 8,
    LEGENDARY_HOOK_VELOCITY_EPSILON = 1,
    LEGENDARY_HOOK_MOUND_CLEARANCE = 1.5,
    LEGENDARY_HOOK_ROLL_TRIES = 6,
    DIG_POWER_TIERS = u14
};