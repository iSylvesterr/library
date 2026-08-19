-- Decompiled with Potassium's decompiler.

local v1 = {};
local u3 = Random and function(p2) -- Line: 6
    return p2 and Random.new(p2) or Random.new();
end or nil;

local function sig(p4) -- Line: 11
    return 1 / (math.exp(-p4) + 1);
end;

local u5 = {
    chanceAtLuck1 = 0.01,
    chanceAtLuck100 = 0.05,
    maxSize = 10000000
};

local function doublingChance(p6) -- Line: 34
    -- upvalues: u5 (copy)
    local v7 = (math.clamp(p6 or 1, 1, 100) - 1) / 99;

    return u5.chanceAtLuck1 + (u5.chanceAtLuck100 - u5.chanceAtLuck1) * v7;
end;

local function rollDoublings(p8, p9, p10) -- Line: 41
    -- upvalues: u5 (copy)
    local v11 = (math.clamp(p9 or 1, 1, 100) - 1) / 99;
    local v12 = u5.chanceAtLuck1 + (u5.chanceAtLuck100 - u5.chanceAtLuck1) * v11;
    local v13 = 0;

    while p10 * 2 <= u5.maxSize and p8:NextNumber() <= v12 do
        p10 = p10 * 2;
        v13 = v13 + 1;
    end;

    return p10, v13;
end;

local function getFruitWeight(p14, p15) -- Line: 66
    if not p14.usesLuck then
        return p14.weight;
    end;

    local luckExponent = p14.luckExponent;

    if luckExponent == 1 then
        local v16 = 1 / (math.exp(-(0.8 * (p15 - 8))) + 1);
        local v17 = 1 / (math.exp(-(0.5 * (p15 - 20))) + 1);

        return 100 + 14000 * v16 * (1 - v17 * 0.85);
    end;

    if luckExponent == 1.5 then
        local v18 = 1 / (math.exp(-(0.3 * (p15 - 18))) + 1);
        local v19 = 1 / (math.exp(-(0.08 * (p15 - 75))) + 1);

        return 20 + 18000 * v18 * (1 - v19 * 0.6);
    end;

    if luckExponent == 2 then
        return 5 + 25000 * (1 / (math.exp(-(0.1 * (p15 - 50))) + 1));
    end;

    if luckExponent == 2.5 then
        return 1.5 + p15 * 30;
    end;

    if luckExponent == 3.5 then
        return 0.01 + p15 * 3;
    end;

    if luckExponent == 4.5 then
        return 0.001 + p15 * 0.1;
    end;

    if luckExponent == 5.5 then
        return 0.0001 + p15 * 0.003;
    end;

    return p14.weight;
end;

local function getPlantWeight(p20, p21) -- Line: 108
    if not p20.usesLuck then
        return p20.weight;
    end;

    local v22 = p20.luckExponent or 1;

    if v22 == 1 then
        local v23 = 1 / (math.exp(-(1 * (p21 - 3))) + 1);
        local v24 = 1 / (math.exp(-(0.4 * (p21 - 12))) + 1);

        return 500 + 5000 * v23 * (1 - v24 * 0.85);
    end;

    if v22 == 1.5 then
        local v25 = 1 / (math.exp(-(0.4 * (p21 - 10))) + 1);
        local v26 = 1 / (math.exp(-(0.06 * (p21 - 55))) + 1);

        return 250 + 10000 * v25 * (1 - v26 * 0.5);
    end;

    if v22 == 2 then
        local v27 = 1 / (math.exp(-(0.12 * (p21 - 30))) + 1);
        local v28 = 1 / (math.exp(-(0.06 * (p21 - 75))) + 1);

        return 125 + 15000 * v27 * (1 - v28 * 0.4);
    end;

    if v22 == 2.5 then
        return 62.5 + 20000 * (1 / (math.exp(-(0.08 * (p21 - 55))) + 1));
    end;

    if v22 == 3 then
        return 31.25 + p21 * 50;
    end;

    if v22 == 3.5 then
        return 15.625 + p21 * 8;
    end;

    if v22 == 4 then
        return 3 + p21 * 0.5;
    end;

    if v22 == 4.5 then
        return 0.05 + p21 * 0.02;
    end;

    return p20.weight;
end;

local function getRandomSize(p29, p30, p31, p32) -- Line: 147
    -- upvalues: u3 (ref), rollDoublings (copy)
    local v33 = u3(p31);
    local v34 = math.clamp(p30 or 1, 1, 100);
    local v35 = {};
    local v36 = 0;

    for i, v in p29 do
        v35[i] = p32(v, v34);
        v36 = v36 + v35[i];
    end;

    local v37 = v33:NextNumber() * v36;
    local v38 = 0;
    local v39 = 1;

    for i, v in p29 do
        v38 = v38 + v35[i];

        if v37 <= v38 then
            v39 = v.min + v33:NextNumber() * (v.max - v.min);
            break;
        end;
    end;

    local v40, v41 = rollDoublings(v33, v34, v39);

    return v40, v41, v39;
end;

function v1.GetRandomFruitSize(p42, p43) -- Line: 174
    -- upvalues: getRandomSize (copy), getFruitWeight (copy)
    return getRandomSize({ {
            min = 0.85,
            max = 1.15,
            weight = 10000,
            usesLuck = false
        }, {
            min = 2.8,
            max = 3.3,
            weight = 5,
            usesLuck = true,
            luckExponent = 2
        }, {
            min = 4,
            max = 5,
            weight = 1.5,
            usesLuck = true,
            luckExponent = 2.5
        }, {
            min = 6.5,
            max = 7.5,
            weight = 0.01,
            usesLuck = true,
            luckExponent = 3.5
        }, {
            min = 9.5,
            max = 12.5,
            weight = 0.001,
            usesLuck = true,
            luckExponent = 4.5
        }, {
            min = 14.5,
            max = 17.5,
            weight = 0.0001,
            usesLuck = true,
            luckExponent = 5.5
        } }, p42, p43, getFruitWeight);
end;

local u44 = { {
        min = 0.95,
        max = 1.05,
        weight = 2000,
        usesLuck = false
    }, {
        min = 1.45,
        max = 1.55,
        weight = 250,
        usesLuck = true,
        luckExponent = 1.5
    }, {
        min = 1.9,
        max = 2.1,
        weight = 125,
        usesLuck = true,
        luckExponent = 2
    }, {
        min = 2.85,
        max = 3.15,
        weight = 62.5,
        usesLuck = true,
        luckExponent = 2.5
    }, {
        min = 3.8,
        max = 4.2,
        weight = 31.25,
        usesLuck = true,
        luckExponent = 3
    }, {
        min = 5.8,
        max = 6.2,
        weight = 15.625,
        usesLuck = true,
        luckExponent = 3.5
    }, {
        min = 9.5,
        max = 12.5,
        weight = 3,
        usesLuck = true,
        luckExponent = 4
    }, {
        min = 12,
        max = 17,
        weight = 0.05,
        usesLuck = true,
        luckExponent = 4.5
    }, {
        min = 20,
        max = 35,
        weight = 0.0001,
        usesLuck = true,
        luckExponent = 5
    } };
local u45 = {};

local function deepCloneTiers(p46) -- Line: 206
    local v47 = {};

    for i, v in p46 do
        v47[i] = {
            min = v.min,
            max = v.max,
            weight = v.weight,
            usesLuck = v.usesLuck,
            luckExponent = v.luckExponent
        };
    end;

    return v47;
end;

function v1.GetRandomPlantSize(p48, p49, p50) -- Line: 220
    -- upvalues: u45 (copy), u44 (copy), getRandomSize (copy), getPlantWeight (copy)
    return getRandomSize(p50 and u45[p50] or u44, p48, p49, getPlantWeight);
end;

function v1.GetDefaultPlantTiers() -- Line: 227
    -- upvalues: deepCloneTiers (copy), u44 (copy)
    return deepCloneTiers(u44);
end;

function v1.SetDevOverride(p51, p52) -- Line: 234
    -- upvalues: u45 (copy), deepCloneTiers (copy)
    u45[p51] = deepCloneTiers(p52);
end;

function v1.ClearDevOverride(p53) -- Line: 238
    -- upvalues: u45 (copy)
    u45[p53] = nil;
end;

function v1.GetPlantWeightAtLuck(p54, p55) -- Line: 245
    -- upvalues: getPlantWeight (copy)
    return getPlantWeight(p54, (math.clamp(p55 or 1, 1, 100)));
end;

function v1.SetDoublingConfig(p56) -- Line: 253
    -- upvalues: u5 (copy)
    for i, v in p56 do
        u5[i] = v;
    end;
end;

function v1.GetDoublingChanceAtLuck(p57) -- Line: 260
    -- upvalues: u5 (copy)
    local v58 = (math.clamp(p57 or 1, 1, 100) - 1) / 99;

    return u5.chanceAtLuck1 + (u5.chanceAtLuck100 - u5.chanceAtLuck1) * v58;
end;

function v1.GetDoublingOdds(p59, p60) -- Line: 266
    -- upvalues: u5 (copy)
    local v61 = (math.clamp(p59 or 1, 1, 100) - 1) / 99;

    return (u5.chanceAtLuck1 + (u5.chanceAtLuck100 - u5.chanceAtLuck1) * v61) ^ p60;
end;

return v1;