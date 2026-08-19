-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 7, Name: isSimilar
    if typeof(p1) == "table" then
        return false;
    end;

    return p1 == p2;
end;