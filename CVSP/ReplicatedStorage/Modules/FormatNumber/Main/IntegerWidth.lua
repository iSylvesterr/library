-- Decompiled with Potassium's decompiler.

local _internal = require(script.Parent.Parent._internal);
local v1 = {};
local v2 = {};
local u3 = _internal.class.create_init_function("IntegerWidth", nil, v2, nil, _internal.class.ImmutabilityType.DEFAULT);

function v2.TruncateAt(p4, p5) -- Line: 12
    -- upvalues: _internal (copy), u3 (copy)
    local v6 = _internal.class.try_coerce(1, p4, "IntegerWidth");
    local v7 = tonumber(p5) and math.ceil(p5) == -1 and -1 or _internal.class.try_coerce_range(1, p5, v6.min, 999);

    return u3({
        min = v6.min,
        max = v7
    });
end;

function v1.zeroFillTo(p8) -- Line: 29
    -- upvalues: _internal (copy), u3 (copy)
    return u3({
        max = -1,
        min = _internal.class.try_coerce_range(1, p8, 0, 999)
    });
end;

return table.freeze(v1);