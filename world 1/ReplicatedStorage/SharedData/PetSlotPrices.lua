-- Decompiled with Potassium's decompiler.

local u1 = {
    Prices = { 200000, 1000000, 5000000 },
    BaseMax = 3
};
u1.AbsoluteMax = u1.BaseMax + #u1.Prices;

function u1.GetNextPrice(p2) -- Line: 31
    -- upvalues: u1 (copy)
    local v3 = math.floor(p2 - u1.BaseMax);
    local v4 = math.max(0, v3) + 1;

    return u1.Prices[v4];
end;

function u1.GetPurchasedCount(p5) -- Line: 39
    -- upvalues: u1 (copy)
    local v6 = math.floor(p5 - u1.BaseMax);

    return math.max(0, v6);
end;

function u1.AbbreviatePrice(p7) -- Line: 45
    if p7 < 1000 then
        local v8 = math.floor(p7 + 0.5);

        return tostring(v8);
    end;

    local v9, v10;

    if p7 >= 1000000000 then
        v9 = 1000000000;
        v10 = "B";
    elseif p7 >= 1000000 then
        v9 = 1000000;
        v10 = "M";
    else
        v9 = 1000;
        v10 = "K";
    end;

    local v11 = math.floor(p7 / v9 * 10 + 0.5) / 10;

    if v11 == math.floor(v11) then
        return string.format("%d%s", v11, v10);
    end;

    return string.format("%g%s", v11, v10);
end;

return u1;