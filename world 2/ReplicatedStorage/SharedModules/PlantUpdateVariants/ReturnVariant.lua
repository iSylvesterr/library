-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 26
    local v4 = p1[p2];

    if not v4 then
        return 0;
    end;

    local v5 = p3 or os.time();
    local v6 = 0;

    for _, v in v4.Variants do
        if v.UnixTimestamp <= v5 and v6 < v.Variant then
            v6 = v.Variant;
        end;
    end;

    return v6;
end;