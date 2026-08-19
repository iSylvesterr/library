-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 19, Name: includes
    for _, v in pairs(p1) do
        if v == p2 then
            return true;
        end;
    end;

    return false;
end;