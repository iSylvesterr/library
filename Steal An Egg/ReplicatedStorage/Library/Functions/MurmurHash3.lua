-- Decompiled with Potassium's decompiler.

local band = bit32.band;
local lshift = bit32.lshift;
local rshift = bit32.rshift;
local lrotate = bit32.lrotate;
local bxor = bit32.bxor;
local len = buffer.len;
local readu32 = buffer.readu32;
local readu8 = buffer.readu8;
local readu16 = buffer.readu16;
local fromstring = buffer.fromstring;

local function mul(p1, p2) -- Line: 12
    -- upvalues: band (copy), rshift (copy), lshift (copy)
    return band(p1, 65535) * p2 + lshift(band(rshift(p1, 16) * p2, 65535), 16);
end;

local function digestBufferCustom(p3, p4, p5, p6) -- Line: 16
    -- upvalues: readu32 (copy), band (copy), rshift (copy), lshift (copy), lrotate (copy), bxor (copy), readu8 (copy), readu16 (copy)
    local v7 = p6 or 0;

    while p4 < p4 + p5 - 3 do
        local v8 = readu32(p3, p4);
        local v9 = lrotate(band(v8, 65535) * 3432918353 + lshift(band(rshift(v8, 16) * 3432918353, 65535), 16), 15);
        v7 = lshift(lrotate(bxor(v7, band(v9, 65535) * 461845907 + lshift(band(rshift(v9, 16) * 461845907, 65535), 16)), 13) * 5, 0) + 3864292196;
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

        local v12 = lrotate(band(v11, 65535) * 3432918353 + lshift(band(rshift(v11, 16) * 3432918353, 65535), 16), 15);
        v7 = bxor(v7, band(v12, 65535) * 461845907 + lshift(band(rshift(v12, 16) * 461845907, 65535), 16));
    end;

    local v13 = bxor(v7, p5);
    local v14 = bxor(v13, (rshift(v13, 16)));
    local v15 = band(v14, 65535) * 2246822507 + lshift(band(rshift(v14, 16) * 2246822507, 65535), 16);
    local v16 = bxor(v15, (rshift(v15, 13)));
    local v17 = band(v16, 65535) * 3266489909 + lshift(band(rshift(v16, 16) * 3266489909, 65535), 16);

    return bxor(v17, (rshift(v17, 16)));
end;

return {
    DigestBufferCustom = digestBufferCustom,

    DigestBuffer = function(p18, p19) -- Line: 46, Name: digestBuffer
        -- upvalues: digestBufferCustom (copy), len (copy)
        return digestBufferCustom(p18, 0, len(p18), p19);
    end,

    Digest = function(p20, p21) -- Line: 50, Name: digest
        -- upvalues: fromstring (copy), digestBufferCustom (copy), len (copy)
        local v22 = fromstring(p20);

        return digestBufferCustom(v22, 0, len(v22), p21);
    end
};