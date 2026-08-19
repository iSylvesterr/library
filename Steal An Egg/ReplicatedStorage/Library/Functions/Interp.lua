-- Decompiled with Potassium's decompiler.

local u1 = {};

function NumberSearch(p2, p3)
    local v4 = #p2;
    local v5 = 1;

    while v5 <= v4 do
        local v6 = v5 + (v4 - v5) // 2;
        local v7 = p2[v6] - p3;

        if v7 > 0 then
            v4 = v6 - 1;
        else
            if v7 >= 0 then
                return v6;
            end;

            v5 = v6 + 1;
        end;
    end;

    return v5 - 1;
end;

function Map(p8, p9, p10, p11, p12)
    return p11 + (p12 - p11) * (p8 - p9) / (p10 - p9);
end;

u1.NumberSearch = NumberSearch;
u1.Map = Map;

function u1.Interp(p13, p14, u15) -- Line: 28
    local v16 = type(p13) == "table";
    assert(v16, "X must be a table");
    local v17 = type(p14) == "table";
    assert(v17, "Y must be a table");
    assert(#p13 >= 2, "Must have atleast 2 samples");
    assert(#p13 == #p14, "X and Y must have the same length");
    local v18 = u15 == nil and true or type(u15) == "function";
    assert(v18, "xEasing must be a function or nil");
    local u19 = table.clone(p13);
    local u20 = table.clone(p14);
    local v21 = 0;
    local v22 = 0;
    local v23 = 0;

    for i = 1, #u19 do
        local v24 = u19[i];

        if u15 then
            v24 = u15(v24);
            u19[i] = v24;
        end;

        if i > 1 then
            if v21 < v24 then
                v22 = v22 + 1;
            elseif v24 < v21 then
                v23 = v23 + 1;
            end;
        end;

        v21 = v24;
    end;

    if v22 > 0 then
        assert(v23 == 0, "Y contains both increasing and decreasing elements");
    elseif v23 > 0 then
        local v25 = #u19;

        for i = 1, v25 // 2 do
            local v26 = u19[i];
            u19[i] = u19[v25 - i + 1];
            u19[v25 - i + 1] = v26;
            local v27 = u20[i];
            u20[i] = u20[v25 - i + 1];
            u20[v25 - i + 1] = v27;
        end;
    end;

    return function(p28) -- Line: 75
        -- upvalues: u15 (copy), u19 (ref), u20 (ref)
        if u15 then
            p28 = u15(p28);
        end;

        local v29 = NumberSearch(u19, p28);
        local v30 = math.clamp(v29, 1, #u19 - 1);

        return Map(p28, u19[v30], u19[v30 + 1], u20[v30], u20[v30 + 1]);
    end;
end;

function u1.InterpFunction(p31, p32, p33, p34, p35) -- Line: 83
    -- upvalues: u1 (copy)
    local v36 = type(p31) == "function";
    assert(v36, "f must be a function");
    local v37 = type(p32) == "number";
    assert(v37, "xMin must be a number");
    local v38 = type(p33) == "number";
    assert(v38, "xMax must be a number");
    assert(p32 ~= p33, "xMin cannot equal xMax");
    local v39 = type(p34) == "number";
    assert(v39, "step must be a number");
    assert(p34 > 0, "xStep must positive");
    local v40 = p35 == nil and true or type(p35) == "function";
    assert(v40, "xEasing must be a function or nil");
    local v41 = math.abs(p33 - p32) / p34;
    local v42 = math.ceil(v41) + 1;
    local v43 = math.max(v42, 3);
    warn("This function is sub-optimal and needs to not do a binary search on x");
    local v44 = table.create(0, v43);
    local v45 = table.create(0, v43);

    for i = 1, v43 do
        local v46 = p32 + (i - 1) * (p33 - p32) / (v43 - 1);
        local v47 = p31(v46);
        v44[i] = v46;
        v45[i] = v47;
    end;

    return u1.Interp(v44, v45, p35);
end;

function u1.InverseInterp(p48, p49, p50) -- Line: 107
    -- upvalues: u1 (copy)
    return u1.Interp(p49, p48, p50);
end;

function u1.InverseInterpFunction(p51, p52, p53, p54, p55) -- Line: 110
    -- upvalues: u1 (copy)
    local v56 = type(p51) == "function";
    assert(v56, "f must be a function");
    local v57 = type(p52) == "number";
    assert(v57, "xMin must be a number");
    local v58 = type(p53) == "number";
    assert(v58, "xMax must be a number");
    assert(p52 ~= p53, "xMin cannot equal xMax");
    local v59 = type(p54) == "number";
    assert(v59, "step must be a number");
    assert(p54 > 0, "xStep must positive");
    local v60 = p55 == nil and true or type(p55) == "function";
    assert(v60, "yEasing must be a function or nil");
    local v61 = math.abs(p53 - p52) / p54;
    local v62 = math.ceil(v61) + 1;
    local v63 = math.max(v62, 3);
    local v64 = table.create(0, v63);
    local v65 = table.create(0, v63);

    for i = 1, v63 do
        local v66 = p52 + (i - 1) * (p53 - p52) / (v63 - 1);
        local v67 = p51(v66);
        v64[i] = v66;
        v65[i] = v67;
    end;

    return u1.InverseInterp(v64, v65, p55);
end;

return u1;