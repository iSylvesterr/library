-- Decompiled with Potassium's decompiler.

local Asserts = require(game:GetService("ReplicatedStorage").Library.Asserts);

return function(p1) -- Line: 3, Name: DebugGetCallerName
    -- upvalues: Asserts (copy)
    Asserts.optional.number(p1);
    local v2 = debug.info(p1 or 4, "s");

    return v2 and v2:match("([^%.]-)$") or "";
end;