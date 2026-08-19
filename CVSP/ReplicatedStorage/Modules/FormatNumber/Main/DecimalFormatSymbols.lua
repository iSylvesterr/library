-- Decompiled with Potassium's decompiler.

local _internal = require(script.Parent.Parent._internal);
local v1 = {};
local v2 = {};
local u3 = _internal.class.create_init_function("DecimalFormatSymbols", nil, v2, nil, _internal.class.ImmutabilityType.SYMBOLS);

function v2.GetSymbol(p4, p5) -- Line: 11
    -- upvalues: _internal (copy)
    return _internal.class.try_coerce(1, p4, "DecimalFormatSymbols")[_internal.class.try_coerce_enum(2, p5, _internal.enums.ENumberFormatSymbols)];
end;

function v2.SetSymbol(p6, p7, p8) -- Line: 18
    -- upvalues: _internal (copy)
    _internal.class.try_coerce(1, p6, "DecimalFormatSymbols")[_internal.class.try_coerce_enum(2, p7, _internal.enums.ENumberFormatSymbols)] = _internal.class.try_coerce(3, p8, "string");
end;

function v1.createWithLastResortData() -- Line: 27
    -- upvalues: u3 (copy), _internal (copy)
    return u3({
        [_internal.enums.ENumberFormatSymbols.kDecimalSeparatorSymbol] = ".",
        [_internal.enums.ENumberFormatSymbols.kGroupingSeparatorSymbol] = "",
        [_internal.enums.ENumberFormatSymbols.kMinusSignSymbol] = "-",
        [_internal.enums.ENumberFormatSymbols.kPlusSignSymbol] = "+",
        [_internal.enums.ENumberFormatSymbols.kExponentialSymbol] = "E",
        [_internal.enums.ENumberFormatSymbols.kInfinitySymbol] = "∞",
        [_internal.enums.ENumberFormatSymbols.kNaNSymbol] = "�"
    });
end;

return table.freeze(v1);