-- Decompiled with Potassium's decompiler.

local u1 = Random.new();

return function(p2, ...) -- Line: 16
    -- upvalues: u1 (copy)
    local v3 = { ... };
    local v4;

    if #v3 == 1 then
        v4 = v3[1];

        if type(v4) == "table" then
            if type(v4[2]) == "number" then
                v4 = v3;
            end;
        else
            v4 = v3;
        end;
    else
        v4 = v3;
    end;

    local v5 = 0;
    local v6 = 0;
    local v7 = 0;

    for i, v in ipairs(v4) do
        local v8 = v[2];
        local v9 = type(v8) == "number";
        assert(v9, "Weight must be a number");

        if v8 > 0 and (v8 == v8 and v8 ~= (1 / 0)) then
            v5 = v5 + 1;
            v6 = v6 + v8;
            v7 = i;
        end;
    end;

    if v5 == 0 then
        return nil, 0, 0, 0, 0;
    end;

    local v10 = (p2 or u1):NextNumber(0, v6);
    local v11 = v10;

    for i, v in ipairs(v4) do
        local v12 = v[2];

        if v12 > 0 and (v12 == v12 and v12 ~= (1 / 0)) then
            v10 = v10 - v12;

            if v10 <= 0 or i == v7 then
                return v[1], v11 / v6, v12 / v6, i, v12;
            end;
        end;
    end;

    error("Lottery selection failed - impossible state reached");
end;