-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    for _, v in pairs(p1) do
        if v == nil then
            return true;
        end;
    end;

    return false;
end;