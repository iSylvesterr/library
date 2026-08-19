-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1, p2) -- Line: 8
    -- upvalues: Asserts (copy)
    Asserts.table(p1);
    Asserts.optional.string(p2);
    local u3 = p2 or "unknown";
    setmetatable(p1, {
        __index = function(p4, p5) -- Line: 15, Name: __index
            -- upvalues: u3 (copy)
            error(`Attempted to index missing key '{p5}' in registry: (root: '{u3}')`, 2);
        end,

        __newindex = function(p6, p7) -- Line: 18, Name: __newindex
            -- upvalues: u3 (copy)
            error(`Attempted to set new key '{p7}' in registry: (root: '{u3}')`, 2);
        end
    });

    return p1;
end;