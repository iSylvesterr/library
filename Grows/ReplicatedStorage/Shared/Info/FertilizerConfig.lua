-- Decompiled with Potassium's decompiler.

local u1 = {
    Order = { "None", "Basic", "Better", "Premium", "Super", "Magic" },
    Fertilizers = {
        None = {
            displayName = "None",
            mult = 1,
            costMult = 0,
            rebirthReq = 0
        },
        Basic = {
            displayName = "Basic",
            mult = 1.5,
            costMult = 0.25,
            rebirthReq = 1
        },
        Better = {
            displayName = "Better",
            mult = 2,
            costMult = 0.5,
            rebirthReq = 2
        },
        Premium = {
            displayName = "Premium",
            mult = 2.75,
            costMult = 1.375,
            rebirthReq = 3
        },
        Super = {
            displayName = "Super",
            mult = 3.75,
            costMult = 1.875,
            rebirthReq = 4
        },
        Magic = {
            displayName = "Magic",
            mult = 5,
            costMult = 2.5,
            rebirthReq = 5
        }
    }
};

function u1.Get(p2) -- Line: 25
    -- upvalues: u1 (copy)
    return u1.Fertilizers[p2];
end;

function u1.GetMult(p3) -- Line: 29
    -- upvalues: u1 (copy)
    local v4 = u1.Fertilizers[p3];

    return v4 and v4.mult or 1;
end;

function u1.IsUnlocked(p5, p6) -- Line: 34
    -- upvalues: u1 (copy)
    local v7 = u1.Fertilizers[p5];

    if v7 then
        return (p6 or 0) >= v7.rebirthReq;
    end;

    return false;
end;

u1.SeedValueOverride = {
    Oak = 5
};

function u1.GetSeedValue(p8, p9) -- Line: 45
    -- upvalues: u1 (copy)
    return u1.SeedValueOverride[p8] or (p9 or 0);
end;

function u1.GetCost(p10, p11, p12) -- Line: 53
    -- upvalues: u1 (copy)
    local v13 = u1.Fertilizers[p10];

    return (not v13 or p10 == "None") and 0 or (p10 == "Basic" and p12 == "Oak" and 0 or math.floor(v13.costMult * (p11 or 0)));
end;

function u1.ApplyOverrides(p14) -- Line: 62
    -- upvalues: u1 (copy)
    if type(p14) ~= "table" then
        return;
    end;

    for i, v in p14 do
        local v15 = u1.Fertilizers[i];

        if v15 and type(v) == "table" then
            local v16 = tonumber(v.mult);

            if v16 and v16 > 0 then
                v15.mult = v16;
            end;

            local v17 = tonumber(v.costMult);

            if v17 and v17 >= 0 then
                v15.costMult = v17;
            end;

            local v18 = tonumber(v.rebirthReq);

            if v18 and v18 >= 0 then
                v15.rebirthReq = math.floor(v18);
            end;
        end;
    end;
end;

return u1;