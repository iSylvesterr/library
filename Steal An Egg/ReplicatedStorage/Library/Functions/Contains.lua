-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    for _, v in pairs(p1) do
        if p2(v) then
            return true;
        end;
    end;

    return false;
end;