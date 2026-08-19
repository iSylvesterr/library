-- Decompiled with Potassium's decompiler.

return function(p1, p2, ...) -- Line: 21, Name: insert
    local v3 = #p1;

    if p2 < 1 then
        p2 = p2 + (v3 + 1);
    end;

    if v3 < p2 then
        if v3 + 1 < p2 then
            return p1;
        end;

        p2 = v3 + 1;
        v3 = v3 + 1;
    end;

    local v4 = {};

    for i = 1, v3 do
        if i == p2 then
            for _, v in ipairs({ ... }) do
                table.insert(v4, v);
            end;
        end;

        table.insert(v4, p1[i]);
    end;

    return v4;
end;