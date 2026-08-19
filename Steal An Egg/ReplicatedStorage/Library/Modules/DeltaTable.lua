-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.MakeDeltaTable(p2, p3, p4) -- Line: 4
    -- upvalues: u1 (copy)
    if p3 == nil then
        return p2:DeepCopy(p4);
    end;

    local v5 = 0;
    local v6 = {};

    for i, v in pairs(p4) do
        if p3[i] == nil then
            v6[i] = v;
        elseif type(p4[i]) == "table" then
            local v7, v8 = u1:MakeDeltaTable(p3[i], p4[i]);

            if v8 > 0 then
                v5 = v5 + 1;
                v6[i] = v7;
            end;
        else
            local v9 = p4[i];

            if v9 ~= p3[i] then
                v5 = v5 + 1;
                v6[i] = v9;
            end;
        end;
    end;

    for i, _ in pairs(p3) do
        if p4[i] == nil then
            if v6.__deletions == nil then
                v6.__deletions = {};
            end;

            table.insert(v6.__deletions, i);
        end;
    end;

    return v6, v5;
end;

function u1.ApplyDeltaTable(p10, p11, p12) -- Line: 46
    local v13 = p11 == nil and {} or p11;
    local v14 = p10:DeepCopy(v13);
    local v15 = v14 == nil and {} or v14;

    for i, _ in pairs(p12) do
        if type(p12[i]) == "table" then
            v15[i] = p10:ApplyDeltaTable(v13[i], p12[i]);
        else
            v15[i] = p12[i];
        end;
    end;

    if v15.__deletions ~= nil then
        for _, v in pairs(v15.__deletions) do
            v15[v] = nil;
        end;
    end;

    return v15;
end;

function u1.DeepCopy(p16, p17) -- Line: 73
    local function Deep(p18) -- Line: 74
        -- upvalues: Deep (copy)
        local v19 = table.create(#p18);

        for i, v in pairs(p18) do
            if type(v) == "table" then
                v19[i] = Deep(v);
            else
                v19[i] = v;
            end;
        end;

        return v19;
    end;

    return Deep(p17);
end;

function u1.DeepCopySharedTable(p20, p21) -- Line: 88
    local function u24(p22) -- Line: 89
        -- upvalues: u24 (copy)
        local v23 = {};

        for i, v in p22 do
            if type(v) == "table" then
                v23[i] = u24(v);
            else
                v23[i] = v;
            end;
        end;

        return v23;
    end;

    return u24(p21);
end;

return u1;