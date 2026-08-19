-- Decompiled with Potassium's decompiler.

local u1 = table.create(90);
local u2 = table.create(90);

for i = 1, 91 do
    u1[i - 1] = string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~\'", i, i);
    u2[string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~\'", i, i)] = i - 1;
end;

local u3 = table.create(5);

local function stringBuilder(p4) -- Line: 30
    -- upvalues: u3 (copy)
    local v5 = #p4;

    for i = 1, v5, 4096 do
        local v6 = math.min(i + 4095, v5);
        local v7 = string.char(table.unpack(p4, i, v6));
        table.insert(u3, v7);
    end;

    local v8 = table.concat(u3);
    table.clear(u3);

    return v8;
end;

return table.freeze({
    encodeBuffer = function(p9, p10) -- Line: 52, Name: encodeBuffer
        -- upvalues: u1 (copy)
        local v11 = buffer.create(buffer.len(p9) * 2);
        local v12 = 0;
        local v13 = 0;
        local v14 = 0;

        for i = 0, buffer.len(p9) - 1 do
            local v15 = buffer.readu8(p9, i);
            local v16 = bit32.lshift(v15, v12);
            v13 = bit32.bor(v13, v16);
            v12 = v12 + 8;

            if v12 > 13 then
                local v17 = bit32.band(v13, 8191);

                if v17 > 88 then
                    v13 = bit32.rshift(v13, 13);
                    v12 = v12 - 13;
                else
                    v17 = bit32.band(v13, 16383);
                    v13 = bit32.rshift(v13, 14);
                    v12 = v12 - 14;
                end;

                local v18 = bit32.lshift(u1[v17 // 91], 8) + u1[v17 % 91];
                buffer.writeu16(v11, v14, v18);
                v14 = v14 + 2;
            end;
        end;

        if v12 > 0 then
            buffer.writeu8(v11, v14, u1[v13 % 91]);
            v14 = v14 + 1;

            if v12 > 7 or v13 > 90 then
                buffer.writeu8(v11, v14, u1[v13 // 91]);
                v14 = v14 + 1;
            end;
        end;

        if p10 then
            return v11;
        end;

        local v19 = buffer.create(v14);
        buffer.copy(v19, 0, v11, 0, v14);

        return v19;
    end,

    decodeBuffer = function(p20, p21) -- Line: 110, Name: decodeBuffer
        -- upvalues: u2 (copy)
        local v22 = buffer.create(buffer.len(p20) * 2);
        local v23 = 0;
        local v24 = -1;
        local v25 = 0;
        local v26 = 0;

        for i = 0, buffer.len(p20) - 1 do
            local v27 = buffer.readu8(p20, i);

            if u2[v27] then
                if v24 == -1 then
                    v24 = u2[v27];
                else
                    local v28 = v24 + u2[v27] * 91;
                    local v29 = bit32.lshift(v28, v25);
                    v26 = bit32.bor(v26, v29);

                    if bit32.band(v28, 8191) > 88 then
                        v25 = v25 + 13;
                    else
                        v25 = v25 + 14;
                    end;

                    while v25 > 7 do
                        buffer.writeu8(v22, v23, v26 % 256);
                        v23 = v23 + 1;
                        v26 = bit32.rshift(v26, 8);
                        v25 = v25 - 8;
                    end;

                    v24 = -1;
                end;
            end;
        end;

        if v24 ~= -1 then
            local v30 = bit32.lshift(v24, v25);
            local v31 = bit32.bor(v26, v30) % 256;
            buffer.writeu8(v22, v23, v31);
            v23 = v23 + 1;
        end;

        if p21 then
            return v22;
        end;

        local v32 = buffer.create(v23);
        buffer.copy(v32, 0, v22, 0, v23);

        return v32;
    end,

    encodeBytes = function(p33) -- Line: 171, Name: encodeBytes
        -- upvalues: u1 (copy)
        local v34 = table.create((math.ceil(#p33 * 1.2308)));
        local v35 = 0;
        local v36 = 0;
        local v37 = 1;

        for _, v in p33 do
            local v38 = bit32.lshift(v, v35);
            v36 = bit32.bor(v36, v38);
            v35 = v35 + 8;

            if v35 > 13 then
                local v39 = bit32.band(v36, 8191);

                if v39 > 88 then
                    v36 = bit32.rshift(v36, 13);
                    v35 = v35 - 13;
                else
                    v39 = bit32.band(v36, 16383);
                    v36 = bit32.rshift(v36, 14);
                    v35 = v35 - 14;
                end;

                v34[v37] = u1[v39 % 91];
                v34[v37 + 1] = u1[math.floor(v39 / 91)];
                v37 = v37 + 2;
            end;
        end;

        if v35 > 0 then
            v34[v37] = u1[v36 % 91];

            if v35 > 7 or v36 > 90 then
                v34[v37 + 1] = u1[math.floor(v36 / 91)];
            end;
        end;

        return v34;
    end,

    decodeBytes = function(p40) -- Line: 220, Name: decodeBytes
        -- upvalues: u2 (copy)
        local v41 = table.create((math.ceil(#p40 / 1.2308)));
        local v42 = -1;
        local v43 = 0;
        local v44 = 0;
        local v45 = 1;

        for _, v in p40 do
            if u2[v] then
                if v42 == -1 then
                    v42 = u2[v];
                else
                    local v46 = v42 + u2[v] * 91;
                    local v47 = bit32.lshift(v46, v43);
                    v44 = bit32.bor(v44, v47);

                    if bit32.band(v46, 8191) > 88 then
                        v43 = v43 + 13;
                    else
                        v43 = v43 + 14;
                    end;

                    while v43 > 7 do
                        v41[v45] = v44 % 256;
                        v45 = v45 + 1;
                        v44 = bit32.rshift(v44, 8);
                        v43 = v43 - 8;
                    end;

                    v42 = -1;
                end;
            end;
        end;

        if v42 ~= -1 then
            local v48 = bit32.lshift(v42, v43);
            v41[v45] = bit32.bor(v44, v48) % 256;
        end;

        return v41;
    end,

    encodeString = function(p49) -- Line: 273, Name: encodeString
        -- upvalues: u1 (copy), stringBuilder (copy)
        local v50 = table.create(#p49 * 1.2308);
        local v51 = 0;
        local v52 = 0;
        local v53 = 1;

        for i = 1, #p49 do
            local v54 = string.byte(p49, i);
            local v55 = bit32.lshift(v54, v51);
            v52 = bit32.bor(v52, v55);
            v51 = v51 + 8;

            if v51 > 13 then
                local v56 = bit32.band(v52, 8191);

                if v56 > 88 then
                    v52 = bit32.rshift(v52, 13);
                    v51 = v51 - 13;
                else
                    v56 = bit32.band(v52, 16383);
                    v52 = bit32.rshift(v52, 14);
                    v51 = v51 - 14;
                end;

                v50[v53] = u1[v56 % 91];
                v50[v53 + 1] = u1[math.floor(v56 / 91)];
                v53 = v53 + 2;
            end;
        end;

        if v51 > 0 then
            v50[v53] = u1[v52 % 91];

            if v51 > 7 or v52 > 90 then
                v50[v53 + 1] = u1[math.floor(v52 / 91)];
            end;
        end;

        return stringBuilder(v50);
    end,

    decodeString = function(p57) -- Line: 319, Name: decodeString
        -- upvalues: u2 (copy), stringBuilder (copy)
        local v58 = table.create((math.ceil(#p57 / 1.2308)));
        local v59 = 1;
        local v60 = -1;
        local v61 = 0;
        local v62 = 0;

        for i = 1, #p57 do
            local v63 = string.byte(p57, i);

            if u2[v63] then
                if v60 == -1 then
                    v60 = u2[v63];
                else
                    local v64 = v60 + u2[v63] * 91;
                    local v65 = bit32.lshift(v64, v61);
                    v62 = bit32.bor(v62, v65);

                    if bit32.band(v64, 8191) > 88 then
                        v61 = v61 + 13;
                    else
                        v61 = v61 + 14;
                    end;

                    while v61 > 7 do
                        v58[v59] = v62 % 256;
                        v59 = v59 + 1;
                        v62 = bit32.rshift(v62, 8);
                        v61 = v61 - 8;
                    end;

                    v60 = -1;
                end;
            end;
        end;

        if v60 ~= -1 then
            local v66 = bit32.lshift(v60, v61);
            v58[v59] = bit32.bor(v62, v66) % 256;
        end;

        return stringBuilder(v58);
    end
});