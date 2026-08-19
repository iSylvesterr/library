-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3;

    if typeof(p1) == "Instance" and typeof(p2) == "string" then
        v3 = p1:IsA(p2);
    else
        v3 = false;
    end;

    return v3;
end;