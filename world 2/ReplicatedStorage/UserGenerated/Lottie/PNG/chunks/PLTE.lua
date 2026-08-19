-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(p1, p2, p3) -- Line: 3, Name: read
    assert(p2.length % 3 == 0, "malformed PLTE chunk");
    local v4 = p2.length / 3;
    assert(v4 > 0, "no entries in PLTE");
    assert(v4 <= 256, "too many entries in PLTE");
    assert(v4 <= 2 ^ p3.bitDepth, "too many entries in PLTE for bit depth");
    local v5 = table.create(v4);
    local offset = p2.offset;

    for i = 1, v4 do
        v5[i] = {
            a = 255,
            r = buffer.readu8(p1, offset),
            g = buffer.readu8(p1, offset + 1),
            b = buffer.readu8(p1, offset + 2)
        };
        offset = offset + 3;
    end;

    return {
        colors = v5
    };
end;