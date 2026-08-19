-- Decompiled with Potassium's decompiler.

function BufferToHex(p1)
    local v2 = buffer.len(p1);
    local v3 = buffer.create(v2 * 2);

    for i = 0, v2 - 1 do
        local v4 = buffer.readu8(p1, i);
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

return BufferToHex;