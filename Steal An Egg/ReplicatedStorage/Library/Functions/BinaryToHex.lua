-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = #p1;
    local v3 = table.create(math.ceil(v2), "");

    for i = 1, v2 do
        v3[i] = string.format("%02x", string.byte(p1, i));
    end;

    return table.concat(v3);
end;