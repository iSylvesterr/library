-- Decompiled with Potassium's decompiler.

local isSubset = require(script.Parent.isSubset);

return function(p1, p2) -- Line: 21, Name: isSuperset
    -- upvalues: isSubset (copy)
    return isSubset(p2, p1);
end;