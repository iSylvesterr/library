-- Decompiled with Potassium's decompiler.

local u23 = {
    Compare = function(p1, p2) -- Line: 3, Name: Compare
        return p1 < p2 and -1 or (p2 < p1 and 1 or 0);
    end,

    Any = function(p3, p4, ...) -- Line: 7, Name: Any
        local v5 = #p3;
        local v6 = 1;

        while v6 <= v5 do
            local v7 = v6 + (v5 - v6) // 2;
            local v8 = p4(p3[v7], ...);

            if v8 > 0 then
                v5 = v7 - 1;
            else
                if v8 == 0 then
                    return v7;
                end;

                v6 = v7 + 1;
            end;
        end;

        return -v6;
    end,

    Left = function(p9, p10, ...) -- Line: 24, Name: Left
        local v11 = #p9;
        local v12 = 1;
        local v13 = false;

        while v12 <= v11 do
            local v14 = v12 + (v11 - v12) // 2;
            local v15 = p10(p9[v14], ...);

            if v15 > 0 then
                v11 = v14 - 1;
            elseif v15 < 0 then
                v12 = v14 + 1;
            else
                v11 = v14 - 1;
                v13 = true;
            end;
        end;

        return v13 and v12 and v12 or -v12;
    end,

    Right = function(p16, p17, ...) -- Line: 43, Name: Right
        local v18 = #p16;
        local v19 = 1;
        local v20 = false;

        while v19 <= v18 do
            local v21 = v19 + (v18 - v19) // 2;
            local v22 = p17(p16[v21], ...);

            if v22 > 0 then
                v18 = v21 - 1;
            elseif v22 < 0 then
                v19 = v21 + 1;
            else
                v19 = v21 + 1;
                v20 = true;
            end;
        end;

        return v20 and v19 and v19 or -v19;
    end
};

function u23.InsertAny(p24, p25, p26) -- Line: 62
    -- upvalues: u23 (copy)
    local v27 = u23.Any(p24, p25, p26);
    local v28 = math.abs(v27);
    table.insert(p24, v28, p26);

    return v28;
end;

function u23.InsertLeft(p29, p30, p31) -- Line: 69
    -- upvalues: u23 (copy)
    local v32 = u23.Left(p29, p30, p31);
    local v33 = math.abs(v32);
    table.insert(p29, v33, p31);

    return v33;
end;

function u23.InsertRight(p34, p35, p36) -- Line: 76
    -- upvalues: u23 (copy)
    local v37 = u23.Right(p34, p35, p36);
    local v38 = math.abs(v37);
    table.insert(p34, v38, p36);

    return v38;
end;

function u23.Remove(p39, p40, p41) -- Line: 83
    -- upvalues: u23 (copy)
    local v42 = u23.Left(p39, p40, p41);

    if v42 > 0 then
        for i = v42, #p39 do
            if p39[i] == p41 then
                table.remove(p39, i);

                return true;
            end;
        end;
    end;

    return false;
end;

function u23.NumberSearch(p43, p44) -- Line: 96
    local v45 = #p43;
    local v46 = 1;

    while v46 <= v45 do
        local v47 = v46 + (v45 - v46) // 2;
        local v48 = p43[v47];

        if p44 < v48 then
            v45 = v47 - 1;
        else
            if v48 == p44 then
                return v47;
            end;

            v46 = v47 + 1;
        end;
    end;

    return v46 - 1;
end;

function u23.NumberAny(p49, p50) -- Line: 113
    local v51 = #p49;
    local v52 = 1;

    while v52 <= v51 do
        local v53 = v52 + (v51 - v52) // 2;
        local v54 = p49[v53];

        if p50 < v54 then
            v51 = v53 - 1;
        else
            if v54 == p50 then
                return v53;
            end;

            v52 = v53 + 1;
        end;
    end;

    return -v52;
end;

return u23;