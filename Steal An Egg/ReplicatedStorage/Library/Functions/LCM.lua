-- Decompiled with Potassium's decompiler.

local GCD = require(script.Parent.GCD);

return function(p1, p2) -- Line: 3
    -- upvalues: GCD (copy)
    return p1 * p2 / GCD(p1, p2);
end;