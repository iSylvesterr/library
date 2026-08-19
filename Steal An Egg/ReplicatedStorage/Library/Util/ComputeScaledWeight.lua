-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1, p2) -- Line: 10, Name: computeScaledWeight
    -- upvalues: Asserts (copy)
    Asserts.number(p1);
    Asserts.number(p2);

    return p1 * math.max(p2, 0);
end;