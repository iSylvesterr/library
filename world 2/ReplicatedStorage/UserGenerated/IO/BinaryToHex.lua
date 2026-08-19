-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 20, Name: BinaryToHex
    local v2 = string.len(p1);
    local v3 = buffer.create(v2 * 2);

    for i = 0, v2 - 1 do
        local v4 = string.byte(p1, i + 1);
        local v5 = bit32.rshift(v4, 4);
        local v6 = bit32.band(v4, 15);
        local v7;

        if v5 < 10 then
            v7 = v5 + 48;
        else
            v7 = v5 + 87;
        end;

        buffer.writeu8(v3, i * 2 + 0, v7);
        local v8;

        if v6 < 10 then
            v8 = v6 + 48;
        else
            v8 = v6 + 87;
        end;

        buffer.writeu8(v3, i * 2 + 1, v8);
    end;

    return buffer.tostring(v3);
end;