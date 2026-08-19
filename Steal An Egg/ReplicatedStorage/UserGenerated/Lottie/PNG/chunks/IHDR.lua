-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local u1 = {
    [0] = { 1, 2, 4, 8, 16 },
    [2] = { 8, 16 },
    [3] = { 1, 2, 4, 8 },
    [4] = { 8, 16 },
    [6] = { 8, 16 }
};

return function(p2, p3) -- Line: 11, Name: read
    -- upvalues: u1 (copy)
    assert(p3.length == 13, "IHDR data must be 13 bytes");
    local offset = p3.offset;
    local v4 = buffer.readu32(p2, offset);
    local v5 = bit32.byteswap(v4);
    local v6 = buffer.readu32(p2, offset + 4);
    local v7 = bit32.byteswap(v6);
    local v8 = buffer.readu8(p2, offset + 8);
    local v9 = buffer.readu8(p2, offset + 9);
    local v10 = buffer.readu8(p2, offset + 10);
    local v11 = buffer.readu8(p2, offset + 11);
    local v12 = buffer.readu8(p2, offset + 12);
    local v13;

    if v5 > 0 and (v5 <= 2147483648 and v7 > 0) then
        v13 = v7 <= 2147483648;
    else
        v13 = false;
    end;

    assert(v13, "invalid dimensions");
    assert(v10 == 0, "invalid compression method");
    assert(v11 == 0, "invalid filter method");
    assert(v12 == 0 and true or v12 == 1, "invalid interlace method");
    local v14 = u1[v9];
    assert(v14 ~= nil, "invalid color type");
    local v15 = table.find(v14, v8) ~= nil;
    assert(v15, "invalid bit depth");

    return {
        width = v5,
        height = v7,
        bitDepth = v8,
        colorType = v9,
        interlaced = v12 == 1
    };
end;