-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(u1) -- Line: 8
    -- upvalues: Asserts (copy)
    Asserts.string(u1);

    return function(p2) -- Line: 11
        -- upvalues: Asserts (ref), u1 (copy)
        Asserts.optional.string(p2);

        return (p2 and `{p2}: ` or "") .. u1;
    end;
end;