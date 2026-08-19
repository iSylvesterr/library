-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 1
    if #p1 < p3 then
        table.insert(p1, p2);

        return;
    end;

    p1[p3] = p2;
end;