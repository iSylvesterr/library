-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Por = require(ReplicatedStorage.Library.Functions.Por);
local Ptries = require(ReplicatedStorage.Library.Functions.Ptries);
local AbstractItem = require(ReplicatedStorage.Library.Items.AbstractItem);
local u1 = Random.new();
local u2 = {};
local u3 = {};

local function safeToString(u4) -- Line: 54
    local success, result = pcall(function() -- Line: 55
        -- upvalues: u4 (copy)
        return game:GetService("HttpService"):JSONEncode(u4);
    end);

    if success then
        return result;
    end;

    return tostring(u4);
end;

local function computeIsOnlyCurrency(p5) -- Line: 65
    -- upvalues: u3 (copy), AbstractItem (copy)
    local v6 = false;

    for _, v in ipairs(p5.entries) do
        for _, v2 in ipairs(u3.ParseValues(v.Value)) do
            if u3.IsDropTable(v2) then
                return false;
            end;

            if AbstractItem.IsAnyItem(v2) then
                if not v2:IsA("Currency") then
                    return false;
                end;

                v6 = true;
            end;
        end;
    end;

    return v6;
end;

local function computeFlatTable(p7) -- Line: 83
    -- upvalues: u3 (copy), AbstractItem (copy)
    local u8 = {};

    local function insertEntry(p9) -- Line: 85
        -- upvalues: u8 (copy)
        table.insert(u8, table.freeze(p9));
    end;

    local v10 = p7:GetTotalWeight();

    for _, v in ipairs(p7.entries) do
        local v11 = v.Amount or 1;

        for _, v2 in ipairs(u3.ParseValues(v.Value)) do
            if u3.IsDropTable(v2) then
                for _, v3 in ipairs(v2:GetFlatTable()) do
                    table.insert(u8, table.freeze({
                        Item = v3.Item,
                        Amount = v11 * v3.Amount,
                        Probability = v3.Probability * v.Weight / v10
                    }));
                end;
            elseif AbstractItem.IsAnyItem(v2) then
                table.insert(u8, table.freeze({
                    Item = v2,
                    Amount = v11,
                    Probability = v.Weight / v10
                }));
            end;
        end;
    end;

    table.sort(u8, function(p12, p13) -- Line: 111
        return p12.Probability < p13.Probability;
    end);
    table.freeze(u8);

    return u8;
end;

local function computeDisplayTable(p14) -- Line: 118
    -- upvalues: Por (copy), u3 (copy), Ptries (copy), AbstractItem (copy)
    local v15 = p14:GetTotalWeight();
    local v16 = {};

    for _, v in ipairs(p14.entries) do
        local u17 = {};

        local function addDisplayData(p18) -- Line: 124
            -- upvalues: u17 (copy), Por (ref)
            local ItemBase = p18.ItemBase;
            local Name = ItemBase.Class.Name;
            local v19 = ItemBase:ExactStackKey();
            local v20 = u17[Name];

            if not v20 then
                v20 = {};
                u17[Name] = v20;
            end;

            if not v20[v19] then
                v20[v19] = p18;

                return;
            end;

            local v21 = v20[v19];
            v21.Probability = Por(v21.Probability, p18.Probability);
            v21.AvgAmount = v21.AvgAmount + p18.AvgAmount;
            v21.MinAmount = v21.MinAmount + p18.MinAmount;
            v21.MaxAmount = v21.MaxAmount + p18.MaxAmount;
        end;

        local v22 = v.Amount or 1;
        local v23 = v.Weight / v15;
        local v24 = u3.ParseValues(v.Value);
        local v25 = true;

        for _, v2 in ipairs(v24) do
            if u3.IsDropTable(v2) then
                if not v2:HasNil() then
                    v25 = false;
                end;

                for _, v3 in ipairs(v2:GetDisplayTable()) do
                    addDisplayData({
                        ItemBase = v3.ItemBase,
                        Probability = Ptries(v3.Probability, v22) * v23,
                        AvgAmount = v22 * v3.AvgAmount,
                        MinAmount = v22 * v3.MinAmount,
                        MaxAmount = v22 * v3.MaxAmount
                    });
                end;
            elseif AbstractItem.IsAnyItem(v2) then
                local v26 = v2:GetAmount();
                addDisplayData({
                    ItemBase = v2,
                    Probability = v23,
                    AvgAmount = v22 * v26 * v23,
                    MinAmount = v22 * v26,
                    MaxAmount = v22 * v26
                });
                v25 = false;
            end;
        end;

        for i, v2 in pairs(u17) do
            local v27 = v16[i] or {};
            v16[i] = v27;

            for i2, v3 in pairs(v2) do
                if v25 then
                    v3.MinAmount = 0;
                end;

                if v27[i2] then
                    local v28 = v27[i2];
                    v28.Probability = Por(v28.Probability, v3.Probability);
                    v28.AvgAmount = v28.AvgAmount + v3.AvgAmount;
                    v28.MinAmount = math.min(v28.MinAmount, v3.MinAmount);
                    v28.MaxAmount = math.max(v28.MaxAmount, v3.MaxAmount);
                else
                    v27[i2] = v3;
                end;
            end;
        end;
    end;

    local v29 = {};

    for _, v in pairs(v16) do
        for _, v2 in pairs(v) do
            table.insert(v29, table.freeze(v2));
        end;
    end;

    table.sort(v29, function(p30, p31) -- Line: 205
        return p30.Probability < p31.Probability;
    end);

    return table.freeze(v29);
end;

function u3.ParseValues(u32) -- Line: 212
    if u32 == nil then
        return {};
    end;

    if type(u32) == "table" then
        return #u32 <= 0 and { u32 } or u32;
    end;

    local v33 = error;
    local success, result = pcall(function() -- Line: 55
        -- upvalues: u32 (copy)
        return game:GetService("HttpService"):JSONEncode(u32);
    end);

    if not success then
        result = tostring(u32);
    end;

    v33(("Unknown DropTable value: %s"):format(result));
end;

function u3.CompactValues(p34) -- Line: 226
    if #p34 == 0 then
        return nil;
    end;

    if #p34 == 1 then
        return p34[1];
    end;

    return p34;
end;

function u3.DeepFreezeEntries(p35) -- Line: 236
    -- upvalues: u3 (copy), AbstractItem (copy)
    table.freeze(p35);

    for _, v in ipairs(p35) do
        table.freeze(v);
        local v36 = u3.ParseValues(v.Value);
        table.freeze(v36);

        for _, v2 in ipairs(v36) do
            if not u3.IsDropTable(v2) and AbstractItem.IsAnyItem(v2) then
                v2:Freeze();
            end;
        end;
    end;
end;

function u3.IsDropTable(p37) -- Line: 252
    -- upvalues: u2 (copy)
    if type(p37) == "table" then
        return p37.Roll == u2.Roll;
    end;

    return false;
end;

function u3.TInterfaceIsDropTable(p38) -- Line: 259
    -- upvalues: u3 (copy)
    if u3.IsDropTable(p38) then
        return true;
    end;

    return false, "Value is not a DropTable";
end;

function u3.withAmount(p39, p40, p41) -- Line: 267
    -- upvalues: Asserts (copy), u3 (copy)
    Asserts.positiveInteger(p39);
    assert(p41 == nil, "withAmount: unused must be nil");

    if p39 == 1 then
        return u3.new(p40);
    end;

    if p39 > 100000 then
        error(`Using too large of amount: {p39}`);
    end;

    return u3.new({
        {
            Weight = 1,
            Value = u3.new(p40),
            Amount = p39
        }
    });
end;

function u3.new(p42, p43) -- Line: 286
    -- upvalues: Asserts (copy), u3 (copy), AbstractItem (copy), u2 (copy)
    assert(p43 == nil, "new: extra must be nil");
    Asserts.array.table(p42);
    assert(#p42 > 0, "new: entries table must not be empty");

    for _, v in ipairs(p42) do
        local Weight = v.Weight;
        Asserts.finite(Weight);
        local v44 = "new: entry weight must be greater than zero. Traceback: " .. debug.traceback();
        assert(Weight > 0, v44);
        local Amount = v.Amount;
        Asserts.optional.positiveInteger(Amount);
        local v45 = Amount or 1;

        for _, v2 in ipairs(u3.ParseValues(v.Value)) do
            if not u3.IsDropTable(v2) then
                if AbstractItem.IsAnyItem(v2) then
                    local v46 = not v2:GetOptionalUID();
                    assert(v46, "new: AbstractItem should not have an OptionalUID");

                    if v2:IsA("Currency") and (v2:GetId() == "Diamonds" and v45 * v2:GetAmount() > 1000000000) then
                        error(("Diamonds in loot table: %s"):format(v45 * v2:GetAmount()));
                    end;
                else
                    local v47 = error;
                    local success, result = pcall(function() -- Line: 55
                        -- upvalues: v2 (copy)
                        return game:GetService("HttpService"):JSONEncode(v2);
                    end);

                    if not success then
                        result = tostring(v2);
                    end;

                    v47(("Invalid DropTable value: %s"):format(result));
                end;
            end;
        end;
    end;

    local function validateNoLoop(p48, p49) -- Line: 319
        -- upvalues: u3 (ref), validateNoLoop (copy)
        local v50 = false;

        for _, v in ipairs(p48) do
            for _, v2 in ipairs(u3.ParseValues(v.Value)) do
                if u3.IsDropTable(v2) then
                    if not v50 then
                        p49 = table.clone(p49);
                        v50 = true;
                    end;

                    if p49[v2] then
                        error("LOOP!");
                    end;

                    p49[v2] = true;
                    validateNoLoop(v2.entries, p49);
                end;
            end;
        end;
    end;

    validateNoLoop(p42, {});
    local v51 = table.clone(p42);
    table.sort(v51, function(p52, p53) -- Line: 341
        return (p52.Value == nil and (1 / 0) or (p52.Weight or (1 / 0))) < (p53.Value == nil and (1 / 0) or (p53.Weight or (1 / 0)));
    end);
    u3.DeepFreezeEntries(v51);
    local v54 = setmetatable({
        entries = v51,
        _caches = {}
    }, {
        __index = u2
    });
    table.freeze(v54);

    return v54;
end;

function u2.GetFlatTable(p55) -- Line: 359
    -- upvalues: computeFlatTable (copy)
    local flatTable = p55._caches.flatTable;

    if flatTable then
        return flatTable;
    end;

    local v56 = computeFlatTable(p55);
    p55._caches.flatTable = v56;

    return v56;
end;

function u2.GetDisplayTable(p57) -- Line: 370
    -- upvalues: computeDisplayTable (copy)
    local displayTable = p57._caches.displayTable;

    if displayTable then
        return displayTable;
    end;

    local v58 = computeDisplayTable(p57);
    p57._caches.displayTable = v58;

    return v58;
end;

function u2.IsOnlyCurrency(p59) -- Line: 381
    -- upvalues: computeIsOnlyCurrency (copy)
    if p59._caches.isOnlyCurrency ~= nil then
        return p59._caches.isOnlyCurrency;
    end;

    local v60 = computeIsOnlyCurrency(p59);
    p59._caches.isOnlyCurrency = v60;

    return v60;
end;

function u2.GetTotalWeight(p61) -- Line: 391
    if p61._caches.totalWeight ~= nil then
        return p61._caches.totalWeight;
    end;

    local v62 = 0;

    for _, v in ipairs(p61.entries) do
        v62 = v62 + v.Weight;
    end;

    p61._caches.totalWeight = v62;

    return v62;
end;

function u2.HasNil(p63) -- Line: 404
    -- upvalues: u3 (copy)
    if p63._caches.hasNil ~= nil then
        return p63._caches.hasNil;
    end;

    local v64 = false;

    for _, v in ipairs(p63.entries) do
        local v65 = u3.ParseValues(v.Value);
        local v66 = true;

        for _, v2 in ipairs(v65) do
            if not (u3.IsDropTable(v2) and v2:HasNil()) then
                v66 = false;
                break;
            end;
        end;

        if v66 then
            v64 = true;
        end;
    end;

    p63._caches.hasNil = v64;

    return v64;
end;

function u2.ApplyChance(p67, p68) -- Line: 433
    -- upvalues: Asserts (copy), u3 (copy)
    Asserts.finite(p68);
    assert(p68 > 0, "ApplyChance: chance must be greater than zero");

    if p68 == 1 then
        return p67;
    end;

    local entries = p67.entries;

    if #entries == 1 then
        local v69 = entries[1];
        local v70 = u3.ParseValues(v69.Value);
        local v71 = {};

        for _, v in ipairs(v70) do
            if u3.IsDropTable(v) then
                table.insert(v71, v:ApplyChance(p68));
            else
                table.insert(v71, v);
            end;
        end;

        local v72 = table.clone(v69);
        v72.Value = u3.CompactValues(v71);

        return u3.new({ v72 });
    end;

    local v73 = {};
    local v74 = 0;
    local v75 = 0;

    for _, v in ipairs(entries) do
        if v.Value == nil then
            v75 = v75 + v.Weight;
        else
            table.insert(v73, table.clone(v));
            v74 = v74 + v.Weight;
        end;
    end;

    if #v73 == 0 then
        return p67;
    end;

    if p68 >= 1 and v75 >= 0 then
        return p67;
    end;

    for _, v in ipairs(v73) do
        v.Weight = v.Weight * p68;
    end;

    local v76 = v75 + v74 * (1 - p68);

    if v76 > 0 then
        table.insert(v73, {
            Weight = v76
        });
    end;

    return u3.new(v73);
end;

function u3.ToRandom(u77) -- Line: 484
    -- upvalues: u1 (copy)
    if u77 == nil then
        return function() -- Line: 486
            -- upvalues: u1 (ref)
            return u1:NextNumber();
        end;
    end;

    if type(u77) == "function" then
        return u77;
    end;

    if type(u77) == "number" then
        local u78 = Random.new(u77);

        return function() -- Line: 493
            -- upvalues: u78 (copy)
            return u78:NextNumber();
        end;
    end;

    if typeof(u77) == "Random" then
        return function() -- Line: 497
            -- upvalues: u77 (copy)
            return u77:NextNumber();
        end;
    end;

    error(("Invalid rng: %s"):format((tostring(u77))));
end;

function u3.SimulateRolls(p79, p80) -- Line: 505
    -- upvalues: Asserts (copy)
    Asserts.finiteNonNegative(p79);
    Asserts.finite(p80);
    local v81;

    if p80 >= 0 then
        v81 = p80 < 1;
    else
        v81 = false;
    end;

    assert(v81, "SimulateRolls: probability must be between 0 and 1");

    return 1 - (1 - p80) ^ (1 / p79);
end;

function u2.RollN(p82, p83, p84, p85) -- Line: 514
    -- upvalues: Asserts (copy), u3 (copy), AbstractItem (copy)
    Asserts.integerNonNegative(p83);
    Asserts.optional.func(p85);

    if p83 == 0 then
        return {};
    end;

    local v86 = u3.ToRandom(p84);
    local entries = p82.entries;
    local v87 = {};

    if #entries == 1 then
        local v88 = entries[1];
        local v89 = v88.Amount or 1;

        for _, v in ipairs(u3.ParseValues(v88.Value)) do
            if u3.IsDropTable(v) then
                for _, v2 in ipairs(v:RollN(p83 * v89, v86, p85)) do
                    table.insert(v87, v2);
                end;
            elseif AbstractItem.IsAnyItem(v) then
                for _ = 1, p83 * v89 do
                    local v90 = {
                        Item = v:Clone(),
                        Entry = v88
                    };
                    table.insert(v87, v90);
                end;
            end;
        end;

        return v87;
    end;

    local v91 = p82:GetTotalWeight();
    local v92;

    if p85 then
        v92 = {};
        v91 = 0;

        for i, v in ipairs(entries) do
            local v93 = p85(p82, v.Weight, v.Value, v.Amount or 1, v);
            Asserts.finite(v93);
            assert(v93 >= 0, "RollN: weight returned by callback must be non-negative");
            table.insert(v92, {
                Index = i,
                Weight = v93
            });
            v91 = v91 + v93;
        end;

        table.sort(v92, function(p94, p95) -- Line: 559
            -- upvalues: entries (copy)
            return (entries[p94.Index].Value == nil and (1 / 0) or (p94.Weight or (1 / 0))) < (entries[p95.Index].Value == nil and (1 / 0) or (p95.Weight or (1 / 0)));
        end);
    else
        v92 = nil;
    end;

    for _ = 1, p83 do
        local v96 = v86();
        Asserts.finite(v96);
        local v97;

        if v96 >= 0 then
            v97 = v96 < 1;
        else
            v97 = false;
        end;

        local v98 = `RollN: Invalid roll provided, must be between 0 and 1: {v96}`;
        assert(v97, v98);
        local v99 = v96 * v91;
        local v100 = 0;

        if v92 then
            for _, v in ipairs(v92) do
                v99 = v99 - v.Weight;
                v100 = v.Index;

                if v99 <= 0 then
                    break;
                end;
            end;
        else
            for i, v in ipairs(entries) do
                v99 = v99 - v.Weight;

                if v99 <= 0 then
                    v100 = i;
                    break;
                end;

                v100 = i;
            end;
        end;

        local v101 = entries[v100];

        if v101 then
            for _, v in ipairs(u3.ParseValues(v101.Value)) do
                local v102 = v101.Amount or 1;

                if u3.IsDropTable(v) then
                    for _, v2 in ipairs(v:RollN(v102, v86)) do
                        table.insert(v87, v2);
                    end;
                elseif AbstractItem.IsAnyItem(v) then
                    for _ = 1, v102 do
                        local v103 = {
                            Item = v:Clone(),
                            Entry = v101
                        };
                        table.insert(v87, v103);
                    end;
                end;
            end;
        end;
    end;

    return v87;
end;

function u2.Roll(p104, p105, p106) -- Line: 620
    -- upvalues: u2 (copy)
    return u2.RollN(p104, 1, p105, p106);
end;

function u2.RollOne(p107, p108, p109) -- Line: 624
    -- upvalues: u2 (copy)
    return u2.RollN(p107, 1, p108, p109)[1];
end;

function u2.ComputeEstValue(p110) -- Line: 628
    -- upvalues: u3 (copy), AbstractItem (copy)
    local v111 = 0;
    local v112 = 0;

    for _, v in ipairs(p110.entries) do
        local Weight = v.Weight;
        local v113 = u3.ParseValues(v.Value);
        local v114 = 0;

        for _, v2 in ipairs(v113) do
            if u3.IsDropTable(v2) then
                v114 = v114 + v2:ComputeEstValue();
            elseif AbstractItem.IsAnyItem(v2) then
                v114 = v114 + (v2:GetDevRAP() or 0) * v2:GetAmount();
            end;
        end;

        v111 = v111 + v114 * (v.Amount or 1) * Weight;
        v112 = v112 + Weight;
    end;

    return v111 / v112;
end;

setmetatable(u2, {
    __index = function(p115, p116) -- Line: 653, Name: __index
        error(("Unknown DropTable prototype key \'%s\'"):format(p116));
    end
});
table.freeze(u2);
setmetatable(u3, {
    __index = function(p117, p118) -- Line: 661, Name: __index
        error(("Unknown DropTable key \'%s\'"):format(p118));
    end
});

return table.freeze(u3);