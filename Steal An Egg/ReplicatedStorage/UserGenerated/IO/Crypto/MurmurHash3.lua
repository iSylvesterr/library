-- Decompiled with Potassium's decompiler.

local band = bit32.band;
local lshift = bit32.lshift;
local rshift = bit32.rshift;
local lrotate = bit32.lrotate;
local bxor = bit32.bxor;
local bor = bit32.bor;
local len = buffer.len;
local readu32 = buffer.readu32;
local readu8 = buffer.readu8;
local readu16 = buffer.readu16;
local fromstring = buffer.fromstring;

function mul32(p1, p2)
    -- upvalues: band (copy), rshift (copy), lshift (copy)
    return band(p1, 65535) * p2 + lshift(band(rshift(p1, 16) * p2, 65535), 16);
end;

function DigestBufferUnsafe(p3, p4, p5, p6)
    -- upvalues: bor (copy), readu32 (copy), lrotate (copy), bxor (copy), lshift (copy), band (copy), readu8 (copy), readu16 (copy), rshift (copy)
    if p6 == nil then
        p6 = 0;
    else
        local v7 = bor(p6, 0) == p6;
        assert(v7);
    end;

    while p4 < p4 + p5 - 3 do
        local v8 = readu32(p3, p4);
        local v9 = lrotate(mul32(v8, 3432918353), 15);
        p6 = lshift(lrotate(bxor(p6, (mul32(v9, 461845907))), 13) * 5, 0) + 3864292196;
        p4 = p4 + 4;
    end;

    local v10 = band(p5, 3);

    if v10 > 0 then
        local v11;

        if v10 == 3 then
            v11 = readu8(p3, p4) + lshift(readu16(p3, p4 + 1), 8);
        elseif v10 == 2 then
            v11 = readu16(p3, p4);
        else
            v11 = readu8(p3, p4);
        end;

        local v12 = lrotate(mul32(v11, 3432918353), 15);
        p6 = bxor(p6, (mul32(v12, 461845907)));
    end;

    local v13 = bxor(p6, p5);
    local v14 = bxor(v13, (rshift(v13, 16)));
    local v15 = mul32(v14, 2246822507);
    local v16 = bxor(v15, (rshift(v15, 13)));
    local v17 = mul32(v16, 3266489909);

    return bxor(v17, (rshift(v17, 16)));
end;

function DigestBufferCustom(p18, p19, p20, p21)
    -- upvalues: len (copy)
    local v22 = type(p18) == "buffer";
    assert(v22);
    local v23;

    if type(p19) == "number" and p19 >= 0 then
        v23 = p19 <= len(p18);
    else
        v23 = false;
    end;

    assert(v23);
    local v24;

    if type(p20) == "number" and p20 >= 0 then
        v24 = p20 <= len(p18) - p19;
    else
        v24 = false;
    end;

    assert(v24);

    return DigestBufferUnsafe(p18, p19, p20, p21);
end;

function DigestBuffer(p25, p26)
    -- upvalues: len (copy)
    return DigestBufferUnsafe(p25, 0, len(p25), p26);
end;

function Digest(p27, p28)
    -- upvalues: fromstring (copy), len (copy)
    local v29 = fromstring(p27);

    return DigestBufferUnsafe(v29, 0, len(v29), p28);
end;

local v30 = {
    DigestBufferCustom = DigestBufferCustom,
    DigestBuffer = DigestBuffer,
    Digest = Digest
};
table.freeze(v30);

return v30;