-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 19, Name: isSubset
    for i, v in pairs(p1) do
        if p2[i] ~= v then
            return false;
        end;
    end;

    return true;
end;