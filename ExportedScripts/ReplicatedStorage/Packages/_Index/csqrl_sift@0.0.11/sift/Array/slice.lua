-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 21, Name: slice
    local v4 = #p1;
    local v5 = {};
    local v6 = type(p2) ~= "number" and 1 or p2;

    if type(p3) ~= "number" then
        p3 = v4;
    end;

    if v6 < 1 then
        v6 = v6 + v4;
    end;

    if p3 < 1 then
        p3 = p3 + v4;
    end;

    for i = v6, p3 do
        table.insert(v5, p1[i]);
    end;

    return v5;
end;