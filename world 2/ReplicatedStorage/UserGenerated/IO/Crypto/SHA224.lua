-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash);
local u1 = { 1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298 };
local u2 = table.create(64, 0);

function processBlocks(p3, p4, p5, p6)
    -- upvalues: u2 (copy), u1 (copy)
    local v7 = u2;
    local v8 = p3[1];
    local v9 = p3[2];
    local v10 = p3[3];
    local v11 = p3[4];
    local v12 = p3[5];
    local v13 = p3[6];
    local v14 = p3[7];
    local v15 = p3[8];

    for i = p5, p6, 64 do
        local _ = i;

        for i2 = 1, 16 do
            local v16, v17, v18, v19 = string.byte(p4, i, i + 3);
            local v20 = bit32.lshift(v16, 24);
            local v21 = bit32.lshift(v17, 16);
            local v22 = bit32.lshift(v18, 8);
            v7[i2] = bit32.bor(v20, v21, v22, v19);
            local i = i + 4;
        end;

        for i2 = 17, 64 do
            local v23 = v7[i2 - 2];
            local v24 = v7[i2 - 15];
            local v25 = bit32.rrotate(v23, 17);
            local v26 = bit32.rrotate(v23, 19);
            local v27 = bit32.rshift(v23, 10);
            local v28 = bit32.bxor(v25, v26, v27) + v7[i2 - 7];
            local v29 = bit32.rrotate(v24, 7);
            local v30 = bit32.rrotate(v24, 18);
            local v31 = bit32.rshift(v24, 3);
            v7[i2] = v28 + bit32.bxor(v29, v30, v31) + v7[i2 - 16];
        end;

        local v32 = v11;
        local v33 = v10;
        local v34 = v14;
        local v35 = v13;
        local v36 = v15;
        local v37 = v9;
        local v38 = v8;
        local v39 = v12;

        for i2 = 1, 64 do
            local v40 = bit32.rrotate(v12, 6);
            local v41 = bit32.rrotate(v12, 11);
            local v42 = bit32.rrotate(v12, 25);
            local v43 = v15 + bit32.bxor(v40, v41, v42) + bit32.band(v12, v13);
            local v44 = bit32.bnot(v12);
            local v45 = v43 + bit32.band(v44, v14) + u1[i2] + v7[i2];
            local v46 = bit32.band(v10, v9);
            local v47 = bit32.bxor(v10, v9);
            local v48 = v46 + bit32.band(v8, v47);
            local v49 = bit32.rrotate(v8, 2);
            local v50 = bit32.rrotate(v8, 13);
            local v51 = bit32.rrotate(v8, 22);
            local v52 = v48 + bit32.bxor(v49, v50, v51);
            v15 = v14;
            v14 = v13;
            v13 = v12;
            v12 = v11 + v45;
            v11 = v10;
            v10 = v9;
            v9 = v8;
            v8 = v45 + v52;
        end;

        v8 = bit32.bor(v8 + v38, 0);
        v9 = bit32.bor(v9 + v37, 0);
        v10 = bit32.bor(v10 + v33, 0);
        v11 = bit32.bor(v11 + v32, 0);
        v12 = bit32.bor(v12 + v39, 0);
        v13 = bit32.bor(v13 + v35, 0);
        v14 = bit32.bor(v14 + v34, 0);
        v15 = bit32.bor(v15 + v36, 0);
    end;

    p3[1] = v8;
    p3[2] = v9;
    p3[3] = v10;
    p3[4] = v11;
    p3[5] = v12;
    p3[6] = v13;
    p3[7] = v14;
    p3[8] = v15;
end;

function sha224(p53)
    local v54 = { 3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428 };
    local v55 = #p53;
    local v56 = v55 % 64;

    if v55 >= 64 then
        processBlocks(v54, p53, 1, v55 - v56);
    end;

    local v57 = bit32.band(v56 + 32, 4294967232);
    local v58 = {
        v56 == 0 and "" or string.sub(p53, -v56),
        "\128",
        string.rep("\0", (v57 - v56 - 9) % 64),
        string.pack(">L", v55 * 8)
    };
    local v59 = table.concat(v58);
    processBlocks(v54, v59, 1, #v59);
    local v60 = buffer.create(28);
    local v61 = bit32.byteswap(v54[1]);
    buffer.writeu32(v60, 0, v61);
    local v62 = bit32.byteswap(v54[2]);
    buffer.writeu32(v60, 4, v62);
    local v63 = bit32.byteswap(v54[3]);
    buffer.writeu32(v60, 8, v63);
    local v64 = bit32.byteswap(v54[4]);
    buffer.writeu32(v60, 12, v64);
    local v65 = bit32.byteswap(v54[5]);
    buffer.writeu32(v60, 16, v65);
    local v66 = bit32.byteswap(v54[6]);
    buffer.writeu32(v60, 20, v66);
    local v67 = bit32.byteswap(v54[7]);
    buffer.writeu32(v60, 24, v67);

    return v60;
end;

local v70 = {
    Name = "SHA-224",
    BlockSize = 64,
    OutputSize = 28,

    Digest = function(p68) -- Line: 172, Name: Digest
        return buffer.tostring(sha224(p68));
    end,

    DigestBuffer = function(p69) -- Line: 175, Name: DigestBuffer
        return sha224(buffer.tostring(p69));
    end,

    DigestToBuffer = sha224
};
table.freeze(v70);

return v70;