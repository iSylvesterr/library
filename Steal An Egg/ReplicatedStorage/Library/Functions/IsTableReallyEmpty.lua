-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    if typeof(p1) == "table" then
        return not next(p1);
    end;

    return nil;
end;