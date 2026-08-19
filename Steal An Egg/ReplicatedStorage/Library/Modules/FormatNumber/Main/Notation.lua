-- Decompiled with Potassium's decompiler.

local _internal = require(script.Parent.Parent._internal);
local v1 = {};
local v2 = {};
local u3 = _internal.class.create_init_function("Notation", nil, v1, nil, _internal.class.ImmutabilityType.DEFAULT);
local v4 = {};
local u5 = _internal.class.create_init_function("ScientificNotation", "Notation", v4, v2, _internal.class.ImmutabilityType.DEFAULT);

function v4.WithMinExponentDigits(p6, p7) -- Line: 17
    -- upvalues: _internal (copy), u5 (copy)
    local v8 = _internal.class.try_coerce(1, p6, "ScientificNotation");
    local v9 = _internal.class.try_coerce_range(2, p7, 1, 999);
    local v10 = table.clone(v8);
    v10.minExponentDigits = v9;

    return u5(v10);
end;

function v4.WithExponentSignDisplay(p11, p12) -- Line: 30
    -- upvalues: _internal (copy), u5 (copy)
    local v13 = _internal.class.try_coerce(1, p11, "ScientificNotation");
    local v14 = _internal.class.try_coerce_enum(2, p12, _internal.enums.SignDisplay);
    local v15 = table.clone(v13);
    v15.exponentSignDisplay = v14;
    v15.displayExponentSignAt = _internal.formatter_settings.generate_from_sign_enum(v14);

    return u5(v15);
end;

_internal.class.create_init_function("CompactNotation", "Notation", {}, v2, _internal.class.ImmutabilityType.DEFAULT);
_internal.class.create_init_function("SimpleNotation", "Notation", {}, v2, _internal.class.ImmutabilityType.DEFAULT);

function v1.scientific() -- Line: 64
    -- upvalues: u5 (copy), _internal (copy)
    return u5({
        power10Scale = 1,
        minExponentDigits = 1,
        type = _internal.enums._Internal.NotationType.SCIENTIFIC,
        exponentSignDisplay = _internal.enums.SignDisplay.AUTO,
        displayExponentSignAt = _internal.formatter_settings.generate_from_sign_enum(_internal.enums.SignDisplay.AUTO)
    });
end;

function v1.engineering() -- Line: 74
    -- upvalues: u5 (copy), _internal (copy)
    return u5({
        power10Scale = 3,
        minExponentDigits = 1,
        type = _internal.enums._Internal.NotationType.SCIENTIFIC,
        exponentSignDisplay = _internal.enums.SignDisplay.AUTO,
        displayExponentSignAt = _internal.formatter_settings.generate_from_sign_enum(_internal.enums.SignDisplay.AUTO)
    });
end;

function v1.compactWithSuffixThousands(p16) -- Line: 84
    -- upvalues: _internal (copy), u3 (copy)
    local v17 = _internal.class.try_coerce(1, p16, "{string}");
    local v18 = table.find(v17, "");

    if v18 then
        error(string.format("Index %d is an empty string, please double check the suffixes", v18), 2);
    elseif #v17 == 0 then
        error("Suffixes is empty", 2);
    end;

    return u3({
        power10Scale = 3,
        type = _internal.enums._Internal.NotationType.COMPACT,
        suffixes = v17,
        suffixesLength = #v17
    });
end;

function v1.simple() -- Line: 104
    -- upvalues: u3 (copy), _internal (copy)
    return u3({
        type = _internal.enums._Internal.NotationType.SIMPLE
    });
end;

return table.freeze(v1);