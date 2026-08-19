-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 6
    local v3 = {};

    for i = 1, #p1 do
        if p2(i, p1[i]) then
            table.insert(v3, i);
        end;
    end;

    table.sort(v3, function(p4, p5) -- Line: 15
        return p5 < p4;
    end);

    for _, v in v3 do
        table.remove(p1, v);
    end;

    return p1;
end;