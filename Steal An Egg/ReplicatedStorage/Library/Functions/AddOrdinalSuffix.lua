-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = tostring(p1);
    local v3 = v2:sub(-1);
    local v4 = v2:sub(-2, -2);

    if v3 == "1" and v4 ~= "1" then
        return v2 .. "st";
    end;

    if v3 == "2" and v4 ~= "1" then
        return v2 .. "nd";
    end;

    if v3 == "3" and v4 ~= "1" then
        return v2 .. "rd";
    end;

    return v2 .. "th";
end;