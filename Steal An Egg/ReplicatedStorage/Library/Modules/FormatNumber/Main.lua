-- Decompiled with Potassium's decompiler.

local _internal = require(script.Parent._internal);
local Notation = require(script.Notation);
local Precision = require(script.Precision);
local IntegerWidth = require(script.IntegerWidth);
local DecimalFormatSymbols = require(script.DecimalFormatSymbols);
local enums = _internal.enums;
local v1 = {};
local v2 = {};
local u3 = _internal.class.create_init_function("NumberFormatter", nil, v2, nil, _internal.class.ImmutabilityType.NUMBER_FORMATTER);

function v2.Notation(p4, p5) -- Line: 26
    -- upvalues: _internal (copy), u3 (copy)
    _internal.class.try_coerce(1, p4, "NumberFormatter");

    return u3({
        key = "notation",
        value = _internal.class.try_coerce(2, p5, "Notation"),
        parent = _internal.class.get_data(p4)
    });
end;

function v2.Precision(p6, p7) -- Line: 36
    -- upvalues: _internal (copy), u3 (copy)
    _internal.class.try_coerce(1, p6, "NumberFormatter");

    return u3({
        key = "precision",
        value = _internal.class.try_coerce(2, p7, "Precision"),
        parent = _internal.class.get_data(p6)
    });
end;

function v2.RoundingMode(p8, p9) -- Line: 46
    -- upvalues: _internal (copy), enums (copy), u3 (copy)
    _internal.class.try_coerce(1, p8, "NumberFormatter");

    return u3({
        key = "roundingMode",
        value = _internal.class.try_coerce_enum(2, p9, enums.RoundingMode),
        parent = _internal.class.get_data(p8)
    });
end;

function v2.Grouping(p10, p11) -- Line: 56
    -- upvalues: _internal (copy), enums (copy), u3 (copy)
    _internal.class.try_coerce(1, p10, "NumberFormatter");

    return u3({
        key = "grouping",
        value = _internal.class.try_coerce_enum(2, p11, enums.GroupingStrategy),
        parent = _internal.class.get_data(p10)
    });
end;

function v2.IntegerWidth(p12, p13) -- Line: 66
    -- upvalues: _internal (copy), u3 (copy)
    _internal.class.try_coerce(1, p12, "NumberFormatter");

    return u3({
        key = "integerWidth",
        value = _internal.class.try_coerce(2, p13, "IntegerWidth"),
        parent = _internal.class.get_data(p12)
    });
end;

function v2.Symbols(p14, p15) -- Line: 76
    -- upvalues: _internal (copy), u3 (copy)
    _internal.class.try_coerce(1, p14, "NumberFormatter");

    return u3({
        key = "symbols",
        value = _internal.class.try_coerce(2, p15, "DecimalFormatSymbols"),
        parent = _internal.class.get_data(p14)
    });
end;

function v2.Sign(p16, p17) -- Line: 86
    -- upvalues: _internal (copy), enums (copy), u3 (copy)
    _internal.class.try_coerce(1, p16, "NumberFormatter");

    return u3({
        key = "sign",
        value = _internal.class.try_coerce_enum(2, p17, enums.SignDisplay),
        parent = _internal.class.get_data(p16)
    });
end;

function v2.Decimal(p18, p19) -- Line: 96
    -- upvalues: _internal (copy), enums (copy), u3 (copy)
    _internal.class.try_coerce(1, p18, "NumberFormatter");

    return u3({
        key = "decimal",
        value = _internal.class.try_coerce_enum(2, p19, enums.DecimalSeparatorDisplay),
        parent = _internal.class.get_data(p18)
    });
end;

local function resolve_nf_data(p20) -- Line: 107
    -- upvalues: _internal (copy)
    return _internal.formatter_settings.resolve_settings(_internal.formatter_settings.linked_list_to_dict(p20));
end;

function v2.Format(p21, p22) -- Line: 111
    -- upvalues: _internal (copy), resolve_nf_data (copy), enums (copy)
    _internal.class.try_coerce(1, p21, "NumberFormatter");

    if type(p22) == "string" then
        error(
            "Argument #2 as a string interpreted as decimal is not currently supported, please cast the argument to a double if you want the string to be interpreted as a double",
            2
        );
    end;

    local v23 = _internal.class.try_coerce(2, p22, "number");
    local v24 = _internal.class.get_resolved_data(p21, resolve_nf_data);
    local symbols = v24.symbols;
    local v25, v26, v27;

    if v23 == v23 then
        if v23 == (1 / 0) or v23 == (-1 / 0) then
            v25 = v23 < 0;
            v26 = symbols[enums.ENumberFormatSymbols.kInfinitySymbol];
            v27 = false;
        else
            local v28, v29, v30;

            if v23 == 0 then
                v25 = math.atan2(v23, -1) < 0;
                v28 = nil;
                v29 = 0;
                v30 = 1;
            else
                v25 = v23 < 0;
                v28, v29, v30 = _internal.decimal_conversion.from_double((math.abs(v23)));
            end;

            v26, v27 = _internal.format.format_unsigned_finite(v28, v29, v30, v25, v24);
        end;
    else
        v25 = string.byte(string.pack(">d", v23)) >= 128;
        v26 = symbols[enums.ENumberFormatSymbols.kNaNSymbol];
        v27 = true;
    end;

    return _internal.format.display_sign(v26, v25, v27, v24.displaySignAt, v24.symbols);
end;

function v2.ToSkeleton(p31) -- Line: 168
    -- upvalues: _internal (copy)
    local v32 = _internal.class.try_coerce(1, p31, "NumberFormatter");

    return _internal.skeleton.settings_to_skeleton(_internal.formatter_settings.linked_list_to_dict(v32));
end;

function v1.with() -- Line: 174
    -- upvalues: u3 (copy)
    return u3(nil);
end;

function v1.forSkeleton(p33) -- Line: 178
    -- upvalues: _internal (copy), u3 (copy)
    local v34 = _internal.class.try_coerce(1, p33, "string");
    local v35, v36 = _internal.skeleton.to_option_linked_list(v34);

    if v35 then
        return v35, u3(v36);
    end;

    return v35, v36;
end;

return table.freeze({
    NumberFormatter = table.freeze(v1),
    Notation = Notation,
    Precision = Precision,
    RoundingPriority = enums.RoundingPriority,
    RoundingMode = enums.RoundingMode,
    GroupingStrategy = enums.GroupingStrategy,
    IntegerWidth = IntegerWidth,
    DecimalFormatSymbols = DecimalFormatSymbols,
    ENumberFormatSymbols = enums.ENumberFormatSymbols,
    SignDisplay = enums.SignDisplay,
    DecimalSeparatorDisplay = enums.DecimalSeparatorDisplay
});