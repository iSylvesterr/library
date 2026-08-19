-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local DropTable = require(ReplicatedStorage.Library.DropTable);
local v1 = {};

local function isValidWeight(p2) -- Line: 16
    local v3;

    if typeof(p2) == "number" and (p2 > 0 and p2 == p2) then
        v3 = p2 ~= (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function getSortedDropTable(p4) -- Line: 20
    local v5 = {};

    for _, v in ipairs(p4) do
        table.insert(v5, v);
    end;

    table.sort(v5, function(p6, p7) -- Line: 27
        local v8 = p6[2];
        local v9 = p7[2];
        local v10;

        if typeof(v8) == "number" and (v8 > 0 and v8 == v8) then
            v10 = v8 ~= (1 / 0);
        else
            v10 = false;
        end;

        local v11;

        if typeof(v9) == "number" and (v9 > 0 and v9 == v9) then
            v11 = v9 ~= (1 / 0);
        else
            v11 = false;
        end;

        if v10 ~= v11 then
            return v10;
        end;

        if not (v10 or v11) then
            return (typeof(p6[1]) ~= "string" and "" or p6[1]) < (typeof(p7[1]) ~= "string" and "" or p7[1]);
        end;

        if v8 == v9 then
            return (typeof(p6[1]) ~= "string" and "" or p6[1]) < (typeof(p7[1]) ~= "string" and "" or p7[1]);
        end;

        return v8 < v9;
    end);

    return v5;
end;

local function getTotalWeight(p12) -- Line: 59
    local v13 = 0;

    for _, v in ipairs(p12) do
        local v14 = v[2];
        local v15;

        if typeof(v14) == "number" and (v14 > 0 and v14 == v14) then
            v15 = v14 ~= (1 / 0);
        else
            v15 = false;
        end;

        if v15 then
            v13 = v13 + v14;
        end;
    end;

    return v13;
end;

local function getVirtualRollCdf(p16, p17) -- Line: 72
    -- upvalues: Asserts (copy)
    Asserts.finite(p16);
    Asserts.finiteNonNegative(p17);

    if p17 <= 1 then
        return p16;
    end;

    return 1 - (1 - p16) ^ p17;
end;

function v1.ComputeVirtualRolls(p18, p19) -- Line: 84
    local v20 = 1 + (typeof(p18) ~= "number" and 0 or p18) / 100;
    local v21 = (v20 < 0 and 0 or v20) + ((typeof(p19) ~= "number" and 1 or math.max(p19, 1)) - 1);

    return v21 < 1 and 1 or v21;
end;

function v1.RollToken(p22, p23, p24) -- Line: 102
    -- upvalues: Asserts (copy), getSortedDropTable (copy), getTotalWeight (copy), DropTable (copy)
    Asserts.table(p22);
    Asserts.number(p23);
    local v25 = p24 == nil and true or typeof(p24) == "Random";
    assert(v25, "rng must be a Random");
    local v26 = getSortedDropTable(p22);
    local v27 = getTotalWeight(v26);

    if v27 <= 0 then
        return nil;
    end;

    local v28 = p24 or Random.new();
    local v29 = DropTable.SimulateRolls(math.max(p23, 1), v28:NextNumber()) * v27;
    local v30 = nil;

    for _, v in ipairs(v26) do
        local v31 = v[1];
        local v32 = v[2];

        if typeof(v31) == "string" then
            local v33;

            if typeof(v32) == "number" and (v32 > 0 and v32 == v32) then
                v33 = v32 ~= (1 / 0);
            else
                v33 = false;
            end;

            if v33 then
                v29 = v29 - v32;

                if v29 <= 0 then
                    return v31;
                end;

                v30 = v31;
            end;
        end;
    end;

    return v30;
end;

function v1.ComputeTokenOdds(p34, p35) -- Line: 138
    -- upvalues: Asserts (copy), getSortedDropTable (copy), getTotalWeight (copy)
    Asserts.table(p34);
    Asserts.number(p35);
    local v36 = getSortedDropTable(p34);
    local v37 = getTotalWeight(v36);

    if v37 <= 0 then
        return {};
    end;

    local v38 = {};
    local v39 = 0;

    for _, v in ipairs(v36) do
        local v40 = v[1];
        local v41 = v[2];

        if typeof(v40) == "string" then
            local v42;

            if typeof(v41) == "number" and (v41 > 0 and v41 == v41) then
                v42 = v41 ~= (1 / 0);
            else
                v42 = false;
            end;

            if v42 then
                local v43 = v39 / v37;
                v39 = v39 + v41;
                local v44 = v39 / v37;
                local v45 = math.max(p35, 1);
                Asserts.finite(v44);
                Asserts.finiteNonNegative(v45);

                if v45 > 1 then
                    v44 = 1 - (1 - v44) ^ v45;
                end;

                local v46 = math.max(p35, 1);
                Asserts.finite(v43);
                Asserts.finiteNonNegative(v46);

                if v46 > 1 then
                    v43 = 1 - (1 - v43) ^ v46;
                end;

                local v47 = v44 - v43;

                if v47 > 0 then
                    v38[v40] = (v38[v40] or 0) + v47;
                end;
            end;
        end;
    end;

    return v38;
end;

return v1;