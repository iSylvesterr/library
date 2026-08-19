-- Decompiled with Potassium's decompiler.

local formatter_settings = require(script.Parent.formatter_settings);
local enums = require(script.Parent.enums);
local v1 = {};
local u2 = {
    [enums.SignDisplay.AUTO] = nil,
    [enums.SignDisplay.ALWAYS] = "sign-always",
    [enums.SignDisplay.NEVER] = "sign-never",
    [enums.SignDisplay.EXCEPT_ZERO] = "sign-except-zero",
    [enums.SignDisplay.NEGATIVE] = "sign-negative"
};

local function notation_to_skeleton(p3) -- Line: 14
    -- upvalues: enums (copy), u2 (copy)
    local v4, v5;

    if p3.type == enums._Internal.NotationType.SCIENTIFIC then
        v4 = true;
        v5 = p3.power10Scale == 3 and "engineering" or "scientific";

        if p3.minExponentDigits ~= 1 then
            v5 = v5 .. "/*" .. string.rep("e", p3.minExponentDigits);
        end;

        if p3.exponentSignDisplay ~= enums.SignDisplay.AUTO then
            return v4, v5 .. "/" .. u2[p3.exponentSignDisplay];
        end;
    else
        if p3.type == enums._Internal.NotationType.SIMPLE then
            return true, nil;
        end;

        v4 = false;
        v5 = "Compact notation skeleton is not supported for being represented as a skeleton string in this module";
    end;

    return v4, v5;
end;

local function precision_to_skeleton(p6) -- Line: 39
    -- upvalues: enums (copy), formatter_settings (copy)
    local v7 = nil;
    local v8 = nil;
    local v9 = nil;
    local v10 = nil;
    local v11 = nil;
    local v12 = nil;
    local v13 = nil;

    if p6.type == enums._Internal.PrecisionType.FRACTION then
        v10 = p6.min;
        v11 = p6.max;
    elseif p6.type == enums._Internal.PrecisionType.SIGNFICANT then
        v12 = p6.min;
        v13 = p6.max;
    elseif p6.type == enums._Internal.PrecisionType.FRACTION_SIGNIFICANT then
        v10 = p6.minFractionDigits;
        v11 = p6.maxFractionDigits;

        if p6.sourcedWithSignificantDigits then
            v12 = p6.minSignificantDigits;
            v13 = p6.maxSignificantDigits;
        elseif p6.roundingPriority == enums.RoundingPriority.RELAXED then
            v12 = p6.maxSignificantDigits;
            v13 = formatter_settings.MAX_PRECISION;
        else
            v13 = p6.maxSignificantDigits;
            v12 = 1;
        end;
    else
        v7 = "precision-unlimited";
    end;

    if v10 then
        if v11 == 0 then
            v8 = "precision-integer";
        else
            local v14 = "." .. string.rep("0", v10);

            if v11 == formatter_settings.MAX_PRECISION then
                v8 = v14 .. "*";
            else
                v8 = v14 .. string.rep("#", v11 - v10);
            end;
        end;
    end;

    if v12 then
        local v15 = string.rep("@", v12);

        if v13 == formatter_settings.MAX_PRECISION then
            v9 = v15 .. "*";
        else
            v9 = v15 .. string.rep("#", v13 - v12);
        end;
    end;

    if v8 then
        if v9 then
            v8 = v8 .. "/" .. v9;

            if p6.type == enums._Internal.PrecisionType.FRACTION_SIGNIFICANT and p6.sourcedWithSignificantDigits then
                if p6.roundingPriority == enums.RoundingPriority.RELAXED then
                    return v8 .. "r";
                end;

                return v8 .. "s";
            end;
        end;
    else
        v8 = v9 or v7;
    end;

    return v8;
end;

local u16 = {
    [enums.RoundingMode.CEILING] = "rounding-mode-ceiling",
    [enums.RoundingMode.FLOOR] = "rounding-mode-floor",
    [enums.RoundingMode.DOWN] = "rounding-mode-down",
    [enums.RoundingMode.UP] = "rounding-mode-up",
    [enums.RoundingMode.HALF_EVEN] = "rounding-mode-half-even",
    [enums.RoundingMode.HALF_DOWN] = "rounding-mode-half-down",
    [enums.RoundingMode.HALF_UP] = "rounding-half-up"
};
local u17 = {
    [enums.GroupingStrategy.OFF] = "group-off",
    [enums.GroupingStrategy.MIN2] = "group-min2",
    [enums.GroupingStrategy.ON_ALIGNED] = "group-on-aligned"
};

local function int_width_to_skeleton(p18) -- Line: 123
    if p18.max == -1 then
        return "integer-width/*" .. string.rep("0", p18.min);
    end;

    return p18.max == 0 and p18.min == 0 and "integer-width-trunc" or "integer-width/" .. string.rep("#", p18.max - p18.min) .. string.rep("0", p18.min);
end;

local u19 = {
    [enums.DecimalSeparatorDisplay.AUTO] = nil,
    [enums.DecimalSeparatorDisplay.ALWAYS] = "decimal-always"
};

function v1.settings_to_skeleton(p20) -- Line: 142
    -- upvalues: notation_to_skeleton (copy), precision_to_skeleton (copy), u16 (copy), u17 (copy), int_width_to_skeleton (copy), u19 (copy)
    local v21 = {};
    local v22 = nil;
    local v23;

    if p20.notation then
        local v24;
        v23, v24 = notation_to_skeleton(p20.notation);

        if v23 then
            table.insert(v21, v24);
        else
            v22 = v24;
        end;
    else
        v23 = true;
    end;

    if v23 then
        if p20.precision then
            local v25 = precision_to_skeleton(p20.precision);
            table.insert(v21, v25);
        end;

        if p20.roundingMode then
            table.insert(v21, u16[p20.roundingMode]);
        end;

        if p20.grouping then
            table.insert(v21, u17[p20.grouping]);
        end;

        if p20.integerWidth then
            local v26 = int_width_to_skeleton(p20.integerWidth);
            table.insert(v21, v26);
        end;

        if p20.decimal then
            table.insert(v21, u19[p20.decimal]);
        end;

        v22 = table.concat(v21, " ");
    end;

    return v23, v22;
end;

local u27 = {
    ["notation-simple"] = "notation",
    ["precision-unlimited"] = "precision",
    [".+"] = "precision",
    ["rounding-mode-ceiling"] = "roundingMode",
    ["rounding-mode-floor"] = "roundingMode",
    ["rounding-mode-down"] = "roundingMode",
    ["rounding-mode-up"] = "roundingMode",
    ["rounding-mode-half-even"] = "roundingMode",
    ["rounding-mode-half-down"] = "roundingMode",
    ["rounding-mode-half-up"] = "roundingMode",
    ["group-off"] = "grouping",
    ["group-min2"] = "grouping",
    ["group-on-aligned"] = "grouping",
    [",_"] = "grouping",
    [",?"] = "grouping",
    [",!"] = "grouping",
    ["sign-auto"] = "sign",
    ["sign-always"] = "sign",
    ["sign-never"] = "sign",
    ["sign-except-zero"] = "sign",
    ["sign-negative"] = "sign",
    ["+!"] = "sign",
    ["+_"] = "sign",
    ["+?"] = "sign",
    ["+-"] = "sign",
    ["decimal-auto"] = "decimal",
    ["decimal-always"] = "decimal"
};
local u28 = {
    ["notation-simple"] = table.freeze({
        type = enums._Internal.NotationType.SIMPLE
    }),
    ["precision-unlimited"] = table.freeze({
        type = enums._Internal.PrecisionType.UNLIMITED
    }),
    [".+"] = table.freeze({
        type = enums._Internal.PrecisionType.UNLIMITED
    }),
    ["rounding-mode-ceiling"] = enums.RoundingMode.CEILING,
    ["rounding-mode-floor"] = enums.RoundingMode.FLOOR,
    ["rounding-mode-down"] = enums.RoundingMode.DOWN,
    ["rounding-mode-up"] = enums.RoundingMode.UP,
    ["rounding-mode-half-even"] = enums.RoundingMode.HALF_EVEN,
    ["rounding-mode-half-down"] = enums.RoundingMode.HALF_DOWN,
    ["rounding-mode-half-up"] = enums.RoundingMode.HALF_UP,
    ["group-off"] = enums.GroupingStrategy.OFF,
    ["group-min2"] = enums.GroupingStrategy.MIN2,
    ["group-on-aligned"] = enums.GroupingStrategy.ON_ALIGNED,
    [",_"] = enums.GroupingStrategy.OFF,
    [",?"] = enums.GroupingStrategy.MIN2,
    [",!"] = enums.GroupingStrategy.ON_ALIGNED,
    ["sign-auto"] = enums.SignDisplay.AUTO,
    ["sign-always"] = enums.SignDisplay.ALWAYS,
    ["sign-never"] = enums.SignDisplay.NEVER,
    ["sign-except-zero"] = enums.SignDisplay.EXCEPT_ZERO,
    ["sign-negative"] = enums.SignDisplay.NEGATIVE,
    ["+!"] = enums.SignDisplay.ALWAYS,
    ["+_"] = enums.SignDisplay.NEVER,
    ["+?"] = enums.SignDisplay.EXCEPT_ZERO,
    ["+-"] = enums.SignDisplay.NEGATIVE,
    ["decimal-auto"] = enums.DecimalSeparatorDisplay.AUTO,
    ["decimal-always"] = enums.DecimalSeparatorDisplay.ALWAYS
};

local function skeleton_to_scientific_notation(p29) -- Line: 257
    -- upvalues: enums (copy), u28 (copy), formatter_settings (copy)
    local v30, v31, v31 = string.match(p29, "^(%a+)/?([^/]*)/?([^/]*)$");
    local v32 = 1;
    local AUTO = enums.SignDisplay.AUTO;

    if v30 ~= "scientific" and v30 ~= "engineering" then
        return nil;
    end;

    if string.match(v31, "^[%*%+]e+$") then
        v32 = #v31 - 1;
    elseif string.match(v31, "^[%*%+]e+$") then
        v32 = #v31 - 1;
    end;

    if v31 ~= "" then
        if string.sub(v31, 1, 5) ~= "sign-" then
            return nil;
        end;

        AUTO = u28[v31];
    end;

    if v32 > 999 then
        return nil;
    end;

    return table.freeze({
        type = enums._Internal.NotationType.SCIENTIFIC,
        power10Scale = v30 == "engineering" and 3 or 1,
        minExponentDigits = v32,
        exponentSignDisplay = AUTO,
        displayExponentSignAt = formatter_settings.generate_from_sign_enum(AUTO)
    });
end;

local function skeleton_to_scientific_notation_concise(p33) -- Line: 295
    -- upvalues: u28 (copy), enums (copy), formatter_settings (copy)
    local v34, v35 = string.match(p33, "^(EE?)(.+)$");

    if not v34 then
        return nil;
    end;

    local v36, v37 = string.match(v35, "^(%+[!%?])(.+)$");
    local v38;

    if v36 then
        v38 = u28[v36];
    else
        v38 = enums.SignDisplay.AUTO;
        v37 = v35;
    end;

    if not string.match(v37, "^0+$") then
        return nil;
    end;

    if #v37 > 999 then
        return nil;
    end;

    return table.freeze({
        type = enums._Internal.NotationType.SCIENTIFIC,
        power10Scale = v34 == "EE" and 3 or 1,
        minExponentDigits = #v37,
        exponentSignDisplay = v38,
        displayExponentSignAt = formatter_settings.generate_from_sign_enum(v38)
    });
end;

local function skeleton_to_precision(p39) -- Line: 334
    -- upvalues: formatter_settings (copy), enums (copy)
    local v40, v41, v42 = string.match(p39, "^%.((0*)#*)(.*)$");

    if not v40 then
        v40, v42 = string.match(p39, "^(precision%-integer)(.*)$");
    end;

    if not v40 then
        local v43, v44, v45 = string.match(p39, "^((@+)#*)([%*%+]?)$");

        if not v43 then
            return nil;
        end;

        local v46 = #v44;
        local v47 = #v43;

        if v45 ~= "" then
            if v46 ~= v47 then
                return nil;
            end;

            string.sub(v45, 2);
            v47 = -1;
        end;

        if v46 > 999 or v47 > 999 then
            return nil;
        end;

        if v47 == -1 then
            v47 = formatter_settings.MAX_PRECISION;
        end;

        return table.freeze({
            type = enums._Internal.PrecisionType.SIGNFICANT,
            min = v46,
            max = v47
        });
    end;

    local v48, v49;

    if v40 == "precision-integer" then
        v48 = 0;
        v49 = 0;
    else
        v48 = #v41;
        v49 = #v40;
    end;

    if string.match(v42, "^[%*%+]") and v41 == v40 then
        v42 = string.sub(v42, 2);
        v49 = -1;
    end;

    if v48 > 999 or v49 > 999 then
        return nil;
    end;

    if v49 == -1 then
        v49 = formatter_settings.MAX_PRECISION;
    end;

    if string.sub(v42, 1, 1) ~= "/" then
        if v42 == "" then
            return table.freeze({
                type = enums._Internal.PrecisionType.FRACTION,
                min = v48,
                max = v49
            });
        end;

        return nil;
    end;

    local v50 = false;
    local v51, v52, v53 = string.match(v42, "^/((@+)#*)([%*%+rs]?)$");

    if not v51 or v53 == "" and v52 ~= "@" or (v53 == "*" or v53 == "+") and v52 ~= v51 then
        return nil;
    end;

    local v54, v55;

    if v53 == "" then
        v54 = #v51;
        v55 = 1;
        v53 = "s";
    elseif v53 == "*" or v53 == "+" then
        v54 = #v52;
        v55 = 1;
        v53 = "r";
    else
        v55 = #v52;
        v54 = #v51;
        v50 = true;
    end;

    if v55 > 999 or v54 > 999 then
        return nil;
    end;

    local freeze = table.freeze;
    local v56 = {
        type = enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
        minFractionDigits = v48,
        maxFractionDigits = v49,
        minSignificantDigits = v55,
        maxSignificantDigits = v54
    };
    local v57;

    if v53 == "r" then
        v57 = enums.RoundingPriority.RELAXED;
    else
        v57 = enums.RoundingPriority.STRICT;
    end;

    v56.roundingPriority = v57;
    v56.sourcedWithSignificantDigits = v50;

    return freeze(v56);
end;

local function skeleton_to_int_width(p58) -- Line: 451
    if p58 == "integer-width-trunc" then
        return table.freeze({
            min = 0,
            max = 0
        });
    end;

    local v59 = string.match(p58, "^integer%-width/[%*%+](0*)$");

    if v59 then
        if #v59 > 999 then
            return nil;
        end;

        return table.freeze({
            max = -1,
            min = #v59
        });
    end;

    local v60, v61 = string.match(p58, "^integer%-width/(#*(0*))$");

    if v60 and (v60 ~= "" and (#v60 <= 999 and #v61 <= 999)) then
        return table.freeze({
            min = #v61,
            max = #v60
        });
    end;

    return nil;
end;

local function skeleton_to_int_width_concise(p62) -- Line: 481
    if string.match(p62, "^0+$") and #p62 < 1000 then
        return table.freeze({
            max = -1,
            min = #p62
        });
    end;

    return nil;
end;

function v1.to_option_linked_list(p63) -- Line: 490
    -- upvalues: u27 (copy), u28 (copy), skeleton_to_scientific_notation (copy), skeleton_to_scientific_notation_concise (copy), skeleton_to_precision (copy), skeleton_to_int_width (copy), skeleton_to_int_width_concise (copy)
    local v64 = {};
    local v65 = nil;

    for i, v in string.gmatch(p63, "()(%S+)") do
        local v66 = u27[v];
        local v67;

        if v66 then
            v67 = u28[v];
        else
            v67 = nil;
        end;

        if not v67 then
            v67 = skeleton_to_scientific_notation(v) or skeleton_to_scientific_notation_concise(v);

            if v67 then
                v66 = "notation";
            end;
        end;

        if not v67 then
            v67 = skeleton_to_precision(v);

            if v67 then
                v66 = "precision";
            end;
        end;

        if not v67 then
            v67 = skeleton_to_int_width(v) or skeleton_to_int_width_concise(v);

            if v67 then
                v66 = "integerWidth";
            end;
        end;

        if not v66 or v64[v66] then
            return false, string.format("number skeleton syntax error near \'%*\' at position %d", string.gsub(v, "\'", "\\\'"), i);
        end;

        v64[v66] = true;
        v65 = {
            key = v66,
            value = v67,
            parent = v65
        };
    end;

    return true, v65;
end;

return v1;