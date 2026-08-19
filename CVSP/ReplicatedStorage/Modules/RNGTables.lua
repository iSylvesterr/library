-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = Random.new();

local function getEffectiveLuck(p3) -- Line: 4
    local v4 = (math.clamp(p3 or 1, 1, 15) - 1) / 9;

    if v4 <= 1 then
        v4 = v4 + v4 * 1 * (v4 - 0.16666666666666666) * (1 - v4);
    end;

    return 1 + v4 * 2.75;
end;

local function weightedRoll(p5, p6) -- Line: 28
    -- upvalues: u2 (copy)
    local v7 = p6 or 1;
    local v8 = {};
    local v9 = 0;

    for i, v in ipairs(p5) do
        local v10 = v.luckPower or 0;
        local v11 = v.weight * v7 ^ (v10 <= 3 and v10 and v10 or 3 + (v10 - 3) * 0.65);
        v8[i] = v11;
        v9 = v9 + v11;
    end;

    local v12 = u2:NextNumber(0, v9);
    local v13 = 0;

    for i, v in ipairs(p5) do
        v13 = v13 + v8[i];

        if v12 <= v13 then
            return v;
        end;
    end;

    return p5[1];
end;

local u14 = { {
        weight = 66,
        luckPower = 0,
        min = 1,
        max = 1
    }, {
        weight = 24,
        luckPower = 0.1,
        min = 1,
        max = 1.5
    }, {
        weight = 7.35,
        luckPower = 0.25,
        min = 1.5,
        max = 2
    }, {
        weight = 2.25,
        luckPower = 0.5,
        min = 2,
        max = 3
    }, {
        weight = 0.35,
        luckPower = 0.75,
        min = 3,
        max = 4
    }, {
        weight = 0.05,
        luckPower = 1,
        min = 6,
        max = 10
    } };

function v1.getRandomSize(p15) -- Line: 78
    -- upvalues: weightedRoll (copy), u14 (copy), u2 (copy)
    local v16 = weightedRoll(u14, p15);
    local v17 = v16.min == v16.max and v16.min or u2:NextNumber(v16.min, v16.max);

    return math.round(v17 * 10) / 10;
end;

local u18 = { {
        result = "Common",
        weight = 62.5,
        luckPower = 0
    }, {
        result = "Rare",
        weight = 22.5,
        luckPower = 0.5
    }, {
        result = "Epic",
        weight = 10.9,
        luckPower = 0.75
    }, {
        result = "Legendary",
        weight = 3,
        luckPower = 0.75
    }, {
        result = "Mythic",
        weight = 0.9345,
        luckPower = 1
    }, {
        result = "Divine",
        weight = 0.15,
        luckPower = 1.25
    }, {
        result = "Godly",
        weight = 0.03,
        luckPower = 1.5
    }, {
        result = "Secret",
        weight = 0.0045,
        luckPower = 1.75
    } };

function v1.getRandomPlantRarity(p19) -- Line: 103
    -- upvalues: weightedRoll (copy), u18 (copy)
    return weightedRoll(u18, p19).result;
end;

local u20 = {
    Common = { {
            result = "Carrot",
            weight = 60
        }, {
            result = "Potato",
            weight = 40
        } },
    Rare = { {
            result = "Orange Tulip",
            weight = 60
        }, {
            result = "Broccoli",
            weight = 40
        } },
    Epic = { {
            result = "Tomato",
            weight = 60
        }, {
            result = "Sunflower",
            weight = 40
        } },
    Legendary = { {
            result = "Garlic",
            weight = 60
        }, {
            result = "Watermelon",
            weight = 40
        } },
    Mythic = { {
            result = "Cocotree",
            weight = 60
        }, {
            result = "Fancy Avocado",
            weight = 40
        } },
    Divine = { {
            result = "Mandrake",
            weight = 60
        }, {
            result = "Carnivorous Plant",
            weight = 40
        } },
    Godly = { {
            result = "Ghost Pepper",
            weight = 60
        }, {
            result = "Magic Mushroom",
            weight = 40
        } },
    Secret = { {
            result = "Pumpking",
            weight = 55
        }, {
            result = "True Carrot",
            weight = 37.5
        }, {
            result = "Dragonfruit",
            weight = 7.5
        } }
};

function v1.getPlantFromRarity(p21, p22) -- Line: 153
    -- upvalues: u20 (copy), weightedRoll (copy)
    local v23 = u20[p22];

    if v23 then
        return weightedRoll(v23, 1).result;
    end;

    return nil;
end;

local u24 = {
    Plant = { {
            result = "",
            weight = 97.4,
            luckPower = 0
        }, {
            result = "Gold",
            weight = 2,
            luckPower = 0.25
        }, {
            result = "Rainbow",
            weight = 0.5,
            luckPower = 0.5
        }, {
            result = "Radiant",
            weight = 0.1,
            luckPower = 0.75
        } },
    Egg = { {
            result = "",
            weight = 96.9,
            luckPower = 0
        }, {
            result = "Gold",
            weight = 3,
            luckPower = 0.25
        }, {
            result = "Rainbow",
            weight = 0.75,
            luckPower = 0.5
        }, {
            result = "Radiant",
            weight = 0.15,
            luckPower = 0.75
        } }
};

function v1.getRandomVariant(p25, p26) -- Line: 178
    -- upvalues: u24 (copy), weightedRoll (copy)
    local v27 = u24[p26];

    return not v27 and "" or weightedRoll(v27, p25).result;
end;

local u28 = {
    ["King Mystery Egg"] = { {
            result = "Baby Prince Capybara",
            weight = 62,
            luckPower = 0
        }, {
            result = "Royal Mage Capybara",
            weight = 27,
            luckPower = 0
        }, {
            result = "Fallen King Capybara",
            weight = 9,
            luckPower = 0
        }, {
            result = "Jester Capybara",
            weight = 2,
            luckPower = 0
        } },
    ["Void Mystery Egg"] = { {
            result = "Sinister Capybara",
            weight = 62,
            luckPower = 0
        }, {
            result = "Obsidian Capybara",
            weight = 28,
            luckPower = 0
        }, {
            result = "Soul Fist Capybara",
            weight = 8.5,
            luckPower = 0
        }, {
            result = "Void Maw Capybara",
            weight = 1.5,
            luckPower = 0
        } }
};

function v1.getTowerFromMysteryEgg(p29) -- Line: 200
    -- upvalues: u28 (copy), weightedRoll (copy)
    local v30 = u28[p29];

    return not v30 and "" or weightedRoll(v30, 1).result;
end;

function v1.runSimulation(p31, p32, p33, p34) -- Line: 210
    -- upvalues: weightedRoll (copy)
    local v35 = {};

    for _, v in ipairs(p31) do
        v35[v.result or tostring(v.min) .. "-" .. tostring(v.max)] = 0;
    end;

    for _ = 1, p32 do
        local v36 = weightedRoll(p31, p33);
        local v37 = v36.result or tostring(v36.min) .. "-" .. tostring(v36.max);
        v35[v37] = v35[v37] + 1;
    end;

    print("\n===================================");
    print("SIM:", p34 or "Unknown");
    print("ROLLS:", p32);
    local v38 = print;
    local v39 = (math.clamp(p33 or 1, 1, 15) - 1) / 9;

    if v39 <= 1 then
        v39 = v39 + v39 * 1 * (v39 - 0.16666666666666666) * (1 - v39);
    end;

    v38("LUCK:", p33, "EFF:", 1 + v39 * 2.75);
    print("===================================");

    for _, v in ipairs(p31) do
        local v40 = v.result or tostring(v.min) .. "-" .. tostring(v.max);
        local v41 = v35[v40];
        print(string.format("%-12s %8d  %6.3f%%", v40, v41, v41 / p32 * 100));
    end;

    print("===================================\n");
end;

return v1;