-- Decompiled with Potassium's decompiler.

local function Mix(p1, p2, p3) -- Line: 20
    local v4 = bit32.bor(p1, 0);
    local v5 = bit32.bor(p2, 0);
    local v6 = bit32.bor(p3, 0);
    local v7 = bit32.rshift(v6, 13);
    local v8 = bit32.bxor(v4 - v5 - v6, v7);
    local v9 = bit32.lshift(v8, 8);
    local v10 = bit32.bxor(v5 - v6 - v8, v9);
    local v11 = bit32.rshift(v10, 13);
    local v12 = bit32.bxor(v6 - v8 - v10, v11);
    local v13 = bit32.rshift(v12, 12);
    local v14 = bit32.bxor(v8 - v10 - v12, v13);
    local v15 = bit32.lshift(v14, 16);
    local v16 = bit32.bxor(v10 - v12 - v14, v15);
    local v17 = bit32.rshift(v16, 5);
    local v18 = bit32.bxor(v12 - v14 - v16, v17);
    local v19 = bit32.rshift(v18, 3);
    local v20 = bit32.bxor(v14 - v16 - v18, v19);
    local v21 = bit32.lshift(v20, 10);
    local v22 = bit32.bxor(v16 - v18 - v20, v21);
    local v23 = bit32.rshift(v22, 15);

    return bit32.bxor(v18 - v20 - v22, v23);
end;

local function Unpack64(p24) -- Line: 34
    if p24 >= 0 then
        return bit32.bor(p24 // 4294967296, 0), bit32.bor(p24, 0);
    end;

    local v25 = -1 - p24;

    return bit32.bnot(v25 // 4294967296), bit32.bnot(v25);
end;

local function ParseUUID(p26) -- Line: 53
    local v27 = string.sub(p26, 1, 8);
    local v28 = tonumber(v27, 16);
    local v29 = string.sub(p26, 10, 13) .. string.sub(p26, 15, 18);
    local v30 = tonumber(v29, 16);
    local v31 = string.sub(p26, 20, 23) .. string.sub(p26, 25, 28);
    local v32 = tonumber(v31, 16);
    local v33 = string.sub(p26, 29, 36);

    return v28, v30, v32, tonumber(v33, 16);
end;

return table.freeze({
    Mix = Mix,

    DoubleFromInt64 = function(p34, p35) -- Line: 44, Name: DoubleFromInt64
        -- upvalues: Mix (copy)
        local v36, v37;

        if p34 < 0 then
            local v38 = -1 - p34;
            v36 = bit32.bnot(v38 // 4294967296);
            v37 = bit32.bnot(v38);
        else
            v36 = bit32.bor(p34 // 4294967296, 0);
            v37 = bit32.bor(p34, 0);
        end;

        return Mix(v37, v36, p35) / 4294967296;
    end,

    DoubleFromUUID = function(p39, p40) -- Line: 59, Name: DoubleFromUUID
        -- upvalues: Mix (copy)
        local v41 = string.sub(p39, 1, 8);
        local v42 = tonumber(v41, 16);
        local v43 = string.sub(p39, 10, 13) .. string.sub(p39, 15, 18);
        local v44 = tonumber(v43, 16);
        local v45 = string.sub(p39, 20, 23) .. string.sub(p39, 25, 28);
        local v46 = tonumber(v45, 16);
        local v47 = string.sub(p39, 29, 36);
        local v48 = tonumber(v47, 16);

        return Mix(Mix(v42, v44, 2197175160), Mix(v46, v48, 2821953579), p40) / 4294967296;
    end,

    IntegerFromUUID = function(p49, p50, p51, p52) -- Line: 68, Name: IntegerFromUUID
        -- upvalues: Mix (copy)
        local v53 = string.sub(p49, 1, 8);
        local v54 = tonumber(v53, 16);
        local v55 = string.sub(p49, 10, 13) .. string.sub(p49, 15, 18);
        local v56 = tonumber(v55, 16);
        local v57 = string.sub(p49, 20, 23) .. string.sub(p49, 25, 28);
        local v58 = tonumber(v57, 16);
        local v59 = string.sub(p49, 29, 36);
        local v60 = tonumber(v59, 16);
        local v61 = p51 + (p52 - p51 + 1) * (Mix(Mix(v54, v56, 2197175160), Mix(v58, v60, 2821953579), p50) / 4294967296);

        return math.floor(v61);
    end
});