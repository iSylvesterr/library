-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 20, Name: UTF8Sub
    local v4 = p3 or -1;
    local v5 = utf8.offset(p1, p2);

    if not v5 then
        if p2 > 0 then
            return "";
        end;

        v5 = 1;
    end;

    local v6;

    if v4 == -1 then
        v6 = #p1;
    else
        local v7 = utf8.offset(p1, v4 + 1);

        if v7 then
            v6 = v7 - 1;
        else
            v6 = v4 < 0 and 0 or #p1;
        end;
    end;

    return string.sub(p1, v5, v6);
end;