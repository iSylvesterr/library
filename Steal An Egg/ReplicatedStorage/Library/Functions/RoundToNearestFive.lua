-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 3, Name: roundToNearestFive
    if p1 == 0 then
        return 0;
    end;

    local v2 = math.round(p1 / 5) * 5;

    if v2 == 0 then
        if p1 > 0 then
            return 5;
        end;

        if p1 < 0 then
            return -5;
        end;
    end;

    return v2;
end;