-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 20, Name: CompareBuffer
    local v3 = buffer.len(p1);
    local v4 = buffer.len(p2);

    for i = 0, math.min(v3, v4) - 1 do
        local v5 = buffer.readu8(p1, i);
        local v6 = buffer.readu8(p2, i);

        if v5 ~= v6 then
            return v5 - v6;
        end;
    end;

    return v3 - v4;
end;