-- Decompiled with Potassium's decompiler.

local u1 = buffer.create(64);
local u2 = buffer.create(256);

for i = 1, 64 do
    local v3 = i - 1;
    local v4 = string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i);
    buffer.writeu8(u1, v3, v4);
    buffer.writeu8(u2, v4, v3);
end;

function encode(p5, p6)
    -- upvalues: u1 (copy)
    local v7 = p6 or buffer.len(p5);
    local v8 = math.ceil(v7 / 3);
    local v9 = v8 * 4;
    local v10 = buffer.create(v9);

    for i = 1, v8 - 1 do
        local v11 = (i - 1) * 4;
        local v12 = buffer.readu32(p5, (i - 1) * 3);
        local v13 = bit32.byteswap(v12);
        local v14 = bit32.rshift(v13, 26);
        local v15 = bit32.rshift(v13, 20);
        local v16 = bit32.band(v15, 63);
        local v17 = bit32.rshift(v13, 14);
        local v18 = bit32.band(v17, 63);
        local v19 = bit32.rshift(v13, 8);
        local v20 = bit32.band(v19, 63);
        local v21 = buffer.readu8(u1, v14);
        buffer.writeu8(v10, v11, v21);
        local v22 = buffer.readu8(u1, v16);
        buffer.writeu8(v10, v11 + 1, v22);
        local v23 = buffer.readu8(u1, v18);
        buffer.writeu8(v10, v11 + 2, v23);
        local v24 = buffer.readu8(u1, v20);
        buffer.writeu8(v10, v11 + 3, v24);
    end;

    local v25 = v7 % 3;

    if v25 == 1 then
        local v26 = buffer.readu8(p5, v7 - 1);
        local v27 = bit32.rshift(v26, 2);
        local v28 = bit32.lshift(v26, 4);
        local v29 = bit32.band(v28, 63);
        local v30 = buffer.readu8(u1, v27);
        buffer.writeu8(v10, v9 - 4, v30);
        local v31 = buffer.readu8(u1, v29);
        buffer.writeu8(v10, v9 - 3, v31);
        buffer.writeu8(v10, v9 - 2, 61);
        buffer.writeu8(v10, v9 - 1, 61);

        return v10;
    end;

    if v25 ~= 2 then
        if v25 == 0 and v7 ~= 0 then
            local v32 = buffer.readu8(p5, v7 - 3);
            local v33 = bit32.lshift(v32, 16);
            local v34 = buffer.readu8(p5, v7 - 2);
            local v35 = bit32.lshift(v34, 8);
            local v36 = buffer.readu8(p5, v7 - 1);
            local v37 = bit32.bor(v33, v35, v36);
            local v38 = bit32.rshift(v37, 18);
            local v39 = bit32.rshift(v37, 12);
            local v40 = bit32.band(v39, 63);
            local v41 = bit32.rshift(v37, 6);
            local v42 = bit32.band(v41, 63);
            local v43 = bit32.band(v37, 63);
            local v44 = buffer.readu8(u1, v38);
            buffer.writeu8(v10, v9 - 4, v44);
            local v45 = buffer.readu8(u1, v40);
            buffer.writeu8(v10, v9 - 3, v45);
            local v46 = buffer.readu8(u1, v42);
            buffer.writeu8(v10, v9 - 2, v46);
            local v47 = buffer.readu8(u1, v43);
            buffer.writeu8(v10, v9 - 1, v47);
        end;

        return v10;
    end;

    local v48 = buffer.readu8(p5, v7 - 2);
    local v49 = bit32.lshift(v48, 8);
    local v50 = buffer.readu8(p5, v7 - 1);
    local v51 = bit32.bor(v49, v50);
    local v52 = bit32.rshift(v51, 10);
    local v53 = bit32.rshift(v51, 4);
    local v54 = bit32.band(v53, 63);
    local v55 = bit32.lshift(v51, 2);
    local v56 = bit32.band(v55, 63);
    local v57 = buffer.readu8(u1, v52);
    buffer.writeu8(v10, v9 - 4, v57);
    local v58 = buffer.readu8(u1, v54);
    buffer.writeu8(v10, v9 - 3, v58);
    local v59 = buffer.readu8(u1, v56);
    buffer.writeu8(v10, v9 - 2, v59);
    buffer.writeu8(v10, v9 - 1, 61);

    return v10;
end;

function decode(p60)
    -- upvalues: u2 (copy)
    local v61 = buffer.len(p60);
    local v62 = math.ceil(v61 / 4);
    local v63 = 0;

    if v61 ~= 0 then
        if buffer.readu8(p60, v61 - 1) == 61 then
            v63 = v63 + 1;
        end;

        if buffer.readu8(p60, v61 - 2) == 61 then
            v63 = v63 + 1;
        end;
    end;

    local v64 = buffer.create(v62 * 3 - v63);

    for i = 1, v62 - 1 do
        local v65 = (i - 1) * 4;
        local v66 = (i - 1) * 3;
        local v67 = buffer.readu8(p60, v65);
        local v68 = buffer.readu8(u2, v67);
        local v69 = buffer.readu8(p60, v65 + 1);
        local v70 = buffer.readu8(u2, v69);
        local v71 = buffer.readu8(p60, v65 + 2);
        local v72 = buffer.readu8(u2, v71);
        local v73 = buffer.readu8(p60, v65 + 3);
        local v74 = buffer.readu8(u2, v73);
        local v75 = bit32.lshift(v68, 18);
        local v76 = bit32.lshift(v70, 12);
        local v77 = bit32.lshift(v72, 6);
        local v78 = bit32.bor(v75, v76, v77, v74);
        local v79 = bit32.rshift(v78, 16);
        local v80 = bit32.rshift(v78, 8);
        local v81 = bit32.band(v80, 255);
        local v82 = bit32.band(v78, 255);
        buffer.writeu8(v64, v66, v79);
        buffer.writeu8(v64, v66 + 1, v81);
        buffer.writeu8(v64, v66 + 2, v82);
    end;

    if v61 ~= 0 then
        local v83 = (v62 - 1) * 4;
        local v84 = (v62 - 1) * 3;
        local v85 = buffer.readu8(p60, v83);
        local v86 = buffer.readu8(u2, v85);
        local v87 = buffer.readu8(p60, v83 + 1);
        local v88 = buffer.readu8(u2, v87);
        local v89 = buffer.readu8(p60, v83 + 2);
        local v90 = buffer.readu8(u2, v89);
        local v91 = buffer.readu8(p60, v83 + 3);
        local v92 = buffer.readu8(u2, v91);
        local v93 = bit32.lshift(v86, 18);
        local v94 = bit32.lshift(v88, 12);
        local v95 = bit32.lshift(v90, 6);
        local v96 = bit32.bor(v93, v94, v95, v92);

        if v63 <= 2 then
            local v97 = bit32.rshift(v96, 16);
            buffer.writeu8(v64, v84, v97);

            if v63 <= 1 then
                local v98 = bit32.rshift(v96, 8);
                local v99 = bit32.band(v98, 255);
                buffer.writeu8(v64, v84 + 1, v99);

                if v63 == 0 then
                    local v100 = bit32.band(v96, 255);
                    buffer.writeu8(v64, v84 + 2, v100);
                end;
            end;
        end;
    end;

    return v64;
end;

function Encode(p101)
    return buffer.tostring(encode(buffer.fromstring(p101)));
end;

function Decode(p102)
    return buffer.tostring(decode(buffer.fromstring(p102)));
end;

return table.freeze({
    Encode = Encode,
    Decode = Decode,
    EncodeBuffer = encode,
    DecodeBuffer = decode
});