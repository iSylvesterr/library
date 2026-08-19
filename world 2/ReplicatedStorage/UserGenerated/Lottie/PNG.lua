-- Decompiled with Potassium's decompiler.

require(script.Types);
local chunks = require(script.chunks);
local crc32 = require(script.crc32);
local zlib = require(script.zlib);
local u1 = {
    [0] = 1,
    [2] = 3,
    [3] = 1,
    [4] = 2,
    [6] = 4
};
local u2 = { 0, 0, 4, 0, 2, 0, 1 };
local u3 = { 0, 4, 0, 2, 0, 1, 0 };
local u4 = { 8, 8, 8, 4, 4, 2, 2 };
local u5 = { 8, 8, 4, 4, 2, 2, 1 };

return {
    decode = function(p6, p7) -- Line: 38, Name: decode
        -- upvalues: crc32 (copy), chunks (copy), u1 (copy), u3 (copy), u5 (copy), u2 (copy), u4 (copy), zlib (copy)
        local v8 = buffer.len(p6);
        assert(v8 >= 8, "not a PNG");
        local v9 = buffer.readstring(p6, 0, 8) == "\137PNG\r\n\26\n";
        assert(v9, "not a PNG");
        local v10 = table.create(3);
        local v11 = 8;
        local v12;

        if p7 == nil then
            v12 = false;
        elseif p7.allowIncorrectCRC == true then
            v12 = true;
        else
            v12 = false;
        end;

        local v13;

        while true do
            local v14 = buffer.readu32(p6, v11);
            local v15 = bit32.byteswap(v14);
            local v16 = buffer.readstring(p6, v11 + 4, 4);
            local v17 = string.match(v16, "%a%a%a%a");
            local v18 = `invalid chunk type {v16}`;
            assert(v17, v18);
            local v19 = v11 + 8;
            v13 = v19 + v15 + 4;
            local v20 = `EOF while reading {v16} chunk`;
            assert(v13 <= v8, v20);
            local v21 = buffer.readu32(p6, v13 - 4);
            local v22 = v12 or bit32.byteswap(v21) == crc32(p6, v11 + 4, v13 - 5);
            local v23 = `incorrect checksum in {v16}`;
            assert(v22, v23);
            table.insert(v10, {
                type = v16,
                offset = v19,
                length = v15
            });

            if v8 <= v13 then
                break;
            end;

            v11 = v13;
        end;

        assert(v13 == v8, "trailing data in file");

        for _, v in v10 do
            local type = v.type;
            local v24 = string.byte(type, 1, 1);

            if bit32.extract(v24, 5) == 0 and (type ~= "IHDR" and (type ~= "IDAT" and (type ~= "PLTE" and type ~= "IEND"))) then
                error((`unhandled critical chunk {type}`));
            end;
        end;

        local v25 = v10[1];
        assert(v25.type == "IHDR", "first chunk must be IHDR");

        for i = 2, #v10 do
            assert(v10[i].type ~= "IHDR", "multiple IHDR chunks are not allowed");
        end;

        local v26 = chunks.IHDR(p6, v25);
        local v27 = -1;
        local v28 = -1;
        local v29 = 0;

        for i, v in v10 do
            if v.type == "IDAT" then
                if v27 < 0 then
                    v27 = i;
                else
                    assert(i == v28 + 1, "multiple IDAT chunks must be consecutive");
                end;

                v29 = v29 + v.length;
                v28 = i;
            end;
        end;

        assert(v27 > 0, "no IDAT chunks");
        assert(v29 > 0, "no image data in IDAT chunks");
        local v30 = nil;
        local v31 = -1;

        for i, v in v10 do
            if v.type == "PLTE" then
                assert(not v30, "multiple PLTE chunks are not allowed");
                assert(i < v27, "PLTE not allowed after IDAT chunks");
                local v32;

                if v26.colorType == 0 then
                    v32 = false;
                else
                    v32 = v26.colorType ~= 4;
                end;

                assert(v32, "PLTE not allowed for color type");
                v30 = chunks.PLTE(p6, v, v26);
                v31 = i;
            end;
        end;

        if v26.colorType == 3 then
            assert(v30 ~= nil, "color type requires a PLTE chunk");
        end;

        local v33 = nil;

        for i, v in v10 do
            if v.type == "tRNS" then
                assert(v33 == nil, "multiple tRNS chunks are not allowed");
                assert(i < v27, "tRNS not allowed after IDAT chunks");
                assert(not v30 or v31 < i, "tRNS must be after PLTE");
                local v34;

                if v26.colorType == 4 then
                    v34 = false;
                else
                    v34 = v26.colorType ~= 6;
                end;

                assert(v34, "tRNS not allowed for color type");
                v33 = chunks.tRNS(p6, v, v26, v30);
            end;
        end;

        local v35 = v10[#v10];
        assert(v35.type == "IEND", "final chunk must be IEND");
        assert(v35.length == 0, "IEND chunk must be empty");

        for i = 2, #v10 - 1 do
            assert(v10[i].type ~= "IEND", "multiple IEND chunks are not allowed");
        end;

        local v36 = buffer.create(v29);
        local v37 = 0;

        for _, v in v10 do
            if v.type == "IDAT" then
                buffer.copy(v36, v37, p6, v.offset, v.length);
                v37 = v37 + v.length;
            end;
        end;

        local width = v26.width;
        local height = v26.height;
        local bitDepth = v26.bitDepth;
        local colorType = v26.colorType;
        local u38 = u1[colorType];
        local v39 = 0;

        if v26.interlaced then
            for i = 1, 7 do
                local v40 = math.ceil((width - u3[i]) / u5[i]);
                local v41 = math.ceil((height - u2[i]) / u4[i]);

                if v40 > 0 and v41 > 0 then
                    v39 = v39 + v41 * (math.ceil(v40 * u38 * bitDepth / 8) + 1);
                end;
            end;
        else
            v39 = height * (math.ceil(width * u38 * bitDepth / 8) + 1);
        end;

        local u42;

        if v30 then
            u42 = v30.colors;
        else
            u42 = nil;
        end;

        local u43;

        if colorType == 3 or bitDepth >= 8 then
            u43 = nil;
        else
            u43 = 255 / (2 ^ bitDepth - 1);
        end;

        local u44 = math.ceil(u38 * bitDepth / 8);
        local u45 = 2 ^ bitDepth - 1;
        local u46 = 0;
        local u47 = buffer.create(v39);
        local v48 = zlib.inflate(v36, u47) == v39;
        assert(v48, "decompressed data size mismatch");
        local u49 = buffer.create(width * height * 4);
        local u50 = not v33 and -1 or v33.gray;
        local u51 = not v33 and -1 or v33.red;
        local u52 = not v33 and -1 or v33.green;
        local u53 = not v33 and -1 or v33.blue;

        local function pass(p54, p55, p56, p57) -- Line: 190
            -- upvalues: width (copy), height (copy), u38 (copy), bitDepth (copy), u46 (ref), u47 (copy), u44 (copy), colorType (copy), u50 (copy), u45 (copy), u51 (copy), u52 (copy), u53 (copy), u42 (ref), u43 (ref), u49 (copy)
            local v58 = math.ceil((width - p54) / p56);
            local v59 = math.ceil((height - p55) / p57);

            if v58 < 1 or v59 < 1 then
                return;
            end;

            local v60 = math.ceil(v58 * u38 * bitDepth / 8);
            local u61 = u46;

            for i = 1, v59 do
                local v62 = buffer.readu8(u47, u46);
                u46 = u46 + 1;

                if v62 == 0 or v62 == 2 and i == 1 then
                    u46 = u46 + v60;
                elseif v62 == 1 then
                    for i2 = 1, v60 do
                        local v63 = i2 <= u44 and 0 or buffer.readu8(u47, u46 - u44);
                        local v64 = buffer.readu8(u47, u46) + v63;
                        local v65 = bit32.band(v64, 255);
                        buffer.writeu8(u47, u46, v65);
                        u46 = u46 + 1;
                    end;
                elseif v62 == 2 then
                    for _ = 1, v60 do
                        local v66 = buffer.readu8(u47, u46 - v60 - 1);
                        local v67 = buffer.readu8(u47, u46) + v66;
                        local v68 = bit32.band(v67, 255);
                        buffer.writeu8(u47, u46, v68);
                        u46 = u46 + 1;
                    end;
                elseif v62 == 3 then
                    for i2 = 1, v60 do
                        local v69 = i2 <= u44 and 0 or buffer.readu8(u47, u46 - u44);
                        local v70 = i == 1 and 0 or buffer.readu8(u47, u46 - v60 - 1);
                        local v71 = buffer.readu8(u47, u46) + bit32.rshift(v69 + v70, 1);
                        local v72 = bit32.band(v71, 255);
                        buffer.writeu8(u47, u46, v72);
                        u46 = u46 + 1;
                    end;
                elseif v62 == 4 then
                    for i2 = 1, v60 do
                        local v73 = i2 <= u44 and 0 or buffer.readu8(u47, u46 - u44);
                        local v74 = i == 1 and 0 or buffer.readu8(u47, u46 - v60 - 1);
                        local v75 = (i2 <= u44 or i == 1) and 0 or buffer.readu8(u47, u46 - v60 - u44 - 1);
                        local v76 = math.abs(v74 - v75);
                        local v77 = math.abs(v73 - v75);
                        local v78 = math.abs(v73 + v74 - v75 * 2);

                        if v76 <= v77 and v76 <= v78 then
                            v75 = v73;
                        elseif v77 <= v78 then
                            v75 = v74;
                        end;

                        local v79 = buffer.readu8(u47, u46) + v75;
                        local v80 = bit32.band(v79, 255);
                        buffer.writeu8(u47, u46, v80);
                        u46 = u46 + 1;
                    end;
                else
                    error("invalid row filter");
                end;
            end;

            local u81 = 8;

            local function readValue() -- Line: 249
                -- upvalues: u47 (ref), u61 (ref), bitDepth (ref), u81 (ref)
                local v82 = buffer.readu8(u47, u61);
                local v83;

                if bitDepth < 8 then
                    v83 = bit32.extract(v82, u81 - bitDepth, bitDepth);
                    u81 = u81 - bitDepth;

                    if u81 == 0 then
                        u81 = 8;
                        u61 = u61 + 1;

                        return v83;
                    end;
                else
                    if bitDepth == 8 then
                        u61 = u61 + 1;

                        return v82;
                    end;

                    local v84 = bit32.lshift(v82, 8);
                    local v85 = buffer.readu8(u47, u61 + 1);
                    v83 = bit32.bor(v84, v85);
                    u61 = u61 + 2;
                end;

                return v83;
            end;

            for i = 1, v59 do
                u61 = u61 + 1;

                if u81 < 8 then
                    u81 = 8;
                    u61 = u61 + 1;
                end;

                for i2 = 1, v58 do
                    local v86 = nil;
                    local v87 = nil;
                    local v88 = nil;
                    local v89 = nil;

                    if colorType == 0 then
                        v87 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v87 = bit32.extract(v87, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v90 = bit32.lshift(v87, 8);
                            local v91 = buffer.readu8(u47, u61 + 1);
                            v87 = bit32.bor(v90, v91);
                            u61 = u61 + 2;
                        end;

                        if v87 == u50 then
                            v86 = v87;
                            v88 = v86;
                            local v92 = v86;
                            v86 = v88;
                            v92 = v88;
                            v89 = 0;
                        else
                            v89 = u45;
                            v86 = v87;
                            v88 = v86;
                            local v93 = v86;
                            v86 = v88;
                            v93 = v88;
                        end;
                    elseif colorType == 2 then
                        v86 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v86 = bit32.extract(v86, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v94 = bit32.lshift(v86, 8);
                            local v95 = buffer.readu8(u47, u61 + 1);
                            v86 = bit32.bor(v94, v95);
                            u61 = u61 + 2;
                        end;

                        v87 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v87 = bit32.extract(v87, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v96 = bit32.lshift(v87, 8);
                            local v97 = buffer.readu8(u47, u61 + 1);
                            v87 = bit32.bor(v96, v97);
                            u61 = u61 + 2;
                        end;

                        v88 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v88 = bit32.extract(v88, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v98 = bit32.lshift(v88, 8);
                            local v99 = buffer.readu8(u47, u61 + 1);
                            v88 = bit32.bor(v98, v99);
                            u61 = u61 + 2;
                        end;

                        if v86 == u51 and (v87 == u52 and v88 == u53) then
                            v89 = 0;
                        else
                            v89 = u45;
                        end;
                    elseif colorType == 3 then
                        local v100 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v100 = bit32.extract(v100, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v101 = bit32.lshift(v100, 8);
                            local v102 = buffer.readu8(u47, u61 + 1);
                            v100 = bit32.bor(v101, v102);
                            u61 = u61 + 2;
                        end;

                        local v103 = u42[v100 + 1];
                        v86 = v103.r;
                        v87 = v103.g;
                        v88 = v103.b;
                        v89 = v103.a;
                    elseif colorType == 4 then
                        v87 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v87 = bit32.extract(v87, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v104 = bit32.lshift(v87, 8);
                            local v105 = buffer.readu8(u47, u61 + 1);
                            v87 = bit32.bor(v104, v105);
                            u61 = u61 + 2;
                        end;

                        v89 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v89 = bit32.extract(v89, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v106 = bit32.lshift(v89, 8);
                            local v107 = buffer.readu8(u47, u61 + 1);
                            v89 = bit32.bor(v106, v107);
                            u61 = u61 + 2;
                        end;

                        v86 = v87;
                        v88 = v86;
                        local v108 = v86;
                        v86 = v88;
                        v108 = v88;
                    elseif colorType == 6 then
                        v86 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v86 = bit32.extract(v86, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v109 = bit32.lshift(v86, 8);
                            local v110 = buffer.readu8(u47, u61 + 1);
                            v86 = bit32.bor(v109, v110);
                            u61 = u61 + 2;
                        end;

                        v87 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v87 = bit32.extract(v87, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v111 = bit32.lshift(v87, 8);
                            local v112 = buffer.readu8(u47, u61 + 1);
                            v87 = bit32.bor(v111, v112);
                            u61 = u61 + 2;
                        end;

                        v88 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v88 = bit32.extract(v88, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v113 = bit32.lshift(v88, 8);
                            local v114 = buffer.readu8(u47, u61 + 1);
                            v88 = bit32.bor(v113, v114);
                            u61 = u61 + 2;
                        end;

                        v89 = buffer.readu8(u47, u61);

                        if bitDepth < 8 then
                            v89 = bit32.extract(v89, u81 - bitDepth, bitDepth);
                            u81 = u81 - bitDepth;

                            if u81 == 0 then
                                u81 = 8;
                                u61 = u61 + 1;
                            end;
                        elseif bitDepth == 8 then
                            u61 = u61 + 1;
                        else
                            local v115 = bit32.lshift(v89, 8);
                            local v116 = buffer.readu8(u47, u61 + 1);
                            v89 = bit32.bor(v115, v116);
                            u61 = u61 + 2;
                        end;
                    end;

                    if u43 then
                        v86 = math.round(v86 * u43);
                        v87 = math.round(v87 * u43);
                        v88 = math.round(v88 * u43);
                        v89 = math.round(v89 * u43);
                    elseif bitDepth == 16 then
                        v86 = bit32.rshift(v86, 8);
                        v87 = bit32.rshift(v87, 8);
                        v88 = bit32.rshift(v88, 8);
                        v89 = bit32.rshift(v89, 8);
                    end;

                    local v117 = bit32.lshift(v89, 24);
                    local v118 = bit32.lshift(v88, 16);
                    local v119 = bit32.lshift(v87, 8);
                    local v120 = bit32.bor(v117, v118, v119, v86);
                    buffer.writeu32(u49, ((p55 + (i - 1) * p57) * width + (p54 + (i2 - 1) * p56)) * 4, v120);
                end;
            end;
        end;

        if v26.interlaced then
            for i = 1, 7 do
                pass(u3[i], u2[i], u5[i], u4[i]);
            end;
        else
            pass(0, 0, 1, 1);
        end;

        return {
            width = width,
            height = height,
            pixels = u49,

            readPixel = function(p121, p122) -- Line: 336, Name: readPixel
                -- upvalues: width (copy), height (copy), u49 (copy)
                local v123;

                if p121 >= 1 and (p121 <= width and p122 >= 1) then
                    v123 = p122 <= height;
                else
                    v123 = false;
                end;

                assert(v123, "pixel out of range");
                local v124 = ((p122 - 1) * width + p121 - 1) * 4;

                return buffer.readu8(u49, v124), buffer.readu8(u49, v124 + 1), buffer.readu8(u49, v124 + 2), buffer.readu8(u49, v124 + 3);
            end
        };
    end,

    encode = function(p125, p126) -- Line: 354, Name: encode
        -- upvalues: zlib (copy), crc32 (copy)
        local width = p126.width;
        local height = p126.height;
        local v127 = buffer.len(p125);
        local v128 = width * height * 4;
        local v129 = `expected {v128} bytes, got {v127} bytes`;
        assert(v127 == v128, v129);
        local v130 = width * 4 + 1;
        local v131 = buffer.create(height * v130);

        for i = 0, height - 1 do
            local v132 = i * v130;
            buffer.writeu8(v131, v132, 0);
            buffer.copy(v131, v132 + 1, p125, i * width * 4, width * 4);
        end;

        local v133, v134 = zlib.deflate(v131);
        local v135 = buffer.create(33 + (8 + v134 + 4) + 12);
        buffer.writestring(v135, 0, "\137PNG\r\n\26\n");
        local v136 = bit32.byteswap(13);
        buffer.writeu32(v135, 8, v136);
        buffer.writestring(v135, 12, "IHDR");
        local v137 = bit32.byteswap(width);
        buffer.writeu32(v135, 16, v137);
        local v138 = bit32.byteswap(height);
        buffer.writeu32(v135, 20, v138);
        buffer.writeu8(v135, 24, 8);
        buffer.writeu8(v135, 25, 6);
        buffer.writeu8(v135, 26, 0);
        buffer.writeu8(v135, 27, 0);
        buffer.writeu8(v135, 28, 0);
        local v139 = crc32(v135, 12, 28);
        local v140 = bit32.byteswap(v139);
        buffer.writeu32(v135, 29, v140);
        local v141 = bit32.byteswap(v134);
        buffer.writeu32(v135, 33, v141);
        buffer.writestring(v135, 37, "IDAT");
        buffer.copy(v135, 41, v133, 0, v134);
        local v142 = 41 + v134;
        local v143 = crc32(v135, 37, v142 - 1);
        local v144 = bit32.byteswap(v143);
        buffer.writeu32(v135, v142, v144);
        buffer.writeu32(v135, v142 + 4, 0);
        buffer.writestring(v135, v142 + 8, "IEND");
        buffer.writeu32(v135, v142 + 12, 2187346606);

        return v135;
    end
};