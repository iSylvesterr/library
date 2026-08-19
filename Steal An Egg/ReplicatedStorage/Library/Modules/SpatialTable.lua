-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};

local function hashPosition(p3) -- Line: 4
    return (p3.X * 262144 + p3.Z) * 131072 + p3.Y;
end;

function u2.Quantize(p4, p5) -- Line: 8
    local _epsilon = p4._epsilon;

    return Vector3.new(p5.X // _epsilon, p5.Y // _epsilon, p5.Z // _epsilon);
end;

function u2.Insert(p6, p7, p8) -- Line: 16
    local v9 = p6:Quantize(p7);
    local v10 = (v9.X * 262144 + v9.Z) * 131072 + v9.Y;
    local v11 = {
        pos = p7,
        val = p8
    };

    if not p6._table[v10] then
        p6._table[v10] = {};
    end;

    table.insert(p6._table[v10], v11);
end;

function u2.Remove(p12, p13, p14) -- Line: 29
    local v15 = p12:Quantize(p13);
    local v16 = (v15.X * 262144 + v15.Z) * 131072 + v15.Y;
    local v17 = p12._table[v16];

    if v17 then
        for i = #v17, 1, -1 do
            if v17[i].val == p14 then
                table.remove(v17, i);
            end;
        end;

        if #v17 == 0 then
            p12._table[v16] = nil;
        end;
    end;
end;

function u2.Collect(p18, p19, p20) -- Line: 44
    local v21 = p18:Quantize(p19);
    local _table = p18._table;
    local v22 = p20 or 1;
    assert(v22 <= (p18._maxRange or 5), "range too large");
    local v23 = {};

    for i = -v22, v22 do
        for i2 = -v22, v22 do
            for i3 = -v22, v22 do
                local v24 = v21 + Vector3.new(i, i2, i3);
                local v25 = _table[(v24.X * 262144 + v24.Z) * 131072 + v24.Y];

                if v25 then
                    for _, v in ipairs(v25) do
                        table.insert(v23, v.val);
                    end;
                end;
            end;
        end;
    end;

    return v23;
end;

function u2.Query(p26, p27, p28) -- Line: 66
    local v29 = p26:Quantize(p27);
    local _table = p26._table;
    local v30 = p28 or 1;
    assert(v30 <= (p26._maxRange or 5), "range too large");
    local v31 = nil;
    local v32 = nil;

    for i = -v30, v30 do
        for i2 = -v30, v30 do
            for i3 = -v30, v30 do
                local v33 = v29 + Vector3.new(i, i2, i3);
                local v34 = _table[(v33.X * 262144 + v33.Z) * 131072 + v33.Y];

                if v34 then
                    for _, v in ipairs(v34) do
                        local Magnitude = (v.pos - p27).Magnitude;

                        if not v31 or Magnitude < v31 then
                            v32 = v.val;
                            v31 = Magnitude;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v32;
end;

function v1.new(p35, p36) -- Line: 93
    -- upvalues: u2 (copy)
    return setmetatable({
        _table = {},
        _epsilon = p35 or 10,
        _maxRange = p36
    }, {
        __index = u2
    });
end;

return v1;