-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1, p2) -- Line: 22, Name: sort
    -- upvalues: copy (copy)
    local v3 = copy(p1);
    table.sort(v3, p2);

    return v3;
end;