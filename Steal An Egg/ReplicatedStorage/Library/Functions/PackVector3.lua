-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1) -- Line: 10
    -- upvalues: Asserts (copy)
    Asserts.Vector3(p1);

    return { p1.X, p1.Y, p1.Z };
end;