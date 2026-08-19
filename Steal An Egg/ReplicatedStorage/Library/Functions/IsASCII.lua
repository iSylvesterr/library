-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = type(p1) == "string";
    assert(v2);

    for i = 1, #p1 do
        local v3 = p1:byte(i);

        if v3 < 32 or v3 > 126 then
            return false;
        end;
    end;

    return true;
end;