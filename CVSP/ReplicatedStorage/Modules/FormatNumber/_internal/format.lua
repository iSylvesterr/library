-- Decompiled with Potassium's decompiler.

local enums = require(script.Parent.enums);
local formatter_settings = require(script.Parent.formatter_settings);
local u1 = {};

local function internal_get_digits(p2, p3, p4, p5) -- Line: 5
    local v6;

    if p4 <= 0 then
        v6 = string.rep("0", -p4 + 1);
        p4 = 1;
    else
        v6 = "";
    end;

    local v7 = p5 - math.max(p3, p4 - 1);
    local v8;

    if v7 <= 0 then
        v8 = "";
    else
        v8 = string.rep("0", v7);
        p5 = p3;
    end;

    return v6 .. (p3 < p4 and "" or string.char(table.unpack(p2, p4, p5))) .. v8;
end;

function u1.strip_trailing_zero(p9, p10) -- Line: 32
    if p10 < 0 then
        return 0;
    end;

    while p9[p10] == 0 do
        p10 = p10 - 1;
    end;

    return p10;
end;

function u1.round_sig(p11, p12, p13, p14, p15) -- Line: 43
    -- upvalues: enums (copy), u1 (copy)
    local v16 = 0;

    if p13 < p12 then
        local v17 = nil;
        local v18;

        if p15 == enums.RoundingMode.CEILING then
            v18 = p14 and 1 or -2;
        elseif p15 == enums.RoundingMode.FLOOR then
            v18 = p14 and -2 or 1;
        elseif p15 == enums.RoundingMode.UP then
            v18 = -2;
        elseif p15 == enums.RoundingMode.DOWN then
            v18 = 1;
        elseif p15 == enums.RoundingMode.HALF_EVEN then
            v18 = p13 <= 0 and 0 or p11[p13] % -2;
        else
            v18 = p15 == enums.RoundingMode.HALF_DOWN and 0 or (p15 == enums.RoundingMode.HALF_UP and -1 or v17);
        end;

        if v18 < (p13 < 0 and -1 or (p11[p13 + 1] > 5 and 1 or (p11[p13 + 1] == 5 and (p13 + 1 < p12 and 1 or 0) or -1))) then
            while p11[p13] == 9 and p13 > 0 do
                p13 = p13 - 1;
            end;

            if p13 <= 0 then
                p11[1] = 1;
                v16 = 1 - p13;
                p13 = 1;
            else
                p11[p13] = p11[p13] + 1;
            end;
        end;

        p12 = u1.strip_trailing_zero(p11, p13);
    end;

    return p12, v16;
end;

function u1.resolve_int_frac(p19, p20, p21, p22, p23, p24, p25) -- Line: 108
    -- upvalues: internal_get_digits (copy)
    for i = 1, p20 do
        p19[i] = p19[i] + 48;
    end;

    local v26, v27;

    if p21 < p22 and p23 < p21 + 1 then
        v26 = "0";
        v27 = "";
    else
        v26 = internal_get_digits(p19, p20, p22, p21);
        v27 = internal_get_digits(p19, p20, p21 + 1, p23);
    end;

    if p24 and p24 <= p21 - p22 + 1 then
        local v28;

        if p25 == "%" then
            v28 = "%0%%";
        elseif #p25 > 1 then
            v28 = "%0" .. string.reverse(p25);
        else
            v28 = "%0" .. p25;
        end;

        v26 = string.reverse((string.gsub(string.reverse(v26), "...", v28, (p21 - p22) / 3)));
    end;

    return v26, v27;
end;

function u1.format_expt(p29, p30, p31, p32) -- Line: 145
    -- upvalues: enums (copy)
    local v33 = "";
    local v34;

    if p29 < 0 then
        v34 = tostring(-p29);

        if p32.negative then
            v33 = p30[enums.ENumberFormatSymbols.kMinusSignSymbol];
        end;
    elseif p29 == 0 then
        v34 = "0";

        if p32.positiveZero then
            v33 = p30[enums.ENumberFormatSymbols.kPlusSignSymbol];
        end;
    else
        v34 = tostring(p29);

        if p32.positive then
            v33 = p30[enums.ENumberFormatSymbols.kPlusSignSymbol];
        end;
    end;

    local v35 = string.rep("0", p31 - #v34) .. v34;

    return p30[enums.ENumberFormatSymbols.kExponentialSymbol] .. v33 .. v35;
end;

function u1.resolve_with_notation(p36, p37, p38, p39, p40) -- Line: 171
    -- upvalues: enums (copy), u1 (copy)
    local v41 = nil;
    local v42 = nil;
    local v43 = nil;

    if p37 <= 0 then
        if p39.type == enums._Internal.NotationType.SCIENTIFIC then
            v41 = u1.format_expt(0, p40, p39.minExponentDigits, p39.displayExponentSignAt);
        end;
    elseif p39.type == enums._Internal.NotationType.SIMPLE then
        p38 = p38 + p37;
    else
        local power10Scale = p39.power10Scale;
        local v44 = p38 + p37 - 1;
        local v45 = math.floor(v44 / power10Scale);
        p38 = v44 - v45 * power10Scale + 1;

        if p39.type == enums._Internal.NotationType.COMPACT then
            local suffixesLength = p39.suffixesLength;

            if suffixesLength < v45 then
                p38 = p38 + (v45 - suffixesLength) * power10Scale;
                v41 = p39.suffixes[suffixesLength];
            elseif v45 < 0 then
                p38 = p38 + v45 * power10Scale;
            elseif v45 ~= 0 then
                v41 = p39.suffixes[v45];
            end;

            if v45 >= 0 and v45 < suffixesLength then
                v43 = p39.suffixes[v45 + 1];
                v42 = power10Scale;
            end;
        else
            v41 = u1.format_expt(v45 * power10Scale, p40, p39.minExponentDigits, p39.displayExponentSignAt);
            v43 = u1.format_expt((v45 + 1) * power10Scale, p40, p39.minExponentDigits, p39.displayExponentSignAt);
            v42 = power10Scale;
        end;
    end;

    return p38, v41, v42, v43;
end;

function u1.format_unsigned_finite(p46, p47, p48, p49, p50) -- Line: 232
    -- upvalues: u1 (copy), formatter_settings (copy), enums (copy)
    local min = p50.integerWidth.min;
    local max = p50.integerWidth.max;
    local symbols = p50.symbols;
    local v51, v52, v53, v52 = u1.resolve_with_notation(p46, p47, p48, p50.notation, symbols);
    local v54, v55 = formatter_settings.resolve_min_max_sig(p50.precision, v51);
    local v56, v57 = u1.round_sig(p46, p47, v55, p49, p50.roundingMode);
    local v58 = v56 == 0;

    if v57 > 0 then
        if v51 == v53 then
            assert(v57 == 1);
            v51 = 1;
        else
            v51 = v51 + v57;
        end;

        local v59;
        v54, v59 = formatter_settings.resolve_min_max_sig(p50.precision, v51);
    elseif v58 then
        local v60;
        v54, v60 = formatter_settings.resolve_min_max_sig(p50.precision, 1);
        v51 = 1;
    end;

    if v51 < min then
        max = min;
    elseif max == -1 or max >= v51 then
        max = v51;
    end;

    local v61, v62 = u1.resolve_int_frac(p46, v56, v51, math.max(v51, 0) - max + 1, math.max(v56, v54), p50.minGrouping, symbols[enums.ENumberFormatSymbols.kGroupingSeparatorSymbol]);

    if p50.alwaysDisplayDecimal or v62 ~= "" then
        v61 = v61 .. symbols[enums.ENumberFormatSymbols.kDecimalSeparatorSymbol] .. v62;
    end;

    if v52 then
        v61 = v61 .. v52;
    end;

    return v61, v58;
end;

function u1.display_sign(p63, p64, p65, p66, p67) -- Line: 316
    -- upvalues: enums (copy)
    local v68, v69;

    if p64 then
        v68 = p67[enums.ENumberFormatSymbols.kMinusSignSymbol];

        if p65 then
            v69 = p66.negativeZero;
        else
            v69 = p66.negative;
        end;
    else
        v68 = p67[enums.ENumberFormatSymbols.kPlusSignSymbol];

        if p65 then
            v69 = p66.positiveZero;
        else
            v69 = p66.positive;
        end;
    end;

    if v69 then
        return v68 .. p63;
    end;

    return p63;
end;

return table.freeze(u1);