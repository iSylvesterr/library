-- Decompiled with Potassium's decompiler.

local u1 = { 1, 4, 3, 2, 5, 6 };
local v2 = {};

local function buildOrder(u3) -- Line: 12
    -- upvalues: u1 (copy)
    if u3 <= 0 then
        return {};
    end;

    local v4 = table.create(u3);
    local u5 = table.create(u3);

    local function reserve(p6) -- Line: 20
        -- upvalues: u3 (copy), u5 (copy)
        if p6 and (p6 >= 1 and (p6 <= u3 and not u5[p6])) then
            return p6;
        end;

        for i = 1, u3 do
            if not u5[i] then
                return i;
            end;
        end;

        return math.clamp(p6 or u3, 1, u3);
    end;

    while true do
        local v7;
        local v8 = v8 + v7;
        local v9;

        if not (v7 > 0 and v8 <= v9 or v7 <= 0 and v8 >= v9) then
            break;
        end;

        local v10 = u1[v8];

        if v10 and (v10 >= 1 and (v10 <= u3 and not u5[v10])) then
            local v11 = v10;
        else
            for v11 = 1, u3 do
                if not u5[v11] then
                    break;
                end;
            end;
        end;

        v4[v8] = v11;
        u5[v11] = true;
    end;
end;

function v2.ArrangeEntries(p12) -- Line: 45
    -- upvalues: buildOrder (copy)
    local v13 = #p12;

    if v13 <= 1 then
        return table.clone(p12);
    end;

    local v14 = buildOrder(v13);
    local v15 = table.create(v13);

    for i, v in ipairs(p12) do
        v15[v14[i]] = v;
    end;

    return v15;
end;

function v2.GetDisplayIndex(p16, p17) -- Line: 61
    -- upvalues: buildOrder (copy)
    local v18;

    if p16 >= 1 then
        v18 = p16 <= p17;
    else
        v18 = false;
    end;

    assert(v18, "Invalid rarity index");
    local v19 = buildOrder(p17)[p16];
    assert(v19 ~= nil, "Failed to compute display index");

    return v19;
end;

function v2.GetOrder(p20) -- Line: 72
    -- upvalues: buildOrder (copy)
    return buildOrder(p20);
end;

return v2;