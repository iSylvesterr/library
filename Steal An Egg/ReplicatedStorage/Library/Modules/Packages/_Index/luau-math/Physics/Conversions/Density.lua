-- Decompiled with Potassium's decompiler.

local u3 = {
    toKilogramsPerCubicMeter = function(p1) -- Line: 19, Name: toKilogramsPerCubicMeter
        return p1 * 0.001;
    end,

    toGramPerMilliliter = function(p2) -- Line: 24, Name: toGramPerMilliliter
        return p2 * 1e-6;
    end
};
local u5 = {
    toGramPerCubicCentimeter = function(p4) -- Line: 29, Name: toGramPerCubicCentimeter
        return p4 / 1e-6;
    end
};

function u5.toKilogramsPerCubicMeter(p6) -- Line: 32
    -- upvalues: u3 (copy), u5 (copy)
    return u3.toKilogramsPerCubicMeter(u5.toGramPerCubicCentimeter(p6));
end;

local u8 = {
    toGramPerCubicCentimeter = function(p7) -- Line: 41, Name: toGramPerCubicCentimeter
        return p7 / 0.001;
    end
};

function u8.toKilogramsPerCubicMeter(p9) -- Line: 46
    -- upvalues: u3 (copy), u8 (copy)
    return u3.toKilogramsPerCubicMeter(u8.toGramPerCubicCentimeter(p9));
end;

return {
    GramPerCubicCentimeter = u3,
    KilogramsPerCubicMeter = u8,
    GramPerMilliliter = u5
};