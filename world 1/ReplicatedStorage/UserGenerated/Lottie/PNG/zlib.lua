-- Decompiled with Potassium's decompiler.

local u1 = { 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258 };
local u2 = {};
local u3 = {};
local u4 = { 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0 };
local u5 = {};
local u6 = { 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577 };

local function createHuffmanTable(p7) -- Line: 56
    local v8 = table.create(15, 0);
    v8[0] = 0;

    for _, v in p7 do
        if v > 0 then
            v8[v] = (v8[v] or 0) + 1;
        end;
    end;

    local v9 = table.create(15);
    local v10 = 1;

    for i = 1, 15 do
        v10 = bit32.lshift(v10 + v8[i - 1], 1);
        v9[i] = v10;
    end;

    local v11 = {};
    local v12 = {};
    local v13 = {};

    for i, v in p7 do
        if v > 0 then
            v11[v9[v]] = i - 1;
            v12[i - 1] = bit32.extract(v9[v], 0, v);
            v13[i - 1] = v;
            v9[v] = v9[v] + 1;
        end;
    end;

    return v11, v12, v13;
end;

local v14 = { 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8 };
local u15 = { 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 };
local u16 = { 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13 };

for i = 3, 258 do
    local v17 = nil;

    for i2 = #u1, 1, -1 do
        if u1[i2] <= i then
            v17 = i2;
            break;
        end;
    end;

    u2[i] = 256 + v17;
    u3[i] = i - u1[v17];
    u5[i] = u4[v17 - 8] or 0;
end;

local u18 = {};

for i = 1, 1024 do
    local v19 = nil;

    for i2 = #u6, 1, -1 do
        if u6[i2] <= i then
            v19 = i2;
            break;
        end;
    end;

    u18[i] = v19;
end;

local u20, u21, u22 = createHuffmanTable(v14);
local u23, u24, u25 = createHuffmanTable(table.create(32, 5));

local function getStoreSize(p26) -- Line: 118
    return math.ceil(p26 / 32768) * 5 + p26;
end;

local function getDistIdx(p27) -- Line: 122
    -- upvalues: u18 (copy)
    return p27 >= 1025 and (p27 < 1537 and 21 or (p27 < 2049 and 22 or (p27 < 3073 and 23 or (p27 < 4097 and 24 or (p27 < 6145 and 25 or (p27 < 8193 and 26 or (p27 < 12289 and 27 or (p27 < 16385 and 28 or (p27 < 24577 and 29 or 30))))))))) or u18[p27];
end;

local function adler32(p28, p29, p30) -- Line: 139
    local v31 = 1;
    local v32 = 0;
    local v33 = 0;

    for i = p29, p29 + p30 - 1 do
        v31 = v31 + buffer.readu8(p28, i);
        v32 = v32 + v31;
        v33 = v33 + 1;

        if v33 == 8400000 then
            v31 = v31 % 65521;
            v32 = v32 % 65521;
            v33 = 0;
        end;
    end;

    local v34 = bit32.lshift(v32 % 65521, 16);

    return bit32.bor(v34, v31 % 65521);
end;

return {
    inflate = function(u35, p36) -- Line: 156, Name: inflate
        -- upvalues: u20 (copy), u23 (copy), u15 (copy), createHuffmanTable (copy), u1 (copy), u4 (copy), u6 (copy), u16 (copy), adler32 (copy)
        local v37, v38, v39, u40, v41, v42, v43, v44, u45, v46, v47, v48, v49, v50, v51, v52, v53;
        local v54 = 0;

        while true do
            local v55, v56, v57;

            if v54 == 0 then
                v54 = -1;
                local v58 = buffer.readu8(u35, 0);
                local v59 = buffer.readu8(u35, 1);
                local v60 = bit32.extract(v58, 0, 4) == 8;
                assert(v60, "invalid zlib comp method");
                local v61 = bit32.extract(v58, 4, 4) <= 7;
                assert(v61, "invalid zlib window size");
                local v62 = bit32.extract(v59, 5, 1) == 0;
                assert(v62, "preset dictionary is not allowed");
                local v63 = bit32.lshift(v58, 8);
                local v64 = bit32.bor(v63, v59) % 31 == 0;
                assert(v64, "zlib header sum mismatch");
                u45 = 2;
                u40 = 0;

                local function readBit() -- Line: 167
                    -- upvalues: u35 (copy), u45 (ref), u40 (ref)
                    local v65 = buffer.readu8(u35, u45);
                    local v66 = bit32.extract(v65, u40);
                    u40 = u40 + 1;

                    if u40 == 8 then
                        u40 = 0;
                        u45 = u45 + 1;
                    end;

                    return v66;
                end;

                local function readBits(p67) -- Line: 177
                    -- upvalues: u35 (copy), u45 (ref), u40 (ref)
                    local v68 = buffer.readbits(u35, u45 * 8 + u40, p67);
                    u40 = u40 + p67;
                    u45 = u45 + bit32.rshift(u40, 3);
                    u40 = bit32.band(u40, 7);

                    return v68;
                end;

                local function readHuffmanTable(p69) -- Line: 185
                    -- upvalues: u35 (copy), u45 (ref), u40 (ref)
                    local v70 = buffer.readu8(u35, u45);
                    local v71 = bit32.extract(v70, u40);
                    u40 = u40 + 1;

                    if u40 == 8 then
                        u40 = 0;
                        u45 = u45 + 1;
                    end;

                    local v72 = 2 + v71;

                    while not p69[v72] do
                        local v73 = buffer.readu8(u35, u45);
                        local v74 = bit32.extract(v73, u40);
                        u40 = u40 + 1;

                        if u40 == 8 then
                            u40 = 0;
                            u45 = u45 + 1;
                        end;

                        v72 = 2 * v72 + v74;
                    end;

                    return p69[v72];
                end;

                v43 = 0;
                local v75;

                while true do
                    local v76 = buffer.readu8(u35, u45);
                    v38 = bit32.extract(v76, u40);
                    u40 = u40 + 1;

                    if u40 == 8 then
                        u40 = 0;
                        u45 = u45 + 1;
                    end;

                    v75 = buffer.readbits(u35, u45 * 8 + u40, 2);
                    u40 = u40 + 2;
                    u45 = u45 + bit32.rshift(u40, 3);
                    u40 = bit32.band(u40, 7);
                    assert(v75 ~= 3, "reserved btype");

                    if v75 ~= 0 then
                        break;
                    end;

                    if u40 > 0 then
                        u45 = u45 + 1;
                        u40 = 0;
                    end;

                    local v77 = buffer.readu16(u35, u45);
                    local v78 = buffer.readu16(u35, u45 + 2);
                    local v79 = bit32.bxor(v77, v78) == 65535;
                    assert(v79, "len ~= nlen");
                    u45 = u45 + 4;
                    buffer.copy(p36, v43, u35, u45, v77);
                    v43 = v43 + v77;
                    u45 = u45 + v77;
                    ::l0::;

                    if v38 == 1 then
                        if u40 > 0 then
                            u40 = 0;
                            u45 = u45 + 1;
                        end;

                        v39 = adler32(p36, 0, buffer.len(p36));
                        v41 = buffer.readu32(u35, u45);
                        v44 = v39 == bit32.byteswap(v41);
                        assert(v44, "adler-32 checksum mismatch");

                        return v43;
                    end;
                end;

                v42 = u20;
                v50 = u23;

                if v75 ~= 2 then
                    ::l2::;
                    v55 = 2;
                    v56 = buffer.readu8(u35, u45);
                    v57 = bit32.extract(v56, u40);
                    u40 = u40 + 1;

                    if u40 == 8 then
                        u40 = 0;
                        u45 = u45 + 1;
                    end;

                    v51 = v55 + v57;
                    v46 = v42;
                    v54 = 3;
                    continue;
                end;

                local v80 = buffer.readbits(u35, u45 * 8 + u40, 5);
                u40 = u40 + 5;
                u45 = u45 + bit32.rshift(u40, 3);
                u40 = bit32.band(u40, 7);
                v37 = v80 + 257;
                local v81 = buffer.readbits(u35, u45 * 8 + u40, 5);
                u40 = u40 + 5;
                u45 = u45 + bit32.rshift(u40, 3);
                u40 = bit32.band(u40, 7);
                v47 = v81 + 1;
                local v82 = buffer.readbits(u35, u45 * 8 + u40, 4);
                u40 = u40 + 4;
                u45 = u45 + bit32.rshift(u40, 3);
                u40 = bit32.band(u40, 7);
                local v83 = table.create(19, 0);

                for i = 1, v82 + 4 do
                    local v84 = u15[i] + 1;
                    local v85 = buffer.readbits(u35, u45 * 8 + u40, 3);
                    u40 = u40 + 3;
                    u45 = u45 + bit32.rshift(u40, 3);
                    u40 = bit32.band(u40, 7);
                    v83[v84] = v85;
                end;

                v52 = createHuffmanTable(v83);
                v48 = table.create(v37);
                v49 = nil;
                v54 = 1;
                continue;
            elseif v54 == 1 then
                v54 = -1;
                local v86 = buffer.readu8(u35, u45);
                local v87 = bit32.extract(v86, u40);
                u40 = u40 + 1;

                if u40 == 8 then
                    u40 = 0;
                    u45 = u45 + 1;
                end;

                local v88 = 2 + v87;

                while not v52[v88] do
                    local v89 = buffer.readu8(u35, u45);
                    local v90 = bit32.extract(v89, u40);
                    u40 = u40 + 1;

                    if u40 == 8 then
                        u40 = 0;
                        u45 = u45 + 1;
                    end;

                    v88 = 2 * v88 + v90;
                end;

                local v91 = v52[v88];
                local v92 = 1;

                if v91 <= 15 then
                    v49 = v91;
                elseif v91 == 16 then
                    local v93 = buffer.readbits(u35, u45 * 8 + u40, 2);
                    u40 = u40 + 2;
                    u45 = u45 + bit32.rshift(u40, 3);
                    u40 = bit32.band(u40, 7);
                    v92 = v93 + 3;
                elseif v91 == 17 then
                    v49 = 0;
                    local v94 = buffer.readbits(u35, u45 * 8 + u40, 3);
                    u40 = u40 + 3;
                    u45 = u45 + bit32.rshift(u40, 3);
                    u40 = bit32.band(u40, 7);
                    v92 = v94 + 3;
                elseif v91 == 18 then
                    v49 = 0;
                    local v95 = buffer.readbits(u35, u45 * 8 + u40, 7);
                    u40 = u40 + 7;
                    u45 = u45 + bit32.rshift(u40, 3);
                    u40 = bit32.band(u40, 7);
                    v92 = v95 + 11;
                end;

                for _ = 1, v92 do
                    table.insert(v48, v49);
                end;

                if v37 <= #v48 then
                    v42 = createHuffmanTable(v48);
                    local v96 = table.create(v47);
                    local v97 = nil;
                    local v98 = buffer.readu8(u35, u45);
                    local v99 = bit32.extract(v98, u40);
                    u40 = u40 + 1;

                    if u40 == 8 then
                        u40 = 0;
                        u45 = u45 + 1;
                    end;

                    local v100 = 2 + v99;

                    while not v52[v100] do
                        local v101 = buffer.readu8(u35, u45);
                        local v102 = bit32.extract(v101, u40);
                        u40 = u40 + 1;

                        if u40 == 8 then
                            u40 = 0;
                            u45 = u45 + 1;
                        end;

                        v100 = 2 * v100 + v102;
                    end;

                    local v103 = v52[v100];
                    local v104 = 1;

                    if v103 <= 15 then
                        v97 = v103;
                    elseif v103 == 16 then
                        local v105 = buffer.readbits(u35, u45 * 8 + u40, 2);
                        u40 = u40 + 2;
                        u45 = u45 + bit32.rshift(u40, 3);
                        u40 = bit32.band(u40, 7);
                        v104 = v105 + 3;
                    elseif v103 == 17 then
                        v97 = 0;
                        local v106 = buffer.readbits(u35, u45 * 8 + u40, 3);
                        u40 = u40 + 3;
                        u45 = u45 + bit32.rshift(u40, 3);
                        u40 = bit32.band(u40, 7);
                        v104 = v106 + 3;
                    elseif v103 == 18 then
                        v97 = 0;
                        local v107 = buffer.readbits(u35, u45 * 8 + u40, 7);
                        u40 = u40 + 7;
                        u45 = u45 + bit32.rshift(u40, 3);
                        u40 = bit32.band(u40, 7);
                        v104 = v107 + 11;
                    end;

                    for _ = 1, v104 do
                        table.insert(v96, v97);
                    end;

                    if v47 <= #v96 then
                        v50 = createHuffmanTable(v96);
                        v55 = 2;
                        v56 = buffer.readu8(u35, u45);
                        v57 = bit32.extract(v56, u40);
                        u40 = u40 + 1;

                        if u40 == 8 then
                            u40 = 0;
                            u45 = u45 + 1;
                        end;

                        v51 = v55 + v57;
                        v46 = v42;
                        v54 = 3;
                        continue;
                    end;

                    goto l6;
                end;

                v54 = 1;
                continue;
            elseif v54 == 2 then
                v54 = -1;
                local v108 = buffer.readu8(u35, u45);
                local v109 = bit32.extract(v108, u40);
                u40 = u40 + 1;

                if u40 == 8 then
                    u40 = 0;
                    u45 = u45 + 1;
                end;

                v51 = 2 * v51 + v109;
                v54 = 3;
                continue;
            elseif v54 == 3 then
                v54 = -1;

                if v42[v51] then
                    v54 = 4;
                    continue;
                else
                    v54 = 2;
                    continue;
                end;

                v54 = 4;
                continue;
            elseif v54 == 4 then
                v54 = -1;
                v53 = v42[v51];

                if v53 < 256 then
                    buffer.writeu8(p36, v43, v53);
                    v43 = v43 + 1;
                elseif v53 > 256 then
                    local v110 = u1[v53 - 256];

                    if v53 > 268 then
                        local v111 = u4[v53 - 264];
                        local v112 = buffer.readbits(u35, u45 * 8 + u40, v111);
                        u40 = u40 + v111;
                        u45 = u45 + bit32.rshift(u40, 3);
                        u40 = bit32.band(u40, 7);
                        v110 = v110 + v112;
                    elseif v53 > 264 then
                        local v113 = buffer.readu8(u35, u45);
                        local v114 = bit32.extract(v113, u40);
                        u40 = u40 + 1;

                        if u40 == 8 then
                            u40 = 0;
                            u45 = u45 + 1;
                        end;

                        v110 = v110 + v114;
                    end;

                    local v115 = buffer.readu8(u35, u45);
                    local v116 = bit32.extract(v115, u40);
                    u40 = u40 + 1;

                    if u40 == 8 then
                        u40 = 0;
                        u45 = u45 + 1;
                    end;

                    local v117 = 2 + v116;
                    local v118 = v50;

                    while not v50[v117] do
                        local v119 = buffer.readu8(u35, u45);
                        local v120 = bit32.extract(v119, u40);
                        u40 = u40 + 1;

                        if u40 == 8 then
                            u40 = 0;
                            u45 = u45 + 1;
                        end;

                        v117 = 2 * v117 + v120;
                    end;

                    local v121 = v50[v117];
                    local v122 = u6[v121 + 1];

                    if v121 > 5 then
                        local v123 = u16[v121];
                        local v124 = buffer.readbits(u35, u45 * 8 + u40, v123);
                        u40 = u40 + v123;
                        u45 = u45 + bit32.rshift(u40, 3);
                        u40 = bit32.band(u40, 7);
                        v122 = v122 + v124;
                    elseif v121 > 3 then
                        local v125 = buffer.readu8(u35, u45);
                        local v126 = bit32.extract(v125, u40);
                        u40 = u40 + 1;

                        if u40 == 8 then
                            u40 = 0;
                            u45 = u45 + 1;
                        end;

                        v122 = v122 + v126;
                    end;

                    if v110 <= v122 then
                        buffer.copy(p36, v43, p36, v43 - v122, v110);
                        v43 = v43 + v110;
                        v50 = v118;
                    else
                        repeat
                            local v127 = math.min(v110, v122);
                            buffer.copy(p36, v43, p36, v43 - v122, v127);
                            v43 = v43 + v127;
                            v110 = v110 - v127;
                            v122 = v122 + v127;
                        until v110 == 0;

                        v50 = v118;
                    end;

                    v54 = 5;
                    continue;
                end;

                v54 = 5;
                continue;
            elseif v54 == 5 then
                v54 = -1;

                if v53 == 256 then
                    if v38 == 1 then
                        if u40 > 0 then
                            u40 = 0;
                            u45 = u45 + 1;
                        end;

                        v39 = adler32(p36, 0, buffer.len(p36));
                        v41 = buffer.readu32(u35, u45);
                        v44 = v39 == bit32.byteswap(v41);
                        assert(v44, "adler-32 checksum mismatch");

                        return v43;
                    end;
                end;

                v42 = v46;
                v55 = 2;
                v56 = buffer.readu8(u35, u45);
                v57 = bit32.extract(v56, u40);
                u40 = u40 + 1;

                if u40 == 8 then
                    u40 = 0;
                    u45 = u45 + 1;
                end;

                v51 = v55 + v57;
                v46 = v42;
                v54 = 3;
                continue;
                break;
            else
                break;
            end;
        end;
    end,

    deflate = function(p128) -- Line: 322, Name: deflate
        -- upvalues: u21 (copy), u22 (copy), u2 (copy), u3 (copy), u5 (copy), getDistIdx (copy), u24 (copy), u25 (copy), u6 (copy), u16 (copy), adler32 (copy)
        local v129 = buffer.len(p128);
        local u130 = buffer.create(math.ceil(v129 / 32768) * 5 + v129 + 6);
        buffer.writeu16(u130, 0, 24184);
        local u131 = 2;
        local u132 = 0;

        local function writeBits(p133, p134) -- Line: 333
            -- upvalues: u130 (copy), u131 (ref), u132 (ref)
            buffer.writebits(u130, u131 * 8 + u132, p134, p133);
            u132 = u132 + p134;
            u131 = u131 + bit32.rshift(u132, 3);
            u132 = bit32.band(u132, 7);
        end;

        local function writeHuffmanBits(p135, p136) -- Line: 341
            -- upvalues: u130 (copy), u131 (ref), u132 (ref)
            local v137 = bit32.rshift(p135, 1);
            local v138 = bit32.band(v137, 1431655765);
            local v139 = bit32.lshift(p135, 1);
            local v140 = bit32.band(v139, 2863311530);
            local v141 = bit32.bor(v138, v140);
            local v142 = bit32.rshift(v141, 2);
            local v143 = bit32.band(v142, 858993459);
            local v144 = bit32.lshift(v141, 2);
            local v145 = bit32.band(v144, 3435973836);
            local v146 = bit32.bor(v143, v145);
            local v147 = bit32.rshift(v146, 4);
            local v148 = bit32.band(v147, 252645135);
            local v149 = bit32.lshift(v146, 4);
            local v150 = bit32.band(v149, 4042322160);
            local v151 = bit32.bor(v148, v150);
            local v152 = bit32.rshift(v151, 8);
            local v153 = bit32.band(v152, 16711935);
            local v154 = bit32.lshift(v151, 8);
            local v155 = bit32.band(v154, 4278255360);
            local v156 = bit32.bor(v153, v155);
            local v157 = bit32.rshift(v156, 16);
            local v158 = bit32.lshift(v156, 16);
            local v159 = bit32.bor(v157, v158);
            local v160 = bit32.rshift(v159, 32 - p136);
            local v161 = bit32.lshift(1, p136) - 1;
            local v162 = bit32.band(v160, v161);
            buffer.writebits(u130, u131 * 8 + u132, p136, v162);
            u132 = u132 + p136;
            u131 = u131 + bit32.rshift(u132, 3);
            u132 = bit32.band(u132, 7);
        end;

        local function writeLitOrLen(p163) -- Line: 351
            -- upvalues: writeHuffmanBits (copy), u21 (ref), u22 (ref)
            writeHuffmanBits(u21[p163], u22[p163]);
        end;

        local function writeBackRef(p164, p165) -- Line: 355
            -- upvalues: u2 (ref), writeHuffmanBits (copy), u21 (ref), u22 (ref), u3 (ref), u5 (ref), u130 (copy), u131 (ref), u132 (ref), getDistIdx (ref), u24 (ref), u25 (ref), u6 (ref), u16 (ref)
            local v166 = u2[p165];
            writeHuffmanBits(u21[v166], u22[v166]);

            if p165 > 10 then
                local v167 = u5[p165];
                buffer.writebits(u130, u131 * 8 + u132, v167, u3[p165]);
                u132 = u132 + v167;
                u131 = u131 + bit32.rshift(u132, 3);
                u132 = bit32.band(u132, 7);
            end;

            local v168 = getDistIdx(p164);
            writeHuffmanBits(u24[v168 - 1], u25[v168 - 1]);

            if v168 > 3 then
                local v169 = u16[v168 - 1];
                buffer.writebits(u130, u131 * 8 + u132, v169, p164 - u6[v168]);
                u132 = u132 + v169;
                u131 = u131 + bit32.rshift(u132, 3);
                u132 = bit32.band(u132, 7);
            end;
        end;

        local function getLitOrLenSize(p170) -- Line: 367
            -- upvalues: u22 (ref)
            return u22[p170];
        end;

        local function getBackRefSize(p171, p172) -- Line: 371
            -- upvalues: getDistIdx (ref), u2 (ref), u22 (ref), u5 (ref), u25 (ref), u16 (ref)
            local v173 = getDistIdx(p171);

            return u22[u2[p172]] + u5[p172] + u25[v173 - 1] + (u16[v173 - 1] or 0);
        end;

        local u174 = {};
        local u175 = {};
        local u176 = {};
        local u177 = 0;

        local function insertNode(p178, p179) -- Line: 384
            -- upvalues: u177 (ref), u174 (copy), u175 (copy)
            u177 = u177 + 1;
            u174[u177] = p178;
            u175[u177] = p179;

            return u177;
        end;

        local function clearTables() -- Line: 391
            -- upvalues: u174 (copy), u175 (copy), u176 (copy), u177 (ref)
            table.clear(u174);
            table.clear(u175);
            table.clear(u176);
            u177 = 0;
        end;

        for i = 0, v129 - 1, 32768 do
            local v180 = math.min(v129, i + 32768);
            local v181 = i;
            local v182 = {};
            local v183 = 0;
            local i;

            while i < v180 - 3 do
                local v184 = buffer.readu32(p128, i);
                local v185 = bit32.band(v184, 16777215);
                local v186 = u176[v185] or 0;
                u177 = u177 + 1;
                u174[u177] = i;
                u175[u177] = v186;
                local v187 = u177;
                u176[v185] = v187;
                local v188 = u175[v187];
                local v189 = -1;
                local v190 = 0;
                local v191 = 0;
                local v192, v193;

                while true do
                    if not v188 or ((u174[v188] or (-1 / 0)) < i - 32510 or (v190 >= 12 or v191 >= 96)) then
                        v192 = v189;
                        v193 = v191;
                        break;
                    end;

                    v193 = 3;
                    v192 = u174[v188];
                    local v194;

                    if math.min(v180, i + 258) > i + v191 and buffer.readu8(p128, v192 + v191) ~= buffer.readu8(p128, i + v191) then
                        v194 = true;
                    else
                        v194 = false;
                    end;

                    while not v194 and (v193 < 258 and (i + v193 < v180 and buffer.readu8(p128, v192 + v193) == buffer.readu8(p128, i + v193))) do
                        v193 = v193 + 1;
                    end;

                    if v191 < v193 then
                        if v193 >= 258 then
                            break;
                        end;
                    else
                        v192 = v189;
                        v193 = v191;
                    end;

                    v188 = u175[v188];
                    v190 = v190 + 1;
                    v191 = v193;
                    v189 = v192;
                end;

                if v193 == 0 then
                    local v195 = buffer.readu8(p128, i);
                    v183 = v183 + u22[v195];
                    local v196 = vector.create(0, v195);
                    table.insert(v182, v196);
                    i = i + 1;
                else
                    local v197 = getDistIdx(i - v192);
                    v183 = v183 + (u22[u2[v193]] + u5[v193] + u25[v197 - 1] + (u16[v197 - 1] or 0));
                    local v198 = vector.create(1, i - v192, v193);
                    table.insert(v182, v198);

                    for i2 = i + 1, math.min(i + v193 - 1, v180 - 4) do
                        local v199 = buffer.readu32(p128, i2);
                        local v200 = bit32.band(v199, 16777215);
                        local v201 = u176[v200] or 0;
                        u177 = u177 + 1;
                        u174[u177] = i2;
                        u175[u177] = v201;
                        u176[v200] = u177;
                    end;

                    i = i + v193;
                end;
            end;

            while i < v180 do
                local v202 = buffer.readu8(p128, i);
                v183 = v183 + u22[v202];
                local v203 = vector.create(0, v202);
                table.insert(v182, v203);
                i = i + 1;
            end;

            local v204 = v183 + u22[256];
            table.insert(v182, Vector3.new(0, 256, 0));

            if v180 == v129 then
                buffer.writebits(u130, u131 * 8 + u132, 1, 1);
                u132 = u132 + 1;
                u131 = u131 + bit32.rshift(u132, 3);
                u132 = bit32.band(u132, 7);
            else
                buffer.writebits(u130, u131 * 8 + u132, 1, 0);
                u132 = u132 + 1;
                u131 = u131 + bit32.rshift(u132, 3);
                u132 = bit32.band(u132, 7);
            end;

            local v205 = v180 - v181;

            if math.ceil(v204 / 8) + 1 < math.ceil(v205 / 32768) * 5 + v205 then
                buffer.writebits(u130, u131 * 8 + u132, 2, 1);
                u132 = u132 + 2;
                u131 = u131 + bit32.rshift(u132, 3);
                u132 = bit32.band(u132, 7);

                for _, v in v182 do
                    if v.x == 0 then
                        local y = v.y;
                        writeHuffmanBits(u21[y], u22[y]);
                    else
                        writeBackRef(v.y, v.z);
                    end;
                end;
            else
                buffer.writebits(u130, u131 * 8 + u132, 2, 0);
                u132 = u132 + 2;
                u131 = u131 + bit32.rshift(u132, 3);
                u132 = bit32.band(u132, 7);

                if u132 > 0 then
                    u131 = u131 + 1;
                    u132 = 0;
                end;

                buffer.writeu16(u130, u131, v205);
                local v206 = bit32.bxor(65535, v205);
                buffer.writeu16(u130, u131 + 2, v206);
                buffer.copy(u130, u131 + 4, p128, v181, v205);
                u131 = u131 + (v205 + 4);
            end;

            if u177 > 50000 then
                table.clear(u174);
                table.clear(u175);
                table.clear(u176);
                u177 = 0;
            end;
        end;

        if u132 > 0 then
            u131 = u131 + 1;
        end;

        local v207 = adler32(p128, 0, buffer.len(p128));
        local v208 = bit32.byteswap(v207);
        buffer.writeu32(u130, u131, v208);

        return u130, u131 + 4;
    end
};