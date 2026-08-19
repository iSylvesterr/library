-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 24, Name: some
    for i, v in pairs(p1) do
        if p2(v, i, p1) then
            return true;
        end;
    end;

    return false;
end;