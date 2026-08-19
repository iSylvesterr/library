-- Decompiled with Potassium's decompiler.

local find = require(script.Parent.find);

return function(p1, p2, p3) -- Line: 28, Name: includes
    -- upvalues: find (copy)
    return find(p1, p2, p3) ~= nil;
end;