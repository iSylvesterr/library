-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash);
local u1 = table.create(80, 0);

function processBlocks(p2, p3, p4, p5)
    -- upvalues: u1 (copy)
    local v6 = u1;
    local v7 = p2[1];
    local v8 = p2[2];
    local v9 = p2[3];
    local v10 = p2[4];
    local v11 = p2[5];

    for i = p4, p5, 64 do
        local _ = i;

        for i2 = 1, 16 do
            local v12, v13, v14, v15 = string.byte(p3, i, i + 3);
            local v16 = bit32.lshift(v12, 24);
            local v17 = bit32.lshift(v13, 16);
            local v18 = bit32.lshift(v14, 8);
            v6[i2] = bit32.bor(v16, v17, v18, v15);
            local i = i + 4;
        end;

        for i2 = 17, 80 do
            local v19 = bit32.bxor(v6[i2 - 3], v6[i2 - 8], v6[i2 - 14], v6[i2 - 16]);
            v6[i2] = bit32.lrotate(v19, 1);
        end;

        local v20 = v8;
        local v21 = v11;
        local v22 = v10;
        local v23 = v9;
        local v24 = v7;

        for i2 = 1, 20 do
            local v25 = bit32.lrotate(v7, 5) + bit32.band(v8, v9);
            local v26 = bit32.bnot(v8);
            local v27 = v25 + bit32.band(v26, v10) + v11 + 1518500249 + v6[i2];
            local v28 = bit32.lrotate(v8, 30);
            v11 = v10;
            v10 = v9;
            v9 = v28;
            v8 = v7;
            v7 = v27;
        end;

        for i2 = 21, 40 do
            local v29 = bit32.lrotate(v7, 5) + bit32.bxor(v8, v9, v10) + v11 + 1859775393 + v6[i2];
            local v30 = bit32.lrotate(v8, 30);
            v11 = v10;
            v10 = v9;
            v9 = v30;
            v8 = v7;
            v7 = v29;
        end;

        for i2 = 41, 60 do
            local v31 = bit32.lrotate(v7, 5) + bit32.band(v10, v9);
            local v32 = bit32.bxor(v10, v9);
            local v33 = v31 + bit32.band(v8, v32) + v11 + 2400959708 + v6[i2];
            local v34 = bit32.lrotate(v8, 30);
            v11 = v10;
            v10 = v9;
            v9 = v34;
            v8 = v7;
            v7 = v33;
        end;

        for i2 = 61, 80 do
            local v35 = bit32.lrotate(v7, 5) + bit32.bxor(v8, v9, v10) + v11 + 3395469782 + v6[i2];
            local v36 = bit32.lrotate(v8, 30);
            v11 = v10;
            v10 = v9;
            v9 = v36;
            v8 = v7;
            v7 = v35;
        end;

        v7 = bit32.bor(v7 + v24, 0);
        v8 = bit32.bor(v8 + v20, 0);
        v9 = bit32.bor(v9 + v23, 0);
        v10 = bit32.bor(v10 + v22, 0);
        v11 = bit32.bor(v11 + v21, 0);
    end;

    p2[1] = v7;
    p2[2] = v8;
    p2[3] = v9;
    p2[4] = v10;
    p2[5] = v11;
end;

function sha1(p37)
    local v38 = { 1732584193, 4023233417, 2562383102, 271733878, 3285377520 };
    local v39 = #p37;
    local v40 = v39 % 64;

    if v39 >= 64 then
        processBlocks(v38, p37, 1, v39 - v40);
    end;

    local v41 = bit32.band(v40 + 32, 4294967232);
    local v42 = {
        v40 == 0 and "" or string.sub(p37, -v40),
        "\128",
        string.rep("\0", (v41 - v40 - 9) % 64),
        string.pack(">L", v39 * 8)
    };
    local v43 = table.concat(v42);
    processBlocks(v38, v43, 1, #v43);
    local v44 = buffer.create(20);
    local v45 = bit32.byteswap(v38[1]);
    buffer.writeu32(v44, 0, v45);
    local v46 = bit32.byteswap(v38[2]);
    buffer.writeu32(v44, 4, v46);
    local v47 = bit32.byteswap(v38[3]);
    buffer.writeu32(v44, 8, v47);
    local v48 = bit32.byteswap(v38[4]);
    buffer.writeu32(v44, 12, v48);
    local v49 = bit32.byteswap(v38[5]);
    buffer.writeu32(v44, 16, v49);

    return v44;
end;

local v52 = {
    Name = "SHA-1",
    BlockSize = 64,
    OutputSize = 20,

    Digest = function(p50) -- Line: 153, Name: Digest
        return buffer.tostring(sha1(p50));
    end,

    DigestBuffer = function(p51) -- Line: 156, Name: DigestBuffer
        return sha1(buffer.tostring(p51));
    end,

    DigestToBuffer = sha1
};
table.freeze(v52);

return v52;