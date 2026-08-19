-- Decompiled with Potassium's decompiler.

local Conditions = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Conditions").Conditions;
local u1 = { "common", "uncommon", "rare", "epic", "legendary", "mythic", "divine", "eternal", "transcendent" };
local u2 = {
    duck = {
        displayName = "Duck",
        rarity = "uncommon",
        displayOneIn = 22,
        rollWeight = 909091,
        averageKg = 2,
        minKg = 0.5,
        maxKg = 12
    },
    bear = {
        displayName = "Bear",
        rarity = "uncommon",
        displayOneIn = 34,
        rollWeight = 588235,
        averageKg = 4,
        minKg = 1,
        maxKg = 24,
        viewYaw = 180
    },
    toilet = {
        displayName = "Toilet",
        rarity = "rare",
        displayOneIn = 465,
        rollWeight = 43011,
        averageKg = 35,
        minKg = 12,
        maxKg = 210
    },
    goldStatue = {
        displayName = "Gold Statue",
        rarity = "legendary",
        displayOneIn = 29000,
        rollWeight = 690,
        averageKg = 50,
        minKg = 10,
        maxKg = 300,
        viewYaw = 175
    },
    rustyCan = {
        displayName = "Rusty Can",
        rarity = "common",
        displayOneIn = 2,
        rollWeight = 10000000,
        averageKg = 0.3,
        minKg = 0.1,
        maxKg = 2
    },
    oldBoot = {
        displayName = "Old Boot",
        rarity = "common",
        displayOneIn = 3,
        rollWeight = 6666667,
        averageKg = 0.8,
        minKg = 0.2,
        maxKg = 5,
        displayRotation = { -90, 0, 0 }
    },
    glassBottle = {
        displayName = "Glass Bottle",
        rarity = "common",
        displayOneIn = 5,
        rollWeight = 4000000,
        averageKg = 0.5,
        minKg = 0.15,
        maxKg = 3
    },
    bone = {
        displayName = "Bone",
        rarity = "uncommon",
        displayOneIn = 52,
        rollWeight = 384615,
        averageKg = 2,
        minKg = 0.5,
        maxKg = 12
    },
    bowlingBall = {
        displayName = "Bowling Ball",
        rarity = "rare",
        displayOneIn = 260,
        rollWeight = 76923,
        averageKg = 6,
        minKg = 3,
        maxKg = 16
    },
    sword = {
        displayName = "Sword",
        rarity = "rare",
        displayOneIn = 1100,
        rollWeight = 18182,
        averageKg = 4,
        minKg = 1.5,
        maxKg = 24
    },
    anchor = {
        displayName = "Anchor",
        rarity = "epic",
        displayOneIn = 2950,
        rollWeight = 6780,
        averageKg = 60,
        minKg = 20,
        maxKg = 360
    },
    knightsHelmet = {
        displayName = "Knights Helmet",
        rarity = "epic",
        displayOneIn = 7550,
        rollWeight = 2649,
        averageKg = 5,
        minKg = 1.5,
        maxKg = 30,
        viewYaw = 90
    },
    dinoEgg = {
        displayName = "Dino Egg",
        rarity = "legendary",
        displayOneIn = 56500,
        rollWeight = 354,
        averageKg = 12,
        minKg = 4,
        maxKg = 72,
        viewYaw = 85
    },
    piano = {
        displayName = "Piano",
        rarity = "mythic",
        displayOneIn = 145000,
        rollWeight = 138,
        averageKg = 180,
        minKg = 60,
        maxKg = 1080,
        holdOverhead = true,
        viewYaw = 180
    },
    diamond = {
        displayName = "Diamond",
        rarity = "mythic",
        displayOneIn = 245000,
        rollWeight = 82,
        averageKg = 1,
        minKg = 0.3,
        maxKg = 6
    },
    dinoSkull = {
        displayName = "Dino Skull",
        rarity = "divine",
        displayOneIn = 425000,
        rollWeight = 47,
        averageKg = 200,
        minKg = 70,
        maxKg = 1200,
        holdOverhead = true,
        displayRotation = { 90, 0, -90 }
    },
    spoon = {
        displayName = "Spoon",
        rarity = "common",
        displayOneIn = 7,
        rollWeight = 2857143,
        averageKg = 0.15,
        minKg = 0.05,
        maxKg = 0.9
    },
    sunglasses = {
        displayName = "Sunglasses",
        rarity = "common",
        displayOneIn = 9,
        rollWeight = 2222222,
        averageKg = 0.2,
        minKg = 0.06,
        maxKg = 1.2,
        viewYaw = 180,
        viewZoom = 0.95
    },
    flipFlop = {
        displayName = "Flip Flop",
        rarity = "common",
        displayOneIn = 11,
        rollWeight = 1818182,
        averageKg = 0.4,
        minKg = 0.12,
        maxKg = 2.4,
        viewYaw = 180,
        displayRotation = { -90, 0, 0 }
    },
    newspaperHat = {
        displayName = "Newspaper Hat",
        rarity = "common",
        displayOneIn = 15,
        rollWeight = 1333333,
        averageKg = 0.25,
        minKg = 0.08,
        maxKg = 1.5,
        viewZoom = 1.2
    },
    bucket = {
        displayName = "Bucket",
        rarity = "uncommon",
        displayOneIn = 77,
        rollWeight = 259740,
        averageKg = 1.5,
        minKg = 0.5,
        maxKg = 9
    },
    messageInABottle = {
        displayName = "Message in a Bottle",
        rarity = "uncommon",
        displayOneIn = 115,
        rollWeight = 173913,
        averageKg = 0.7,
        minKg = 0.2,
        maxKg = 4,
        displayRotation = { 0, 0, -90 }
    },
    flipPhone = {
        displayName = "Flip Phone",
        rarity = "uncommon",
        displayOneIn = 170,
        rollWeight = 117647,
        averageKg = 0.3,
        minKg = 0.1,
        maxKg = 1.8,
        viewYaw = 90,
        displayRotation = { 0, 0, -90 }
    },
    beachBall = {
        displayName = "Beach Ball",
        rarity = "rare",
        displayOneIn = 350,
        rollWeight = 57143,
        averageKg = 1.2,
        minKg = 0.4,
        maxKg = 7,
        viewZoom = 1.35
    },
    pocketWatch = {
        displayName = "Pocket Watch",
        rarity = "rare",
        displayOneIn = 625,
        rollWeight = 32000,
        averageKg = 0.3,
        minKg = 0.1,
        maxKg = 1.8,
        viewYaw = 180,
        viewZoom = 1.1
    },
    vase = {
        displayName = "Vase",
        rarity = "rare",
        displayOneIn = 835,
        rollWeight = 23952,
        averageKg = 4,
        minKg = 1.2,
        maxKg = 24,
        viewZoom = 1.1
    },
    umbrella = {
        displayName = "Umbrella",
        rarity = "rare",
        displayOneIn = 1450,
        rollWeight = 13793,
        averageKg = 3,
        minKg = 1,
        maxKg = 18,
        viewZoom = 1.3
    },
    recordPlayer = {
        displayName = "Record Player",
        rarity = "rare",
        displayOneIn = 1950,
        rollWeight = 10256,
        averageKg = 12,
        minKg = 4,
        maxKg = 72,
        viewYaw = 180,
        viewZoom = 1.25
    },
    crab = {
        displayName = "Crab",
        rarity = "epic",
        displayOneIn = 4000,
        rollWeight = 5000,
        averageKg = 3,
        minKg = 1,
        maxKg = 18
    },
    fireHydrant = {
        displayName = "Fire Hydrant",
        rarity = "epic",
        displayOneIn = 5450,
        rollWeight = 3670,
        averageKg = 80,
        minKg = 25,
        maxKg = 480,
        viewZoom = 1.12
    },
    guitar = {
        displayName = "Guitar",
        rarity = "epic",
        displayOneIn = 10000,
        rollWeight = 2000,
        averageKg = 4,
        minKg = 1.5,
        maxKg = 24,
        viewYaw = 180
    },
    chest = {
        displayName = "Chest",
        rarity = "epic",
        displayOneIn = 14000,
        rollWeight = 1429,
        averageKg = 45,
        minKg = 15,
        maxKg = 270
    },
    bicycle = {
        displayName = "Bicycle",
        rarity = "epic",
        displayOneIn = 18500,
        rollWeight = 1081,
        averageKg = 14,
        minKg = 5,
        maxKg = 84
    },
    axe = {
        displayName = "Axe",
        rarity = "legendary",
        displayOneIn = 41000,
        rollWeight = 488,
        averageKg = 3.5,
        minKg = 1.2,
        maxKg = 21
    },
    crown = {
        displayName = "Crown",
        rarity = "legendary",
        displayOneIn = 79500,
        rollWeight = 252,
        averageKg = 2,
        minKg = 0.6,
        maxKg = 12,
        viewZoom = 1.12
    },
    palmTree = {
        displayName = "Palm Tree",
        rarity = "legendary",
        displayOneIn = 105000,
        rollWeight = 190,
        averageKg = 250,
        minKg = 80,
        maxKg = 1500,
        holdOverhead = true
    },
    ruby = {
        displayName = "Ruby",
        rarity = "mythic",
        displayOneIn = 190000,
        rollWeight = 105,
        averageKg = 1.2,
        minKg = 0.4,
        maxKg = 7,
        viewZoom = 1.22
    },
    pharaohsMask = {
        displayName = "Pharaohs Mask",
        rarity = "mythic",
        displayOneIn = 320000,
        rollWeight = 63,
        averageKg = 15,
        minKg = 5,
        maxKg = 90,
        viewYaw = 180,
        viewZoom = 1.12
    },
    moaiHead = {
        displayName = "Moai Head",
        rarity = "divine",
        displayOneIn = 1050000,
        rollWeight = 19,
        averageKg = 900,
        minKg = 300,
        maxKg = 5400,
        holdOverhead = true,
        viewYaw = 90,
        viewZoom = 1.15
    },
    frozenMammoth = {
        displayName = "Frozen Mammoth",
        rarity = "divine",
        displayOneIn = 6650000,
        rollWeight = 3,
        averageKg = 4000,
        minKg = 1300,
        maxKg = 24000,
        holdOverhead = true
    },
    angelDuck = {
        displayName = "Angel Duck",
        rarity = "mythic",
        displayOneIn = 165000,
        rollWeight = 121.21,
        averageKg = 3,
        minKg = 1,
        maxKg = 18,
        viewYaw = 180
    },
    shipWheel = {
        displayName = "Ship Wheel",
        rarity = "mythic",
        displayOneIn = 215000,
        rollWeight = 93.02,
        averageKg = 25,
        minKg = 8,
        maxKg = 150
    },
    midnightDiamond = {
        displayName = "Midnight Diamond",
        rarity = "mythic",
        displayOneIn = 285000,
        rollWeight = 70.18,
        averageKg = 1.5,
        minKg = 0.5,
        maxKg = 9
    },
    goldBars = {
        displayName = "Gold Bars",
        rarity = "divine",
        displayOneIn = 520000,
        rollWeight = 38.46,
        averageKg = 120,
        minKg = 40,
        maxKg = 720
    },
    emerald = {
        displayName = "Emerald",
        rarity = "divine",
        displayOneIn = 760000,
        rollWeight = 26.32,
        averageKg = 1.8,
        minKg = 0.6,
        maxKg = 11
    },
    oldTank = {
        displayName = "Old Tank",
        rarity = "divine",
        displayOneIn = 1400000,
        rollWeight = 14.29,
        averageKg = 30000,
        minKg = 10000,
        maxKg = 180000,
        holdOverhead = true
    },
    crashedHelicopter = {
        displayName = "Crashed Helicopter",
        rarity = "divine",
        displayOneIn = 2300000,
        rollWeight = 8.7,
        averageKg = 5000,
        minKg = 1600,
        maxKg = 30000,
        holdOverhead = true
    },
    nuke = {
        displayName = "Nuke",
        rarity = "eternal",
        displayOneIn = 9000000,
        rollWeight = 0.074128,
        averageKg = 4500,
        minKg = 1500,
        maxKg = 27000
    },
    giantSquid = {
        displayName = "Giant Squid",
        rarity = "eternal",
        displayOneIn = 13000000,
        rollWeight = 0.049419,
        averageKg = 900,
        minKg = 300,
        maxKg = 5400,
        holdOverhead = true,
        viewYaw = 180
    },
    poseidonsTrident = {
        displayName = "Poseidons Trident",
        rarity = "eternal",
        displayOneIn = 18000000,
        rollWeight = 0.031769,
        averageKg = 40,
        minKg = 13,
        maxKg = 240
    },
    ufo = {
        displayName = "UFO",
        rarity = "eternal",
        displayOneIn = 26000000,
        rollWeight = 0.020217,
        averageKg = 3500,
        minKg = 1200,
        maxKg = 21000,
        holdOverhead = true
    },
    tRexSkeleton = {
        displayName = "T-Rex Skeleton",
        rarity = "eternal",
        displayOneIn = 40000000,
        rollWeight = 0.012708,
        averageKg = 2500,
        minKg = 800,
        maxKg = 15000,
        holdOverhead = true
    },
    krakensEye = {
        displayName = "Krakens Eye",
        rarity = "transcendent",
        displayOneIn = 90000000,
        rollWeight = 0.001273,
        averageKg = 350,
        minKg = 120,
        maxKg = 2100,
        holdOverhead = true,
        viewYaw = 90
    },
    leviathanSkull = {
        displayName = "Leviathan Skull",
        rarity = "transcendent",
        displayOneIn = 150000000,
        rollWeight = 0.000594,
        averageKg = 6000,
        minKg = 2000,
        maxKg = 36000,
        holdOverhead = true,
        viewYaw = 180
    },
    monaLisa = {
        displayName = "Mona Lisa",
        rarity = "transcendent",
        displayOneIn = 500000000,
        rollWeight = 0.000223,
        averageKg = 12,
        minKg = 4,
        maxKg = 72,
        viewYaw = 180
    }
};

return {
    MAX_ITEM_SPAN = 20,
    UNKNOWN_ITEM_NAME = "???",

    isItemId = function(p3) -- Line: 550, Name: isItemId
        -- upvalues: u2 (copy)
        return u2[p3] ~= nil;
    end,

    isItemRarity = function(u4) -- Line: 553, Name: isItemRarity
        -- upvalues: u1 (copy)
        local function _(p5) -- Line: 556
            -- upvalues: u4 (copy)
            return p5 == u4;
        end;

        for i, v in u1 do
            local _ = i - 1;

            if v == u4 then
                return true;
            end;
        end;

        return false;
    end,

    rollItemWeight = function(p6) -- Line: 568, Name: rollItemWeight
        -- upvalues: u2 (copy)
        local v7 = u2[p6];
        local v8 = math.random();
        local v9;

        if v8 < 0.005 then
            v9 = 4 + math.random() * 2;
        elseif v8 < 0.035 then
            v9 = 2.5 + math.random() * 1.5;
        elseif v8 < 0.155 then
            v9 = 1.4 + math.random() * 1.1;
        else
            v9 = 0.8 + math.random() * 0.6;
        end;

        local v10 = math.clamp(v7.averageKg * v9, v7.minKg, v7.maxKg) * 10;

        return math.round(v10) / 10;
    end,

    weightRarityMultiplierFor = function(p11, p12) -- Line: 584, Name: weightRarityMultiplierFor
        -- upvalues: u2 (copy)
        local v13 = p12 / u2[p11].averageKg;

        return v13 <= 1 and 1 or math.pow(v13, 1.3446);
    end,

    itemScaleForWeight = function(p14, p15) -- Line: 589, Name: itemScaleForWeight
        -- upvalues: u2 (copy)
        local v16 = math.pow(p15 / u2[p14].averageKg, 0.38);

        return math.clamp(v16, 0.65, 2);
    end,

    baseOneIn = function(p17, p18) -- Line: 592, Name: baseOneIn
        -- upvalues: u2 (copy)
        if p18 == nil then
            p18 = u2[p17].averageKg;
        end;

        local v19 = p18 / u2[p17].averageKg;

        return u2[p17].displayOneIn * (v19 <= 1 and 1 or math.pow(v19, 1.3446));
    end,

    effectiveOneIn = function(p20, p21, p22) -- Line: 598, Name: effectiveOneIn
        -- upvalues: u2 (copy), Conditions (copy)
        if p22 == nil then
            p22 = u2[p20].averageKg;
        end;

        if p22 == nil then
            p22 = u2[p20].averageKg;
        end;

        local displayOneIn = u2[p20].displayOneIn;
        local v23 = p22 / u2[p20].averageKg;
        local v24 = v23 <= 1 and 1 or math.pow(v23, 1.3446);

        return math.round(displayOneIn * v24 * Conditions[p21].rarityMultiplier);
    end,

    formatKg = function(p25) -- Line: 606, Name: formatKg
        local v26 = math.round(p25 * 10) / 10;

        if v26 % 1 == 0 then
            return `{v26}`;
        end;

        return string.format("%.1f", v26);
    end,

    itemNameFor = function(p27, p28) -- Line: 610, Name: itemNameFor
        -- upvalues: u2 (copy)
        local displayName = u2[p27].displayName;
        local v29 = math.round(p28 * 10) / 10;
        local v30;

        if v29 % 1 == 0 then
            v30 = `{v29}`;
        else
            v30 = string.format("%.1f", v29);
        end;

        return `{displayName} ({v30} KG)`;
    end,

    unknownItemNameFor = function(p31, p32) -- Line: 615, Name: unknownItemNameFor
        -- upvalues: u2 (copy)
        local rarity = u2[p31].rarity;
        local v33 = math.round(p32 * 10) / 10;
        local v34;

        if v33 % 1 == 0 then
            v34 = `{v33}`;
        else
            v34 = string.format("%.1f", v33);
        end;

        return `???#{rarity} ({v34} KG)`;
    end,

    unknownRarityFrom = function(p35) -- Line: 618, Name: unknownRarityFrom
        -- upvalues: u1 (copy)
        local u36 = string.match(p35, "^%?%?%?#(%a+)$");

        local function _(p37) -- Line: 621
            -- upvalues: u36 (copy)
            return p37 == u36;
        end;

        for i, v in u1 do
            local _ = i - 1;

            if v == u36 == true then
                return v;
            end;
        end;

        return nil;
    end,

    itemValueFor = function(p38, p39, p40) -- Line: 634, Name: itemValueFor
        -- upvalues: u2 (copy), Conditions (copy)
        if p40 == nil then
            p40 = u2[p38].averageKg;
        end;

        if p40 == nil then
            p40 = u2[p38].averageKg;
        end;

        if p40 == nil then
            p40 = u2[p38].averageKg;
        end;

        local displayOneIn = u2[p38].displayOneIn;
        local v41 = p40 / u2[p38].averageKg;
        local v42 = v41 <= 1 and 1 or math.pow(v41, 1.3446);
        local v43 = math.round(displayOneIn * v42 * Conditions[p39].rarityMultiplier);
        local v44 = math.pow(v43, 0.7) * 44.95;

        return math.floor(v44);
    end,

    dirtyItemValueFor = function(p45, p46) -- Line: 642, Name: dirtyItemValueFor
        -- upvalues: u2 (copy)
        if p46 == nil then
            p46 = u2[p45].averageKg;
        end;

        if p46 == nil then
            p46 = u2[p45].averageKg;
        end;

        local displayOneIn = u2[p45].displayOneIn;
        local v47 = p46 / u2[p45].averageKg;
        local v48 = v47 <= 1 and 1 or math.pow(v47, 1.3446);
        local v49 = math.pow(displayOneIn * v48, 0.7) * 44.95 / 10;
        local v50 = math.floor(v49);

        return math.max(1, v50);
    end,

    RARITY_ORDER = u1,
    Items = u2,
    UNDISCOVERABLE_ITEM_IDS = {}
};