-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local v2 = nil;

    if type(p1) == "number" then
        v2 = p1;
    else
        local v3 = string.match(p1, "^rbxassetid://(%d+)$") or string.match(p1, "^http://www%.roblox%.com/asset/%?id=(%d+)$");

        if v3 then
            v2 = tonumber(v3);
        end;
    end;

    if v2 and (math.floor(v2) ~= v2 or (v2 == (1 / 0) or v2 == (-1 / 0))) then
        v2 = nil;
    end;

    return v2;
end;