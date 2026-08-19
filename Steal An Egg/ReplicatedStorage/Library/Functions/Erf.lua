-- Decompiled with Potassium's decompiler.

local Erfc = require(script.Parent.Erfc);

return function(p1) -- Line: 3
    -- upvalues: Erfc (copy)
    return 1 - Erfc(p1);
end;