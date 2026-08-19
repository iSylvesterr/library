-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FertilizerConfig = require(ReplicatedStorage.Shared.Info.FertilizerConfig);
local u1 = {
    Costs = { 500, 250000, 100000000, 20000000000, 100000000000000 },
    MaxLevel = 5
};

function u1.GetCost(p2) -- Line: 26
    -- upvalues: u1 (copy)
    return u1.Costs[p2];
end;

function u1.GetNext(p3) -- Line: 32
    -- upvalues: u1 (copy), FertilizerConfig (copy)
    local v4 = (p3 or 0) + 1;
    local v5 = u1.Costs[v4];

    if not v5 then
        return nil;
    end;

    local v6 = nil;
    local v7 = nil;

    for i, v in FertilizerConfig.Fertilizers do
        if v.rebirthReq == v4 then
            v7 = v;
            v6 = i;
            break;
        end;
    end;

    return {
        level = v4,
        cost = v5,
        fertilizerKey = v6,
        fertilizer = v7
    };
end;

function u1.ApplyOverrides(p8) -- Line: 49
    -- upvalues: u1 (copy)
    if type(p8) ~= "table" then
        return;
    end;

    for i, v in p8 do
        local v9 = tonumber(i);
        local v10 = tonumber(v);

        if v9 and (v10 and v10 >= 0) then
            u1.Costs[math.floor(v9)] = v10;
        end;
    end;

    local v11 = 0;

    for i in u1.Costs do
        if v11 < i then
            v11 = i;
        end;
    end;

    u1.MaxLevel = v11;
end;

return u1;