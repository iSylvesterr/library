-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1) -- Line: 10
    -- upvalues: Asserts (copy)
    Asserts.array.finite(p1);

    return Vector3.new(p1[1], p1[2], p1[3]);
end;