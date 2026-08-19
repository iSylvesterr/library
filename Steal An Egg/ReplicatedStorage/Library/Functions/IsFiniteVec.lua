-- Decompiled with Potassium's decompiler.

local IsFinite = require(script.Parent.IsFinite);

return function(p1) -- Line: 3
    -- upvalues: IsFinite (copy)
    local v2 = IsFinite(p1.X) and IsFinite(p1.Y);

    if v2 then
        return IsFinite(p1.Z);
    end;

    return false;
end;