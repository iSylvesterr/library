-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    if math.round(p1) - p1 == 0 then
        return p1;
    end;

    return ("%.2f"):format(p1);
end;