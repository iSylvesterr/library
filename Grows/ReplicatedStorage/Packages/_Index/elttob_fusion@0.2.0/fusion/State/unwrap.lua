-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local xtypeof = require(Parent.Utility.xtypeof);

return function(p1, p2) -- Line: 11, Name: unwrap
    -- upvalues: xtypeof (copy)
    if xtypeof(p1) == "State" then
        return p1:get(p2);
    end;

    return p1;
end;