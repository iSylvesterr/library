-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 1
    local v4 = os.date("!%X", p1);

    if p1 <= 3600 then
        v4 = v4:sub(4);
    end;

    if p1 > 86400 then
        local v5 = math.floor(p1 / 86400);
        v4 = tostring(v5) .. ":" .. v4;
    end;

    if p2 then
        v4 = v4 .. "." .. string.format("%.2f", p1):match("%d+$");
    end;

    if p3 then
        v4 = v4:gsub("00:", "");
    end;

    return v4;
end;