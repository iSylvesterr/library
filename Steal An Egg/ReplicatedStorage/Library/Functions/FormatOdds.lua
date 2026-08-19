-- Decompiled with Potassium's decompiler.

local FormatAbbreviated = require(script.Parent.FormatAbbreviated);

return function(p1) -- Line: 3
    -- upvalues: FormatAbbreviated (copy)
    return "1/" .. FormatAbbreviated(1 / p1);
end;