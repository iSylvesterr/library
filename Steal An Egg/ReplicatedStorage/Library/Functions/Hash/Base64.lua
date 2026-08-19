-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};

for i = 65, 90 do
    table.insert(u1, i);
end;

for i = 97, 122 do
    table.insert(u1, i);
end;

table.insert(u1, 48);
table.insert(u1, 49);
table.insert(u1, 50);
table.insert(u1, 51);
table.insert(u1, 52);
table.insert(u1, 53);
table.insert(u1, 54);
table.insert(u1, 55);
table.insert(u1, 56);
table.insert(u1, 57);
table.insert(u1, 43);
table.insert(u1, 47);

for i, v in ipairs(u1) do
    u2[v] = i;
end;

local v3 = {};
local rshift = bit32.rshift;
local lshift = bit32.lshift;
local band = bit32.band;

function v3.Encode(p4) -- Line: 38
    -- upvalues: rshift (copy), band (copy), lshift (copy), u1 (copy)
    local v5 = 0;
    local v6 = {};

    for i = 1, #p4, 3 do
        local v7, v8, v9 = string.byte(p4, i, i + 2);
        local v10 = rshift(v7, 2);
        local v11 = lshift(band(v7, 3), 4) + rshift(v8 or 0, 4);
        local v12 = lshift(band(v8 or 0, 15), 2) + rshift(v9 or 0, 6);
        local v13 = band(v9 or 0, 63);
        local v14 = v5 + 1;
        v6[v14] = u1[v10 + 1];
        local v15 = v14 + 1;
        v6[v15] = u1[v11 + 1];
        local v16 = v15 + 1;
        v6[v16] = v8 and u1[v12 + 1] or 61;
        v5 = v16 + 1;
        v6[v5] = v9 and u1[v13 + 1] or 61;
    end;

    local v17 = 0;
    local v18 = {};

    for i = 1, v5, 4096 do
        v17 = v17 + 1;
        local v19 = i + 4096 - 1;
        v18[v17] = string.char(table.unpack(v6, i, v5 < v19 and v5 and v5 or v19));
    end;

    return table.concat(v18);
end;

function v3.Decode(p20) -- Line: 83
    -- upvalues: u2 (copy), lshift (copy), rshift (copy), band (copy)
    local v21 = 0;
    local v22 = {};

    for i = 1, #p20, 4 do
        local v23, v24, v25, v26 = string.byte(p20, i, i + 3);
        local v27 = u2[v24] - 1;
        local v28 = (u2[v25] or 1) - 1;
        local v29 = (u2[v26] or 1) - 1;
        local v30 = lshift(u2[v23] - 1, 2) + rshift(v27, 4);
        local v31 = lshift(band(v27, 15), 4) + rshift(v28, 2);
        local v32 = lshift(band(v28, 3), 6) + v29;
        v21 = v21 + 1;
        v22[v21] = v30;

        if v25 ~= 61 then
            v21 = v21 + 1;
            v22[v21] = v31;
        end;

        if v26 ~= 61 then
            v21 = v21 + 1;
            v22[v21] = v32;
        end;
    end;

    local v33 = 0;
    local v34 = {};

    for i = 1, v21, 4096 do
        v33 = v33 + 1;
        local v35 = i + 4096 - 1;
        v34[v33] = string.char(table.unpack(v22, i, v21 < v35 and v21 and v21 or v35));
    end;

    return table.concat(v34);
end;

return v3;