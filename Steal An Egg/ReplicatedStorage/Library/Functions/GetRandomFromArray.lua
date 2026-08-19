-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1) -- Line: 12
    -- upvalues: Asserts (copy)
    Asserts.table(p1);

    return p1[math.random(#p1)];
end;