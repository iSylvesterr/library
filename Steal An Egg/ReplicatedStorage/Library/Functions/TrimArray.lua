-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    for i = #p1, p2 + 1, -1 do
        table.remove(p1, i);
    end;
end;