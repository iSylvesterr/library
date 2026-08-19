-- Decompiled with Potassium's decompiler.

local u1 = { 1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298 };

local function ProcessNumber(p2, p3) -- Line: 70
    local v4 = "";

    for _ = 1, p3 do
        local v5 = bit32.band(p2, 255);
        v4 = v4 .. string.char(v5);
        p2 = bit32.rshift(p2 - v5, 8);
    end;

    return string.reverse(v4);
end;

local function StringTo32BitNumber(p6, p7) -- Line: 82
    local v8 = 0;

    for i = p7, p7 + 3 do
        v8 = v8 * 256 + string.byte(p6, i);
    end;

    return v8;
end;

local function PreProcess(p9, p10) -- Line: 92
    -- upvalues: ProcessNumber (copy)
    local v11 = 64 - bit32.band(p10 + 9, 63);
    local v12 = ProcessNumber(8 * p10, 8);
    local v13 = p9 .. "\128" .. string.rep("\0", v11) .. v12;
    assert(#v13 % 64 == 0, "Preprocessed content does not have a valid length of 64 bytes, and can not continue.");

    return v13;
end;

local function DigestBlock(p14, p15, p16) -- Line: 105
    -- upvalues: u1 (copy)
    local v17 = table.create(64, 0);

    for i = 1, 16 do
        local v18 = p15 + (i - 1) * 4;
        local v19 = 0;

        for i2 = v18, v18 + 3 do
            v19 = v19 * 256 + string.byte(p14, i2);
        end;

        v17[i] = v19;
    end;

    for i = 17, 64 do
        local v20 = v17[i - 15];
        local v21 = bit32.rrotate(v20, 7);
        local v22 = bit32.rrotate(v20, 18);
        local v23 = bit32.rshift(v20, 3);
        local v24 = bit32.bxor(v21, v22, v23);
        local v25 = v17[i - 2];
        local v26 = bit32.rrotate(v25, 17);
        local v27 = bit32.rrotate(v25, 19);
        local v28 = bit32.rshift(v25, 10);
        local v29 = bit32.bxor(v26, v27, v28);
        v17[i] = v17[i - 16] + v24 + v17[i - 7] + v29;
    end;

    local v30 = p16[1];
    local v31 = p16[2];
    local v32 = p16[3];
    local v33 = p16[4];
    local v34 = p16[5];
    local v35 = p16[6];
    local v36 = p16[7];
    local v37 = p16[8];

    for i = 1, 64 do
        local v38 = bit32.rrotate(v30, 2);
        local v39 = bit32.rrotate(v30, 13);
        local v40 = bit32.rrotate(v30, 22);
        local v41 = bit32.bxor(v38, v39, v40);
        local v42 = bit32.band(v30, v31);
        local v43 = bit32.band(v30, v32);
        local v44 = bit32.band(v31, v32);
        local v45 = v41 + bit32.bxor(v42, v43, v44);
        local v46 = bit32.rrotate(v34, 6);
        local v47 = bit32.rrotate(v34, 11);
        local v48 = bit32.rrotate(v34, 25);
        local v49 = bit32.bxor(v46, v47, v48);
        local v50 = bit32.band(v34, v35);
        local v51 = bit32.bnot(v34);
        local v52 = bit32.band(v51, v36);
        local v53 = bit32.bxor(v50, v52);
        local v54 = v37 + v49 + v53 + u1[i] + v17[i];
        v37 = v36;
        v36 = v35;
        v35 = v34;
        v34 = v33 + v54;
        v33 = v32;
        v32 = v31;
        v31 = v30;
        v30 = v54 + v45;
    end;

    for i, v in ipairs({
        v30,
        v31,
        v32,
        v33,
        v34,
        v35,
        v36,
        v37
    }) do
        p16[i] = bit32.band(p16[i] + v);
    end;
end;

return function(p55) -- Line: 163, Name: Hash
    -- upvalues: ProcessNumber (copy), DigestBlock (copy)
    local v56 = type(p55) == "string";
    assert(v56, "Argument #1 must be type\"string\".");
    local v57 = #p55;
    local v58 = 64 - bit32.band(v57 + 9, 63);
    local v59 = ProcessNumber(8 * v57, 8);
    local v60 = p55 .. "\128" .. string.rep("\0", v58) .. v59;
    assert(#v60 % 64 == 0, "Preprocessed content does not have a valid length of 64 bytes, and can not continue.");
    local v61 = { 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 };

    for i = 1, #v60, 64 do
        DigestBlock(v60, i, v61);
    end;

    local v62 = {};

    for _, v in ipairs(v61) do
        table.insert(v62, ProcessNumber(v, 4));
    end;

    return table.concat(v62);
end;