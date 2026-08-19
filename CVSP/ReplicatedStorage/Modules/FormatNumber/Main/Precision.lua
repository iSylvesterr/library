-- Decompiled with Potassium's decompiler.

local _internal = require(script.Parent.Parent._internal);
local v1 = {};
local v2 = {};
local u3 = _internal.class.create_init_function("Precision", nil, v2, nil, _internal.class.ImmutabilityType.DEFAULT);
local v4 = {};
local u5 = _internal.class.create_init_function("FractionPrecision", "Precision", v4, v2, _internal.class.ImmutabilityType.DEFAULT);

function v4.WithMinDigits(p6, p7) -- Line: 19
    -- upvalues: _internal (copy), u3 (copy)
    local v8 = _internal.class.try_coerce(1, p6, "FractionPrecision");
    local v9 = _internal.class.try_coerce_range(2, p7, 1, 999);

    return u3({
        minSignificantDigits = 1,
        sourcedWithSignificantDigits = false,
        type = _internal.enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
        minFractionDigits = v8.min,
        maxFractionDigits = v8.max,
        maxSignificantDigits = v9,
        roundingPriority = _internal.enums.RoundingPriority.RELAXED
    });
end;

function v4.WithMaxDigits(p10, p11) -- Line: 34
    -- upvalues: _internal (copy), u3 (copy)
    local v12 = _internal.class.try_coerce(1, p10, "FractionPrecision");
    local v13 = _internal.class.try_coerce_range(2, p11, 1, 999);

    return u3({
        minSignificantDigits = 1,
        sourcedWithSignificantDigits = false,
        type = _internal.enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
        minFractionDigits = v12.min,
        maxFractionDigits = v12.max,
        maxSignificantDigits = v13,
        roundingPriority = _internal.enums.RoundingPriority.STRICT
    });
end;

function v4.WithSignificantDigits(p14, p15, p16, p17) -- Line: 49
    -- upvalues: _internal (copy), u3 (copy)
    local v18 = _internal.class.try_coerce(1, p14, "FractionPrecision");
    local v19 = _internal.class.try_coerce_range(2, p15, 1, 999);
    local v20 = _internal.class.try_coerce_range(3, p16, 1, 999);
    local v21 = _internal.class.try_coerce_enum(4, p17, _internal.enums.RoundingPriority);

    return u3({
        sourcedWithSignificantDigits = true,
        type = _internal.enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
        minFractionDigits = v18.min,
        maxFractionDigits = v18.max,
        minSignificantDigits = v19,
        maxSignificantDigits = v20,
        roundingPriority = v21
    });
end;

local u22 = _internal.class.create_init_function("SignificantDigitsPrecision", "Precision", {}, v2, _internal.class.ImmutabilityType.DEFAULT);

function v1.unlimited() -- Line: 76
    -- upvalues: u3 (copy), _internal (copy)
    return u3({
        type = _internal.enums._Internal.PrecisionType.UNLIMITED
    });
end;

function v1.integer() -- Line: 82
    -- upvalues: u5 (copy), _internal (copy)
    return u5({
        min = 0,
        max = 0,
        type = _internal.enums._Internal.PrecisionType.FRACTION
    });
end;

function v1.fixedFraction(p23) -- Line: 90
    -- upvalues: _internal (copy), u5 (copy)
    local v24 = _internal.class.try_coerce_range(1, p23, 0, 999);

    return u5({
        type = _internal.enums._Internal.PrecisionType.FRACTION,
        min = v24,
        max = v24
    });
end;

function v1.minFraction(p25) -- Line: 100
    -- upvalues: _internal (copy), u5 (copy)
    local v26 = _internal.class.try_coerce_range(1, p25, 0, 999);

    return u5({
        type = _internal.enums._Internal.PrecisionType.FRACTION,
        min = v26,
        max = _internal.formatter_settings.MAX_PRECISION
    });
end;

function v1.maxFraction(p27) -- Line: 110
    -- upvalues: _internal (copy), u5 (copy)
    local v28 = _internal.class.try_coerce_range(1, p27, 0, 999);

    return u5({
        min = 0,
        type = _internal.enums._Internal.PrecisionType.FRACTION,
        max = v28
    });
end;

function v1.minMaxFraction(p29, p30) -- Line: 120
    -- upvalues: _internal (copy), u5 (copy)
    local v31 = _internal.class.try_coerce_range(1, p29, 0, 999);
    local v32 = _internal.class.try_coerce_range(2, p30, v31, 999);

    return u5({
        type = _internal.enums._Internal.PrecisionType.FRACTION,
        min = v31,
        max = v32
    });
end;

function v1.fixedSignificantDigits(p33) -- Line: 131
    -- upvalues: _internal (copy), u22 (copy)
    local v34 = _internal.class.try_coerce_range(1, p33, 1, 999);

    return u22({
        type = _internal.enums._Internal.PrecisionType.SIGNFICANT,
        min = v34,
        max = v34
    });
end;

function v1.minSignificantDigits(p35) -- Line: 141
    -- upvalues: _internal (copy), u22 (copy)
    local v36 = _internal.class.try_coerce_range(1, p35, 1, 999);

    return u22({
        type = _internal.enums._Internal.PrecisionType.SIGNFICANT,
        min = v36,
        max = _internal.formatter_settings.MAX_PRECISION
    });
end;

function v1.maxSignificantDigits(p37) -- Line: 151
    -- upvalues: _internal (copy), u22 (copy)
    local v38 = _internal.class.try_coerce_range(1, p37, 1, 999);

    return u22({
        min = 1,
        type = _internal.enums._Internal.PrecisionType.SIGNFICANT,
        max = v38
    });
end;

function v1.minMaxSignificantDigits(p39, p40) -- Line: 161
    -- upvalues: _internal (copy), u22 (copy)
    local v41 = _internal.class.try_coerce_range(1, p39, 1, 999);
    local v42 = _internal.class.try_coerce_range(2, p40, v41, 999);

    return u22({
        type = _internal.enums._Internal.PrecisionType.SIGNFICANT,
        min = v41,
        max = v42
    });
end;

return table.freeze(v1);