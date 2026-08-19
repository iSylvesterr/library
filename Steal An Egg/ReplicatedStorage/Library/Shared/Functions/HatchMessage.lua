-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 1
    local v4 = p1:Directory();
    local v5 = p1:GetName();
    local DisplayName = p2.DisplayName;
    local v6 = p1:GetRarity();

    return v6.Message(DisplayName, v5, v4, p3), v6.Color, v6.Announce;
end;