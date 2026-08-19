-- Decompiled with Potassium's decompiler.

local enums = require(script.Parent.enums);
local u1 = {
    MAX_PRECISION = 2147483647
};

function u1.resolve_min_max_sig(p2, p3) -- Line: 5
    -- upvalues: enums (copy), u1 (copy)
    local v4 = nil;
    local v5 = nil;

    if p2.type == enums._Internal.PrecisionType.SIGNFICANT then
        return p2.min, p2.max;
    end;

    if p2.type == enums._Internal.PrecisionType.FRACTION then
        return p3 + p2.min, p3 + p2.max;
    end;

    if p2.type == enums._Internal.PrecisionType.FRACTION_SIGNIFICANT then
        local v6 = p3 + p2.minFractionDigits;
        local v7 = p3 + p2.maxFractionDigits;
        local minSignificantDigits = p2.minSignificantDigits;
        local maxSignificantDigits = p2.maxSignificantDigits;

        if p2.roundingPriority == enums.RoundingPriority.RELAXED then
            v4 = math.max(v6, minSignificantDigits);
            v5 = math.max(v7, maxSignificantDigits);
        else
            v4 = math.min(v6, minSignificantDigits);
            v5 = math.min(v7, maxSignificantDigits);
        end;

        if not p2.sourcedWithSignificantDigits then
            return v6, v5;
        end;
    elseif p2.type == enums._Internal.PrecisionType.UNLIMITED then
        v5 = u1.MAX_PRECISION;
        v4 = 1;
    end;

    return v4, v5;
end;

local u8 = table.freeze({
    [enums.ENumberFormatSymbols.kDecimalSeparatorSymbol] = ".",
    [enums.ENumberFormatSymbols.kGroupingSeparatorSymbol] = ",",
    [enums.ENumberFormatSymbols.kMinusSignSymbol] = "-",
    [enums.ENumberFormatSymbols.kPlusSignSymbol] = "+",
    [enums.ENumberFormatSymbols.kExponentialSymbol] = "E",
    [enums.ENumberFormatSymbols.kInfinitySymbol] = "∞",
    [enums.ENumberFormatSymbols.kNaNSymbol] = "NaN"
});

function u1.generate_from_sign_enum(p9) -- Line: 49
    -- upvalues: enums (copy)
    local v10 = nil;
    local v11 = nil;
    local v12 = nil;
    local v13 = nil;

    if p9 == enums.SignDisplay.AUTO then
        v10 = true;
        v11 = true;
        v12 = false;
        v13 = false;
    elseif p9 == enums.SignDisplay.ALWAYS then
        v10 = true;
        v11 = true;
        v12 = true;
        v13 = true;
    elseif p9 == enums.SignDisplay.NEVER then
        v10 = false;
        v11 = false;
        v12 = false;
        v13 = false;
    elseif p9 == enums.SignDisplay.NEGATIVE then
        v10 = true;
        v11 = false;
        v12 = false;
        v13 = false;
    elseif p9 == enums.SignDisplay.EXCEPT_ZERO then
        v10 = true;
        v11 = false;
        v12 = false;
        v13 = true;
    end;

    return table.freeze({
        negative = v10,
        negativeZero = v11,
        positiveZero = v12,
        positive = v13
    });
end;

function u1.linked_list_to_dict(p14) -- Line: 77
    local v15 = {};

    while p14 do
        if not v15[p14.key] then
            v15[p14.key] = p14.value;
        end;

        p14 = p14.parent;
    end;

    return table.freeze(v15);
end;

function u1.resolve_settings(p16) -- Line: 90
    -- upvalues: enums (copy), u8 (copy), u1 (copy)
    local v17 = {
        notation = p16.notation or table.freeze({
            type = enums._Internal.NotationType.SIMPLE
        })
    };
    local v18 = v17.notation.type == enums._Internal.NotationType.COMPACT;

    if p16.precision then
        v17.precision = p16.precision;
    else
        local v19;

        if v18 then
            v19 = table.freeze({
                minFractionDigits = 0,
                maxFractionDigits = 0,
                minSignificantDigits = 1,
                maxSignificantDigits = 2,
                type = enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
                roundingPriority = enums.RoundingPriority.RELAXED
            });
        else
            v19 = table.freeze({
                min = 0,
                max = 6,
                type = enums._Internal.PrecisionType.FRACTION
            });
        end;

        v17.precision = v19;
    end;

    if p16.roundingMode then
        v17.roundingMode = p16.roundingMode;
    else
        local v20;

        if v18 or v17.notation.type == enums._Internal.NotationType.SCIENTIFIC then
            v20 = enums.RoundingMode.DOWN;
        else
            v20 = enums.RoundingMode.HALF_EVEN;
        end;

        v17.roundingMode = v20;
    end;

    if p16.grouping then
        local grouping = p16.grouping;
        v17.minGrouping = grouping == enums.GroupingStrategy.MIN2 and 5 or (grouping == enums.GroupingStrategy.ON_ALIGNED and 4 or nil);
    else
        v17.minGrouping = v18 and 5 or 4;
    end;

    v17.integerWidth = p16.integerWidth or table.freeze({
        min = 1,
        max = -1
    });
    v17.symbols = p16.symbols or u8;

    if p16.sign then
        v17.displaySignAt = u1.generate_from_sign_enum(p16.sign);
    else
        v17.displaySignAt = u1.generate_from_sign_enum(enums.SignDisplay.AUTO);
    end;

    v17.alwaysDisplayDecimal = p16.decimal == enums.DecimalSeparatorDisplay.ALWAYS;

    return table.freeze(v17);
end;

return table.freeze(u1);