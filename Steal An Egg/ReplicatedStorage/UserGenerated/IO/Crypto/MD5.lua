-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash);
local u1 = { 3614090360, 3905402710, 606105819, 3250441966, 4118548399, 1200080426, 2821735955, 4249261313, 1770035416, 2336552879, 4294925233, 2304563134, 1804603682, 4254626195, 2792965006, 1236535329, 4129170786, 3225465664, 643717713, 3921069994, 3593408605, 38016083, 3634488961, 3889429448, 568446438, 3275163606, 4107603335, 1163531501, 2850285829, 4243563512, 1735328473, 2368359562, 4294588738, 2272392833, 1839030562, 4259657740, 2763975236, 1272893353, 4139469664, 3200236656, 681279174, 3936430074, 3572445317, 76029189, 3654602809, 3873151461, 530742520, 3299628645, 4096336452, 1126891415, 2878612391, 4237533241, 1700485571, 2399980690, 4293915773, 2240044497, 1873313359, 4264355552, 2734768916, 1309151649, 4149444226, 3174756917, 718787259, 3951481745 };
local u2 = { 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21 };
local u3 = table.create(64, 0);

function processBlocks(p4, p5, p6, p7)
    -- upvalues: u3 (copy), u1 (copy), u2 (copy)
    local v8 = u3;
    local v9 = p4[1];
    local v10 = p4[2];
    local v11 = p4[3];
    local v12 = p4[4];

    for i = p6, p7, 64 do
        local _ = i;

        for i2 = 1, 16 do
            local v13, v14, v15, v16 = string.byte(p5, i, i + 3);
            local v17 = bit32.lshift(v16, 24);
            local v18 = bit32.lshift(v15, 16);
            local v19 = bit32.lshift(v14, 8);
            v8[i2] = bit32.bor(v17, v18, v19, v13);
            local i = i + 4;
        end;

        local v20 = v12;
        local v21 = v11;
        local v22 = v10;
        local v23 = v9;

        for i2 = 0, 15 do
            local v24 = bit32.bxor(v11, v12);
            local v25 = bit32.band(v10, v24);
            local v26 = v9 + bit32.bxor(v12, v25) + u1[i2 + 1] + v8[i2 + 1];
            local v27 = v10 + bit32.lrotate(v26, u2[i2 + 1]);
            v9 = v12;
            v12 = v11;
            v11 = v10;
            v10 = v27;
        end;

        for i2 = 16, 31 do
            local v28 = bit32.bxor(v10, v11);
            local v29 = bit32.band(v12, v28);
            local v30 = v9 + bit32.bxor(v11, v29) + u1[i2 + 1] + v8[(i2 * 5 + 1) % 16 + 1];
            local v31 = v10 + bit32.lrotate(v30, u2[i2 + 1]);
            v9 = v12;
            v12 = v11;
            v11 = v10;
            v10 = v31;
        end;

        for i2 = 32, 47 do
            local v32 = v9 + bit32.bxor(v10, v11, v12) + u1[i2 + 1] + v8[(i2 * 3 + 5) % 16 + 1];
            local v33 = v10 + bit32.lrotate(v32, u2[i2 + 1]);
            v9 = v12;
            v12 = v11;
            v11 = v10;
            v10 = v33;
        end;

        for i2 = 48, 63 do
            local v34 = bit32.bnot(v12);
            local v35 = bit32.bor(v10, v34);
            local v36 = v9 + bit32.bxor(v11, v35) + u1[i2 + 1] + v8[i2 * 7 % 16 + 1];
            local v37 = v10 + bit32.lrotate(v36, u2[i2 + 1]);
            v9 = v12;
            v12 = v11;
            v11 = v10;
            v10 = v37;
        end;

        v9 = bit32.bor(v9 + v23);
        v10 = bit32.bor(v10 + v22);
        v11 = bit32.bor(v11 + v21);
        v12 = bit32.bor(v12 + v20);
    end;

    p4[1] = v9;
    p4[2] = v10;
    p4[3] = v11;
    p4[4] = v12;
end;

function md5(p38)
    local v39 = { 1732584193, 4023233417, 2562383102, 271733878 };
    local v40 = #p38;
    local v41 = v40 % 64;

    if v40 >= 64 then
        processBlocks(v39, p38, 1, v40 - v41);
    end;

    local v42 = bit32.band(v41 + 32, 4294967232);
    local v43 = {
        v41 == 0 and "" or string.sub(p38, -v41),
        "\128",
        string.rep("\0", (v42 - v41 - 9) % 64),
        string.pack("<L", v40 * 8)
    };
    local v44 = table.concat(v43);
    processBlocks(v39, v44, 1, #v44);
    local v45 = buffer.create(16);
    buffer.writeu32(v45, 0, v39[1]);
    buffer.writeu32(v45, 4, v39[2]);
    buffer.writeu32(v45, 8, v39[3]);
    buffer.writeu32(v45, 12, v39[4]);

    return v45;
end;

local v48 = {
    Name = "MD5",
    BlockSize = 64,
    OutputSize = 16,

    Digest = function(p46) -- Line: 180, Name: Digest
        return buffer.tostring(md5(p46));
    end,

    DigestBuffer = function(p47) -- Line: 183, Name: DigestBuffer
        return md5(buffer.tostring(p47));
    end,

    DigestToBuffer = md5
};
table.freeze(v48);

return v48;