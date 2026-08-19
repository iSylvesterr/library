-- Decompiled with Potassium's decompiler.

local function hash(p1, p2, p3) -- Line: 48
    return (bit32.band(p1, 262143) * 262144 + bit32.band(p3, 262143)) * 131072 + bit32.band(p2, 131071);
end;

local function quantize(p4, p5) -- Line: 54
    return p4.X // p5, p4.Y // p5, p4.Z // p5;
end;

local function key(p6, p7) -- Line: 58
    local v8 = p6.Y // p7;
    local v9 = p6.Z // p7;

    return (bit32.band(p6.X // p7, 262143) * 262144 + bit32.band(v9, 262143)) * 131072 + bit32.band(v8, 131071);
end;

local v10 = {};
local u11 = table.freeze({
    __index = v10
});

function v10.Insert(p12, p13, p14) -- Line: 68
    local v15 = typeof(p13) == "Vector3";
    assert(v15);
    local Epsilon = p12.Epsilon;
    local v16 = p13.Y // Epsilon;
    local v17 = p13.Z // Epsilon;
    local v18 = (bit32.band(p13.X // Epsilon, 262143) * 262144 + bit32.band(v17, 262143)) * 131072 + bit32.band(v16, 131071);
    local v19 = {
        Pos = p13,
        Value = p14
    };
    local Table = p12.Table;

    if not Table[v18] then
        Table[v18] = {};
    end;

    table.insert(Table[v18], v19);
end;

function v10.Remove(p20, p21, p22) -- Line: 80
    local v23 = typeof(p21) == "Vector3";
    assert(v23);
    local Epsilon = p20.Epsilon;
    local v24 = p21.Y // Epsilon;
    local v25 = p21.Z // Epsilon;
    local v26 = (bit32.band(p21.X // Epsilon, 262143) * 262144 + bit32.band(v25, 262143)) * 131072 + bit32.band(v24, 131071);
    local v27 = p20.Table[v26];

    if not v27 then
        return;
    end;

    for i = #v27, 1, -1 do
        if v27[i].Value == p22 then
            table.remove(v27, i);
        end;
    end;

    if #v27 == 0 then
        p20.Table[v26] = nil;
    end;
end;

function v10.Collect(p28, p29, p30) -- Line: 99
    local v31 = typeof(p29) == "Vector3";
    assert(v31);
    local v32;

    if p30 == nil then
        v32 = true;
    elseif type(p30) == "number" and p30 > 0 then
        v32 = math.floor(p30) == p30;
    else
        v32 = false;
    end;

    assert(v32);
    local Epsilon = p28.Epsilon;
    local v33 = p29.X // Epsilon;
    local v34 = p29.Y // Epsilon;
    local v35 = p29.Z // Epsilon;
    local Table = p28.Table;
    local v36 = p30 or 1;
    local v37 = 0;
    local v38 = {};

    for i = -v36, v36 do
        for i2 = -v36, v36 do
            for i3 = -v36, v36 do
                local v39 = Table[(bit32.band(v33 + i, 262143) * 262144 + bit32.band(v35 + i3, 262143)) * 131072 + bit32.band(v34 + i2, 131071)];

                if v39 then
                    for _, v in ipairs(v39) do
                        v37 = v37 + 1;
                        v38[v37] = v.Value;
                    end;
                end;
            end;
        end;
    end;

    v38.n = v37;

    return v38;
end;

function v10.Query(p40, p41, p42) -- Line: 128
    local v43 = typeof(p41) == "Vector3";
    assert(v43);
    local v44;

    if p42 == nil then
        v44 = true;
    elseif type(p42) == "number" and p42 > 0 then
        v44 = math.floor(p42) == p42;
    else
        v44 = false;
    end;

    assert(v44);
    local Epsilon = p40.Epsilon;
    local v45 = p41.X // Epsilon;
    local v46 = p41.Y // Epsilon;
    local v47 = p41.Z // Epsilon;
    local Table = p40.Table;
    local v48 = p42 or 1;
    local v49 = nil;
    local v50 = nil;

    for i = -v48, v48 do
        for i2 = -v48, v48 do
            for i3 = -v48, v48 do
                local v51 = Table[(bit32.band(v45 + i, 262143) * 262144 + bit32.band(v47 + i3, 262143)) * 131072 + bit32.band(v46 + i2, 131071)];

                if v51 then
                    for _, v in ipairs(v51) do
                        local Magnitude = (v.Pos - p41).Magnitude;

                        if not v49 or Magnitude < v49 then
                            v50 = v.Value;
                            v49 = Magnitude;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v50;
end;

table.freeze(v10);

return table.freeze({
    new = function(p52, p53) -- Line: 163, Name: new
        -- upvalues: u11 (copy)
        local v54;

        if p52 == nil then
            v54 = true;
        elseif type(p52) == "number" then
            v54 = p52 > 0;
        else
            v54 = false;
        end;

        assert(v54);

        return setmetatable({
            Table = {},
            Epsilon = p52 or 10
        }, u11);
    end
});