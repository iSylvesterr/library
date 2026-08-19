-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

local function readU16(p1, p2, p3) -- Line: 3
    local v4 = buffer.readu8(p1, p2);
    local v5 = bit32.lshift(v4, 8);
    local v6 = buffer.readu8(p1, p2 + 1);
    local v7 = bit32.bor(v5, v6);

    return bit32.extract(v7, 0, p3);
end;

return function(p8, p9, p10, p11) -- Line: 11, Name: read
    local v12 = -1;
    local v13 = -1;
    local v14 = -1;
    local v15 = -1;

    if p10.colorType == 0 then
        assert(p9.length == 2, "invalid tRNS length for color type");
        local offset = p9.offset;
        local bitDepth = p10.bitDepth;
        local v16 = buffer.readu8(p8, offset);
        local v17 = bit32.lshift(v16, 8);
        local v18 = buffer.readu8(p8, offset + 1);
        local v19 = bit32.bor(v17, v18);
        v12 = bit32.extract(v19, 0, bitDepth);
    elseif p10.colorType == 2 then
        assert(p9.length == 6, "invalid tRNS length for color type");
        local offset = p9.offset;
        local bitDepth = p10.bitDepth;
        local v20 = buffer.readu8(p8, offset);
        local v21 = bit32.lshift(v20, 8);
        local v22 = buffer.readu8(p8, offset + 1);
        local v23 = bit32.bor(v21, v22);
        v13 = bit32.extract(v23, 0, bitDepth);
        local v24 = p9.offset + 2;
        local bitDepth2 = p10.bitDepth;
        local v25 = buffer.readu8(p8, v24);
        local v26 = bit32.lshift(v25, 8);
        local v27 = buffer.readu8(p8, v24 + 1);
        local v28 = bit32.bor(v26, v27);
        v14 = bit32.extract(v28, 0, bitDepth2);
        local v29 = p9.offset + 4;
        local bitDepth3 = p10.bitDepth;
        local v30 = buffer.readu8(p8, v29);
        local v31 = bit32.lshift(v30, 8);
        local v32 = buffer.readu8(p8, v29 + 1);
        local v33 = bit32.bor(v31, v32);
        v15 = bit32.extract(v33, 0, bitDepth3);
    else
        local length = p9.length;
        assert(p11, "tRNS requires PLTE for color type");
        assert(length <= #p11.colors, "tRNS specified too many PLTE alphas");

        for i = 1, length do
            p11.colors[i].a = buffer.readu8(p8, p9.offset + i - 1);
        end;
    end;

    return {
        gray = v12,
        red = v13,
        green = v14,
        blue = v15
    };
end;