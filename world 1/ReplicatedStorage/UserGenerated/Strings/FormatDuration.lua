-- Decompiled with Potassium's decompiler.

local u1 = { 0, 2, 2, 2 };

return function(p2) -- Line: 22, Name: FormatDuration
    -- upvalues: u1 (copy)
    local v3 = type(p2) == "number";
    assert(v3);

    if p2 == (1 / 0) then
        return "Infinity";
    end;

    if p2 ~= p2 then
        return "NaN";
    end;

    local v4 = math.max(0, p2);
    local v5 = math.ceil(v4);
    local v6 = v5 % 60;
    local v7 = v5 // 60;
    local v8 = v7 // 60;
    local v9 = {
        v8 // 24,
        v8 % 24,
        v7 % 60,
        v6
    };
    local v10 = #v9;

    for i, v in ipairs(v9) do
        if v > 0 then
            v10 = i;
            break;
        end;
    end;

    if v10 == #v9 then
        return tostring(v6) .. "s";
    end;

    local v11 = { (tostring(v9[v10])) };

    for i = v10 + 1, #v9 do
        local v12 = tostring(v9[i]);

        while #v12 < u1[i] do
            v12 = "0" .. v12;
        end;

        table.insert(v11, ":" .. v12);
    end;

    return table.concat(v11);
end;