-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = require(ReplicatedStorage.UserGenerated.Randoms.ISAAC).Unique();
local u2 = Asserts.Table({
    Weight = Asserts.FinitePositive,
    Value = Asserts.Any
});
local v3 = Asserts.Table({
    Weight = Asserts.FinitePositive,
    Chance = Asserts.Range(0, 1),
    Value = Asserts.Any
});
local v4 = {};

local function Search(p5, p6) -- Line: 74
    local v7 = #p5;
    local v8 = 1;

    while v8 < v7 do
        local v9 = v8 + (v7 - v8) // 2;

        if p6 < p5[v9] then
            v7 = v9;
        else
            v8 = v9 + 1;
        end;
    end;

    return v8;
end;

function v4.Next(p10) -- Line: 88
    -- upvalues: u1 (copy), Search (copy)
    local v11 = u1:NextDouble();
    local v12 = Search(p10.Uppers, p10.TotalWeight * v11);
    local v13 = p10.Entries[v12];

    return v13.Value, v13;
end;

function v4.Pick(p14, p15) -- Line: 100
    -- upvalues: Search (copy)
    local v16;

    if p15 >= 0 then
        v16 = p15 <= 1;
    else
        v16 = false;
    end;

    assert(v16);
    local v17 = Search(p14.Uppers, p14.TotalWeight * p15);
    local v18 = p14.Entries[v17];

    return v18.Value, v18;
end;

local u19 = table.freeze({
    __index = table.freeze(v4)
});

local function CompareOrderedEntry(p20, p21) -- Line: 113
    if p20.Weight == p21.Weight then
        return p20.Index < p21.Index;
    end;

    return p20.Weight < p21.Weight;
end;

local function new(p22) -- Line: 121
    -- upvalues: Asserts (copy), u2 (copy), CompareOrderedEntry (copy), u19 (copy)
    Asserts.Array(u2)(p22);
    local v23 = #p22;
    assert(v23 > 0);
    local v24 = {};

    for i, v in ipairs(p22) do
        table.insert(v24, {
            Index = i,
            Weight = v.Weight
        });
    end;

    table.sort(v24, CompareOrderedEntry);
    local v25 = table.create(v23, 0);
    local v26 = 0;
    local v27 = {};

    for i, v in ipairs(v24) do
        local v28 = p22[v.Index];
        local Weight = v28.Weight;
        v26 = v26 + Weight;
        v25[i] = v26;
        table.insert(v27, {
            Chance = 0,
            Weight = Weight,
            Value = v28.Value
        });
    end;

    table.freeze(v25);

    for _, v in ipairs(v27) do
        v.Chance = v.Weight / v26;
        table.freeze(v);
    end;

    table.freeze(v27);
    local v29 = setmetatable({
        TotalWeight = v26,
        Entries = v27,
        Uppers = v25
    }, u19);
    table.freeze(v29);

    return v29;
end;

local u34 = table.freeze({
    __index = table.freeze({
        Add = function(p30, p31, p32) -- Line: 209, Name: Add
            -- upvalues: Asserts (copy)
            Asserts.FinitePositive(p31);
            p30.AssertValue(p32);
            table.insert(p30.Entries, {
                Weight = p31,
                Value = p32
            });

            return p30;
        end,

        Build = function(p33) -- Line: 219, Name: Build
            -- upvalues: new (copy)
            return new(p33.Entries);
        end
    })
});

return table.freeze({
    new = new,

    IsA = function(p35) -- Line: 172, Name: IsA
        -- upvalues: u19 (copy)
        local v36;

        if type(p35) == "table" then
            v36 = getmetatable(p35) == u19;
        else
            v36 = false;
        end;

        return v36;
    end,

    Assert = function(p37) -- Line: 176, Name: Assert
        -- upvalues: u19 (copy)
        if type(p37) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p37) ~= u19 then
            error("DropTable", 2);
        end;

        return p37;
    end,

    AssertEntry = v3,

    Builder = function(p38) -- Line: 225, Name: Builder
        -- upvalues: Asserts (copy), u34 (copy)
        Asserts.Function(p38);
        local v39 = setmetatable({
            AssertValue = p38,
            Entries = {}
        }, u34);
        table.freeze(v39);

        return v39;
    end,

    IsABuilder = function(p40) -- Line: 236, Name: IsABuilder
        -- upvalues: u34 (copy)
        local v41;

        if type(p40) == "table" then
            v41 = getmetatable(p40) == u34;
        else
            v41 = false;
        end;

        return v41;
    end,

    AssertBuilder = function(p42) -- Line: 240, Name: AssertBuilder
        -- upvalues: u34 (copy)
        if type(p42) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p42) ~= u34 then
            error("table", 2);
        end;

        return p42;
    end,

    AssertBuilderEntry = u2
});