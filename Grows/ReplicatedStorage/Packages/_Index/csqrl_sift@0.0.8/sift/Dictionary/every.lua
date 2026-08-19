-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 24, Name: every
    for i, v in pairs(p1) do
        if not p2(v, i, p1) then
            return false;
        end;
    end;

    return true;
end;