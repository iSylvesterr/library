-- Decompiled with Potassium's decompiler.

local FormatFigures = require(script.Parent.FormatFigures);

return function(p1) -- Line: 3
    -- upvalues: FormatFigures (copy)
    return FormatFigures(p1 * 100, 4, 5) .. "%";
end;