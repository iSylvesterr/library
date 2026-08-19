-- Decompiled with Potassium's decompiler.

local DegDeltaUnsafe = require(script.Parent.DegDeltaUnsafe);
local DegNorm = require(script.Parent.DegNorm);

return function(p1, p2) -- Line: 3
    -- upvalues: DegDeltaUnsafe (copy), DegNorm (copy)
    return DegDeltaUnsafe(DegNorm(p1), DegNorm(p2));
end;