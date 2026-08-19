-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = tostring(p1);

    if typeof(p1) == "string" then
        return "\"" .. v2 .. "\"";
    end;

    return v2;
end;