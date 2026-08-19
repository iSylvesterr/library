-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 28, Name: reduceRight
    local v4 = #p1;

    if p3 == nil then
        p3 = p1[v4];
        v4 = v4 - 1;
    end;

    for i = v4, 1, -1 do
        p3 = p2(p3, p1[i], i, p1);
    end;

    return p3;
end;