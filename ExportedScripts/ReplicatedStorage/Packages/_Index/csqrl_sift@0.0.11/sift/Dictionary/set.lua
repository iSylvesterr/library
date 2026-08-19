-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1, p2, p3) -- Line: 21, Name: set
    -- upvalues: copy (copy)
    local v4 = copy(p1);
    v4[p2] = p3;

    return v4;
end;