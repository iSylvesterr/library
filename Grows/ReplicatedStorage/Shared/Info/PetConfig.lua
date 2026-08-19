-- Decompiled with Potassium's decompiler.

local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local RARITIES = CustomEnum.RARITIES;
local u1 = {
    DefaultYawFlip = 1.5707963267948966,
    Pets = {
        Squirrel = {
            ability = "FindFruit",
            favFruit = "Acorn",
            trait = "Occasionally finds <font color=\"#1EFF00\">Common</font> fruit with random sizes and mutations",
            speedMult = 2,
            rig = "SquirrelRIG",
            idleAnim = 118400899786733,
            runAnim = 133116426193227,
            rarity = RARITIES.COMMON,
            fruitRarity = RARITIES.COMMON
        },
        Bunny = {
            ability = "FindFruit",
            favFruit = "Peach",
            trait = "Occasionally finds <font color=\"#0070DD\">Rare</font> fruit with random sizes and mutations",
            speedMult = 2,
            rig = "BunnyRIG",
            idleAnim = 74609031639530,
            runAnim = 129868111143087,
            rarity = RARITIES.COMMON,
            fruitRarity = RARITIES.RARE
        },
        Mouse = {
            ability = "FindFruit",
            favFruit = "Fig",
            trait = "Occasionally finds <font color=\"#A335EE\">Epic</font> fruit with random sizes and mutations",
            rig = "MouseRigged",
            idleAnim = 95938605517519,
            runAnim = 81899591950511,
            rarity = RARITIES.COMMON,
            fruitRarity = RARITIES.EPIC
        },
        Dog = {
            ability = "WeatherLuck",
            favFruit = "Mango",
            trait = "Increases the chance for fruits to mutate during weather events",
            base = 1.025,
            gain = 0.475,
            rig = "Dog RIG",
            idleAnim = 89174686003302,
            runAnim = 97932698349255,
            yawFlip = 3.141592653589793,
            rarity = RARITIES.RARE,
            baseCF = CFrame.Angles(-1.5707963267948966, 0, 0)
        },
        Cat = {
            ability = "FastGrow",
            favFruit = "Pizza",
            trait = "Fruits grow faster",
            base = 0.95,
            gain = -0.45,
            floor = 0.25,
            rig = "CatRIG",
            idleAnim = 121002231923673,
            runAnim = 135057307683756,
            rarity = RARITIES.RARE
        },
        Robin = {
            ability = "FindSeed",
            favFruit = "Pinecone",
            trait = "Occasionally finds seeds with a chance for random mutations",
            flying = true,
            speedMult = 2,
            base = 0.005,
            gain = 0.045,
            rig = "RobinRIG",
            idleAnim = 135492099530889,
            runAnim = 110149923278058,
            rarity = RARITIES.RARE
        },
        Chicken = {
            ability = "EggLevels",
            favFruit = "Magic Fruit",
            trait = "Pet eggs hatch at higher levels",
            base = 1,
            gain = 9,
            rig = "ChickenRIG",
            idleAnim = 113469890927680,
            runAnim = 90183271956052,
            rarity = RARITIES.RARE
        },
        Roach = {
            ability = "Mutator",
            mutation = "Infested",
            favFruit = "Lemon",
            trait = "Applies unique <font color=\"#825555\">Infested</font> mutation to fruits",
            base = 0.005,
            gain = 0.095,
            rig = "RoachRIG",
            idleAnim = 125115982965581,
            runAnim = 131356743278879,
            rarity = RARITIES.EPIC
        },
        Woodpecker = {
            ability = "Woodpecker",
            favFruit = "Glowing Fruit",
            trait = "Occasionally pecks a tree for a chance to drop its seed",
            flying = true,
            speedMult = 2,
            base = 0.05,
            gain = 0.2,
            rig = "WoodpeckerRIG",
            idleAnim = 93153960080406,
            runAnim = 96891791405637,
            peckAnim = 113138759084592,
            yawFlip = -1.5707963267948966,
            rarity = RARITIES.EPIC,
            baseCF = CFrame.Angles(-1.5707963267948966, 0, 0)
        },
        Cow = {
            ability = "Fertilizer",
            favFruit = "Starfruit",
            trait = "Improves fertilizers",
            base = 1.1,
            gain = 0.4,
            rig = "CowRIG",
            idleAnim = 130488595922150,
            runAnim = 114776685546837,
            rarity = RARITIES.EPIC
        },
        Sheep = {
            ability = "PetXp",
            favFruit = "Orange",
            trait = "Grants bonus XP to your other equipped pets",
            base = 1.05,
            gain = 0.45,
            rig = "SheepRIG",
            idleAnim = 123385644283713,
            runAnim = 113082499974243,
            rarity = RARITIES.EPIC
        },
        Pig = {
            ability = "Mutator",
            mutation = "Huge",
            favFruit = "Apple",
            trait = "Applies unique <font color=\"#FFB0C4\">HUGE</font> mutation to fruits",
            base = 0.1,
            gain = 0.15,
            baseMult = 2.5,
            baseMultGain = 2.5,
            maxMult = 5,
            maxMultGain = 5,
            rig = "PigRIG",
            idleAnim = 107576727710749,
            runAnim = 116736770973429,
            rarity = RARITIES.LEGENDARY
        },
        Raccoon = {
            ability = "FindFruit",
            favFruit = "Cherry",
            trait = "Occasionally finds <font color=\"#FF0000\">Legendary</font> fruit with random sizes and mutations",
            rig = "RaccoonRIG",
            idleAnim = 88272489998228,
            runAnim = 71224867658861,
            rarity = RARITIES.LEGENDARY,
            fruitRarity = RARITIES.LEGENDARY
        },
        Frog = {
            ability = "Mutator",
            mutation = "Slimy",
            favFruit = "Blooming Fruit",
            trait = "Applies unique <font color=\"#55ff7f\">Slimy</font> mutation to fruits",
            base = 0.005,
            gain = 0.095,
            rig = "FrogRIG",
            idleAnim = 94241718292351,
            runAnim = 91496835283685,
            rarity = RARITIES.LEGENDARY
        },
        Magpie = {
            ability = "FindEgg",
            favFruit = "Diamond",
            trait = "Occasionally finds pet eggs",
            flying = true,
            speedMult = 2,
            base = 0.1,
            gain = 0.4,
            rig = "MagpieRIG",
            idleAnim = 117729226872377,
            runAnim = 117486212386817,
            rarity = RARITIES.LEGENDARY
        },
        Turtle = {
            ability = "LightningWard",
            trait = "Small chance to negate lightning strike once during tree growth",
            base = 0.05,
            gain = 0.2,
            yawFlip = -1.5707963267948966,
            speedMult = 0.5,
            rig = "TurtleRIG",
            idleAnim = 102924797818921,
            runAnim = 131564023962672,
            rarity = RARITIES.LEGENDARY
        },
        Monkey = {
            ability = "FindFruit",
            favFruit = "Banana",
            trait = "Occasionally finds <font color=\"#FFD700\">Mythic</font> (or higher) fruit with random sizes and mutations",
            rig = "MonkeyRIG",
            idleAnim = 82294269204593,
            runAnim = 109260092663141,
            rarity = RARITIES.MYTHIC,
            fruitRarity = RARITIES.MYTHIC,
            rarityOdds = {
                {
                    weight = 85,
                    rarity = RARITIES.MYTHIC
                },
                {
                    weight = 10,
                    rarity = RARITIES.CELESTIAL
                },
                {
                    weight = 4.5,
                    rarity = RARITIES.SECRET
                },
                {
                    weight = 0.5,
                    rarity = RARITIES.DIVINE
                }
            }
        },
        Alligator = {
            ability = "PlantMutator",
            mutation = "Scaled",
            favFruit = "Dragon Fruit",
            trait = "Small chance to apply unique <font color=\"#27462d\">Scaled</font> mutation to seeds when planted",
            base = 0.0025,
            gain = 0.0475,
            rig = "AlligatorRIG",
            idleAnim = 105868930790567,
            runAnim = 97448004172467,
            rarity = RARITIES.MYTHIC
        }
    }
};

function u1.Scale(p2, p3, p4, p5) -- Line: 87
    -- upvalues: u1 (copy)
    local v6 = u1.Pets[p2];

    if not v6 then
        return 0;
    end;

    local v7 = v6[p4 or "base"];

    if v7 == nil then
        return 0;
    end;

    local v8 = math.clamp((p3 or 0) / u1.MaxLevel, 0, 1);
    local v9 = v7 + (v6[p5 or "gain"] or 0) * v8;

    if v6.floor then
        v9 = math.max(v9, v6.floor);
    end;

    return v9;
end;

u1.EggOrder = { "EggCommon", "EggRare", "EggEpic", "EggLegendary", "EggMythic" };
u1.Eggs = {
    EggCommon = {
        displayName = "Common",
        hatchSeconds = 600,
        price = 100,
        rarity = RARITIES.COMMON,
        pets = { {
                pet = "Squirrel",
                weight = 1
            }, {
                pet = "Bunny",
                weight = 1
            }, {
                pet = "Mouse",
                weight = 1
            } }
    },
    EggRare = {
        displayName = "Rare",
        hatchSeconds = 1200,
        price = 200,
        rarity = RARITIES.RARE,
        pets = { {
                pet = "Dog",
                weight = 1
            }, {
                pet = "Cat",
                weight = 1
            }, {
                pet = "Robin",
                weight = 1
            } }
    },
    EggEpic = {
        displayName = "Epic",
        hatchSeconds = 3600,
        price = 500,
        rarity = RARITIES.EPIC,
        pets = { {
                pet = "Chicken",
                weight = 50
            }, {
                pet = "Roach",
                weight = 25
            }, {
                pet = "Woodpecker",
                weight = 25
            } }
    },
    EggLegendary = {
        displayName = "Legendary",
        hatchSeconds = 7200,
        price = 1000,
        rarity = RARITIES.LEGENDARY,
        pets = { {
                pet = "Cow",
                weight = 35
            }, {
                pet = "Sheep",
                weight = 35
            }, {
                pet = "Pig",
                weight = 15
            }, {
                pet = "Raccoon",
                weight = 15
            } }
    },
    EggMythic = {
        displayName = "Mythic",
        hatchSeconds = 14400,
        price = 2000,
        rarity = RARITIES.MYTHIC,
        pets = { {
                pet = "Frog",
                weight = 28
            }, {
                pet = "Magpie",
                weight = 28
            }, {
                pet = "Turtle",
                weight = 28
            }, {
                pet = "Monkey",
                weight = 8
            }, {
                pet = "Alligator",
                weight = 8
            } }
    }
};
u1.MaxLevel = 100;
u1.XpPerSecond = 10;
u1.HungerDrainSeconds = 3600;
u1.MaxHungerByRarity = {
    [RARITIES.COMMON] = 50,
    [RARITIES.RARE] = 100,
    [RARITIES.EPIC] = 200,
    [RARITIES.LEGENDARY] = 400,
    [RARITIES.MYTHIC] = 800
};
u1.MinFruitHunger = 5;
u1.MaxFruitHunger = 50;
u1.FruitHungerScaling = 2;
u1.FruitHungerValueDivisor = 5;

function u1.FruitHunger(p10) -- Line: 153
    -- upvalues: u1 (copy)
    local v11 = tonumber(p10) or 0;
    local v12 = math.max(v11, 0);
    local v13 = u1.MinFruitHunger + u1.FruitHungerScaling * math.log10(1 + v12 / u1.FruitHungerValueDivisor);
    local v14 = math.clamp(v13, u1.MinFruitHunger, u1.MaxFruitHunger);

    return math.round(v14);
end;

function u1.GetPet(p15) -- Line: 160
    -- upvalues: u1 (copy)
    return u1.Pets[p15];
end;

function u1.GetMaxHunger(p16) -- Line: 164
    -- upvalues: u1 (copy), RARITIES (copy)
    local v17 = u1.Pets[p16];

    return v17 and u1.MaxHungerByRarity[v17.rarity] or u1.MaxHungerByRarity[RARITIES.COMMON];
end;

function u1.GetHungerDrainPerSecond(p18) -- Line: 169
    -- upvalues: u1 (copy)
    return u1.GetMaxHunger(p18) / u1.HungerDrainSeconds;
end;

function u1.GetXpRequired(p19) -- Line: 173
    return math.round(1.005 ^ p19 * 2400);
end;

u1.FindFruit = {
    baseInterval = 240,
    intervalFactor = 0.16666666666666666,
    baseSize = 5,
    sizeGain = 15,
    baseSizeMultChance = 0.1,
    sizeMultChanceGain = 0.15,
    baseMutateChance = 0.05,
    mutateChanceGain = 0.05,
    sizeMultOdds = { {
            mult = 1.5,
            weight = 70
        }, {
            mult = 2,
            weight = 25
        }, {
            mult = 5,
            weight = 4.5
        }, {
            mult = 10,
            weight = 0.5
        } },
    mutationOdds = { {
            key = "Dewy",
            weight = 65
        }, {
            key = "Shocked",
            weight = 25
        }, {
            key = "Radioactive",
            weight = 5
        }, {
            key = "Golden",
            weight = 4.5
        }, {
            key = "Cosmic",
            weight = 0.5
        } }
};

function u1.GetFindFruitStats(p20) -- Line: 191
    -- upvalues: u1 (copy)
    local FindFruit = u1.FindFruit;
    local v21 = math.clamp((p20 or 0) / u1.MaxLevel, 0, 1);

    return {
        interval = FindFruit.baseInterval * FindFruit.intervalFactor ^ v21,
        size = FindFruit.baseSize + FindFruit.sizeGain * v21,
        sizeMultChance = FindFruit.baseSizeMultChance + FindFruit.sizeMultChanceGain * v21,
        mutateChance = FindFruit.baseMutateChance + FindFruit.mutateChanceGain * v21
    };
end;

u1.MutatorInterval = 40;
u1.HugeRollBias = 2;
u1.FindEggInterval = 360;
u1.FlightHeight = 10;
u1.PeckInterval = 120;
u1.PeckDuration = 30;
u1.HatchLevelMultOdds = { {
        mult = 0.75,
        weight = 50
    }, {
        mult = 1.25,
        weight = 35
    }, {
        mult = 2,
        weight = 10
    }, {
        mult = 3.5,
        weight = 5
    } };
u1.FindEggRarityOdds = {
    {
        weight = 60,
        rarity = RARITIES.COMMON
    },
    {
        weight = 25,
        rarity = RARITIES.RARE
    },
    {
        weight = 12.5,
        rarity = RARITIES.EPIC
    },
    {
        weight = 2.25,
        rarity = RARITIES.LEGENDARY
    },
    {
        weight = 0.25,
        rarity = RARITIES.MYTHIC
    }
};

function u1.WeightedPick(p22, p23) -- Line: 227
    local v24 = 0;

    for _, v in p22 do
        v24 = v24 + (v.weight or 1);
    end;

    if v24 <= 0 then
        return p22[1];
    end;

    local v25 = (p23 and p23:NextNumber() or math.random()) * v24;

    for _, v in p22 do
        v25 = v25 - (v.weight or 1);

        if v25 <= 0 then
            return v;
        end;
    end;

    return p22[#p22];
end;

function u1.GetEggChances(p26) -- Line: 240
    -- upvalues: u1 (copy)
    local v27 = u1.Eggs[p26];

    if not v27 then
        return {};
    end;

    local v28 = 0;

    for _, v in v27.pets do
        v28 = v28 + (v.weight or 1);
    end;

    local v29 = {};

    for _, v in v27.pets do
        table.insert(v29, {
            pet = v.pet,
            chance = (v.weight or 1) / v28
        });
    end;

    return v29;
end;

local u30 = Color3.fromRGB(255, 204, 0);

local function tag(p31, p32) -- Line: 258
    return string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(p32.R * 255), math.round(p32.G * 255), math.round(p32.B * 255), p31);
end;

local function gold(p33) -- Line: 263
    -- upvalues: tag (copy), u30 (copy)
    return tag(p33, u30);
end;

local function trim(p34, p35) -- Line: 268
    local v36 = string.format("%." .. p35 .. "f", p34);

    if v36:find("%.") then
        v36 = v36:gsub("0+$", ""):gsub("%.$", "");
    end;

    return v36;
end;

local function pct(p37) -- Line: 274
    -- upvalues: gold (copy)
    local v38 = string.format("%." .. 1 .. "f", p37 * 100);

    if v38:find("%.") then
        v38 = v38:gsub("0+$", ""):gsub("%.$", "");
    end;

    return gold(v38 .. "%");
end;

local function mult(p39) -- Line: 278
    -- upvalues: gold (copy)
    local v40 = string.format("%." .. 2 .. "f", p39);

    if v40:find("%.") then
        v40 = v40:gsub("0+$", ""):gsub("%.$", "");
    end;

    return gold(v40 .. "x");
end;

local function secs(p41) -- Line: 282
    -- upvalues: gold (copy)
    if p41 < 60 then
        return gold(string.format("%ds", (math.round(p41))));
    end;

    local v42 = string.format("%." .. 1 .. "f", p41 / 60);

    if v42:find("%.") then
        v42 = v42:gsub("0+$", ""):gsub("%.$", "");
    end;

    return gold(v42 .. "min");
end;

local function rarityName(p43) -- Line: 287
    return p43:sub(1, 1) .. p43:sub(2):lower();
end;

local function rarityWord(p44) -- Line: 292
    local v45 = require(game.ReplicatedStorage.Shared.Info.Constants).RARITY_COLORS[p44];
    local v46 = p44:sub(1, 1) .. p44:sub(2):lower();

    if v45 then
        v46 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v45.R * 255), math.round(v45.G * 255), math.round(v45.B * 255), v46) or v46;
    end;

    return v46;
end;

local function mutationWord(p47) -- Line: 299
    local v48 = require(game.ReplicatedStorage.Shared.Info.MutationConfig).Mutations[p47];

    if not v48 then
        return p47;
    end;

    local v49;

    if v48.textColor then
        local displayName = v48.displayName;
        local textColor = v48.textColor;
        v49 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(textColor.R * 255), math.round(textColor.G * 255), math.round(textColor.B * 255), displayName) or v48.displayName;
    else
        v49 = v48.displayName;
    end;

    return v49;
end;

local function colourize(p50) -- Line: 307
    -- upvalues: CustomEnum (copy)
    local MutationConfig = require(game.ReplicatedStorage.Shared.Info.MutationConfig);

    for _, v in CustomEnum.RARITIES do
        local v51 = "%f[%a]" .. (v:sub(1, 1) .. v:sub(2):lower()) .. "%f[%A]";
        local v52 = require(game.ReplicatedStorage.Shared.Info.Constants).RARITY_COLORS[v];
        local v53 = v:sub(1, 1) .. v:sub(2):lower();

        if v52 then
            v53 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v52.R * 255), math.round(v52.G * 255), math.round(v52.B * 255), v53) or v53;
        end;

        p50 = p50:gsub(v51, v53);
    end;

    for i, v in MutationConfig.Mutations do
        local v54 = "%f[%a]" .. v.displayName .. "%f[%A]";
        local v55 = require(game.ReplicatedStorage.Shared.Info.MutationConfig).Mutations[i];

        if v55 then
            local i;

            if v55.textColor then
                local displayName = v55.displayName;
                local textColor = v55.textColor;
                i = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(textColor.R * 255), math.round(textColor.G * 255), math.round(textColor.B * 255), displayName) or v55.displayName;
            else
                i = v55.displayName;
            end;
        end;

        p50 = p50:gsub(v54, i);
    end;

    return p50;
end;

function u1.Describe(p56) -- Line: 318
    -- upvalues: u1 (copy), colourize (copy)
    local v57 = u1.Pets[p56];

    return v57 and colourize(v57.trait or "") or "";
end;

function u1.DescribeOwned(p58, p59) -- Line: 323
    -- upvalues: u1 (copy), CustomEnum (copy), u30 (copy), pct (copy), gold (copy), mult (copy)
    local v60 = u1.Pets[p58];

    if not v60 then
        return "";
    end;

    local v61 = p59 or 0;
    local ability = v60.ability;

    if ability == "FindFruit" then
        local v62 = u1.GetFindFruitStats(v61);
        local v63 = v60.fruitRarity or CustomEnum.RARITIES.COMMON;
        local v64 = require(game.ReplicatedStorage.Shared.Info.Constants).RARITY_COLORS[v63];
        local v65 = v63:sub(1, 1) .. v63:sub(2):lower();

        if v64 then
            v65 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v64.R * 255), math.round(v64.G * 255), math.round(v64.B * 255), v65) or v65;
        end;

        if v60.rarityOdds then
            v65 = v65 .. " (or better)";
        end;

        local format = string.format;
        local interval = v62.interval;
        local v66;

        if interval < 60 then
            local v67 = string.format("%ds", (math.round(interval)));
            local v68 = u30;
            v66 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v68.R * 255), math.round(v68.G * 255), math.round(v68.B * 255), v67);
        else
            local v69 = string.format("%." .. 1 .. "f", interval / 60);

            if v69:find("%.") then
                v69 = v69:gsub("0+$", ""):gsub("%.$", "");
            end;

            local v70 = u30;
            v66 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v70.R * 255), math.round(v70.G * 255), math.round(v70.B * 255), v69 .. "min");
        end;

        local v71 = (v63:sub(1, 1) .. v63:sub(2):lower()):match("^[AEIOU]") and "an" or "a";
        local v72 = string.format("%." .. 1 .. "f", v62.sizeMultChance * 100);

        if v72:find("%.") then
            v72 = v72:gsub("0+$", ""):gsub("%.$", "");
        end;

        local v73 = u30;

        return format("Every %s, finds %s %s fruit. %s chance to apply size mult and %s chance fruit is mutated", v66, v71, v65, string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v73.R * 255), math.round(v73.G * 255), math.round(v73.B * 255), v72 .. "%"), pct(v62.mutateChance));
    end;

    if ability == "FindSeed" then
        local v74 = u1.GetFindFruitStats(v61);
        local format = string.format;
        local interval = v74.interval;
        local v75;

        if interval < 60 then
            local v76 = string.format("%ds", (math.round(interval)));
            local v77 = u30;
            v75 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v77.R * 255), math.round(v77.G * 255), math.round(v77.B * 255), v76);
        else
            local v78 = string.format("%." .. 1 .. "f", interval / 60);

            if v78:find("%.") then
                v78 = v78:gsub("0+$", ""):gsub("%.$", "");
            end;

            local v79 = u30;
            v75 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v79.R * 255), math.round(v79.G * 255), math.round(v79.B * 255), v78 .. "min");
        end;

        local v80 = u1.Scale(p58, v61) * 100;
        local v81 = string.format("%." .. 1 .. "f", v80);

        if v81:find("%.") then
            v81 = v81:gsub("0+$", ""):gsub("%.$", "");
        end;

        local v82 = u30;

        return format("Every %s, finds a seed. %s chance seed is highest affordable tier and %s chance seed is mutated", v75, string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v82.R * 255), math.round(v82.G * 255), math.round(v82.B * 255), v81 .. "%"), pct(v74.mutateChance));
    end;

    if ability == "FindEgg" then
        local format = string.format;
        local FindEggInterval = u1.FindEggInterval;
        local v83;

        if FindEggInterval < 60 then
            local v84 = string.format("%ds", (math.round(FindEggInterval)));
            local v85 = u30;
            v83 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v85.R * 255), math.round(v85.G * 255), math.round(v85.B * 255), v84);
        else
            local v86 = string.format("%." .. 1 .. "f", FindEggInterval / 60);

            if v86:find("%.") then
                v86 = v86:gsub("0+$", ""):gsub("%.$", "");
            end;

            local v87 = u30;
            v83 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v87.R * 255), math.round(v87.G * 255), math.round(v87.B * 255), v86 .. "min");
        end;

        return format("Every %s, %s chance to find a random Pet Egg", v83, pct(u1.Scale(p58, v61)));
    end;

    if ability == "WeatherLuck" then
        return string.format("+%s chance for fruits to mutate during weather events", pct(u1.Scale(p58, v61) - 1));
    end;

    if ability == "FastGrow" then
        return string.format("Fruits grow %s faster", pct(1 - u1.Scale(p58, v61)));
    end;

    if ability == "EggLevels" then
        local v88 = u1.Scale(p58, v61);
        local v89 = (1 / 0);
        local v90 = (-1 / 0);

        for _, v in u1.HatchLevelMultOdds do
            v89 = math.min(v89, v.mult);
            v90 = math.max(v90, v.mult);
        end;

        local format = string.format;
        local v91 = math.floor(v88 * v89);
        local v92 = tostring(v91);
        local v93 = u30;
        local v94 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v93.R * 255), math.round(v93.G * 255), math.round(v93.B * 255), v92);
        local v95 = math.floor(v88 * v90);

        return format("Pet eggs hatch between Lv.%s and Lv.%s", v94, gold((tostring(v95))));
    end;

    if ability == "Fertilizer" then
        return string.format("Improves Fertilizers by %s", mult(u1.Scale(p58, v61)));
    end;

    if ability == "PetXp" then
        return string.format("Other pets gain +%s XP", pct(u1.Scale(p58, v61) - 1));
    end;

    if ability == "Woodpecker" then
        local format = string.format;
        local PeckInterval = u1.PeckInterval;
        local v96;

        if PeckInterval < 60 then
            local v97 = string.format("%ds", (math.round(PeckInterval)));
            local v98 = u30;
            v96 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v98.R * 255), math.round(v98.G * 255), math.round(v98.B * 255), v97);
        else
            local v99 = string.format("%." .. 1 .. "f", PeckInterval / 60);

            if v99:find("%.") then
                v99 = v99:gsub("0+$", ""):gsub("%.$", "");
            end;

            local v100 = u30;
            v96 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v100.R * 255), math.round(v100.G * 255), math.round(v100.B * 255), v99 .. "min");
        end;

        return format("Every %s, starts pecking a random tree and has a %s chance to drop the seed of that tree", v96, pct(u1.Scale(p58, v61)));
    end;

    if ability == "LightningWard" then
        return string.format("%s chance to negate lightning strike once per seed plant", pct(u1.Scale(p58, v61)));
    end;

    if ability == "Mutator" then
        local v101 = require(game.ReplicatedStorage.Shared.Info.MutationConfig).Mutations[v60.mutation];

        if v101 and v101.sizeMutation then
            local format = string.format;
            local MutatorInterval = u1.MutatorInterval;
            local v102;

            if MutatorInterval < 60 then
                local v103 = string.format("%ds", (math.round(MutatorInterval)));
                local v104 = u30;
                v102 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v104.R * 255), math.round(v104.G * 255), math.round(v104.B * 255), v103);
            else
                local v105 = string.format("%." .. 1 .. "f", MutatorInterval / 60);

                if v105:find("%.") then
                    v105 = v105:gsub("0+$", ""):gsub("%.$", "");
                end;

                local v106 = u30;
                v102 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v106.R * 255), math.round(v106.G * 255), math.round(v106.B * 255), v105 .. "min");
            end;

            local v107 = u1.Scale(p58, v61) * 100;
            local v108 = string.format("%." .. 1 .. "f", v107);

            if v108:find("%.") then
                v108 = v108:gsub("0+$", ""):gsub("%.$", "");
            end;

            local v109 = u30;
            local v110 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v109.R * 255), math.round(v109.G * 255), math.round(v109.B * 255), v108 .. "%");
            local mutation = v60.mutation;
            local v111 = require(game.ReplicatedStorage.Shared.Info.MutationConfig).Mutations[mutation];

            if v111 then
                if v111.textColor then
                    local displayName = v111.displayName;
                    local textColor = v111.textColor;
                    mutation = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(textColor.R * 255), math.round(textColor.G * 255), math.round(textColor.B * 255), displayName) or v111.displayName;
                else
                    mutation = v111.displayName;
                end;
            end;

            return format("Every %s, gives a random fruit a %s chance to become %s", v102, v110, mutation);
        end;

        local format = string.format;
        local v112 = u1.Scale(p58, v61) * 100;
        local v113 = string.format("%." .. 1 .. "f", v112);

        if v113:find("%.") then
            v113 = v113:gsub("0+$", ""):gsub("%.$", "");
        end;

        local v114 = u30;
        local v115 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v114.R * 255), math.round(v114.G * 255), math.round(v114.B * 255), v113 .. "%");
        local mutation = v60.mutation;
        local v116 = require(game.ReplicatedStorage.Shared.Info.MutationConfig).Mutations[mutation];

        if v116 then
            if v116.textColor then
                local displayName = v116.displayName;
                local textColor = v116.textColor;
                mutation = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(textColor.R * 255), math.round(textColor.G * 255), math.round(textColor.B * 255), displayName) or v116.displayName;
            else
                mutation = v116.displayName;
            end;
        end;

        return format("%s chance fruits get %s mutation", v115, mutation);
    end;

    if ability ~= "PlantMutator" then
        return u1.Describe(p58);
    end;

    local format = string.format;
    local v117 = u1.Scale(p58, v61) * 100;
    local v118 = string.format("%." .. 1 .. "f", v117);

    if v118:find("%.") then
        v118 = v118:gsub("0+$", ""):gsub("%.$", "");
    end;

    local v119 = u30;
    local v120 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(v119.R * 255), math.round(v119.G * 255), math.round(v119.B * 255), v118 .. "%");
    local mutation = v60.mutation;
    local v121 = require(game.ReplicatedStorage.Shared.Info.MutationConfig).Mutations[mutation];

    if v121 then
        if v121.textColor then
            local displayName = v121.displayName;
            local textColor = v121.textColor;
            mutation = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(textColor.R * 255), math.round(textColor.G * 255), math.round(textColor.B * 255), displayName) or v121.displayName;
        else
            mutation = v121.displayName;
        end;
    end;

    return format("%s chance to apply %s mutation to seeds when planted", v120, mutation);
end;

u1.PetNames = { "Bella", "Charlie", "Daisy", "Buddy", "Rosie", "Ollie", "Penny", "Max", "Coco", "Milo", "Maple", "Clover", "Poppy", "Sunny", "Biscuit", "Buttercup", "Pumpkin", "Honey", "Peaches", "Apple", "Hazel", "Willow", "Juniper", "River", "Fern", "Moss", "Birch", "Oakley", "Acorn", "Chestnut", "Bean", "Sprout", "Nugget", "Pickles", "Muffin", "Waffles", "Toffee", "Peanut", "Cookie", "Marshmallow", "Cinnamon", "Pepper", "Ginger", "Olive", "Basil", "Sage", "Parsley", "Thyme", "Blossom", "Bluebell", "Butter", "Butterbean", "Lucky", "Scout", "Bandit", "Boots", "Socks", "Patch", "Spot", "Freckles", "Pebbles", "Rocky", "Dusty", "Rusty", "Copper", "Amber", "Goldie", "Skippy", "Bubbles", "Chirpy", "Pip", "Twig", "Leaf", "Petal", "Dewey", "Berry", "Cherry", "Kiwi", "Mango", "Fig", "Lemon", "Mochi", "Tater", "Lulu", "Archie", "Benny", "Toby", "Lucy", "Ruby", "Sadie", "Winnie", "Finn", "Theo", "Louie", "Bonnie", "Dixie", "Millie", "Echo", "Blue", "Snowball" };

function u1.RandomName(p122) -- Line: 415
    -- upvalues: u1 (copy)
    local PetNames = u1.PetNames;

    return PetNames[p122 and p122:NextInteger(1, #PetNames) or math.random(1, #PetNames)];
end;

u1.DefaultPetSlots = 3;
u1.DefaultEggSlots = 3;
u1.MaxPetSlots = 10;
u1.MaxEggSlots = (1 / 0);
u1.VipPetSlots = 2;

function u1.CanBuySlot(p123, p124) -- Line: 432
    return (p123 or 0) < p124;
end;

function u1.EffectivePetSlots(p125, p126) -- Line: 437
    -- upvalues: u1 (copy)
    return (p125 or u1.DefaultPetSlots) + (p126 and u1.VipPetSlots or 0);
end;

return u1;