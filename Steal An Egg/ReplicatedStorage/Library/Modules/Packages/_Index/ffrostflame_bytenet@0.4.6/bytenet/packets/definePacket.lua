-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.types);
local packet = require(script.Parent.packet);

return function(u1) -- Line: 12
    -- upvalues: packet (copy)
    return function(p2) -- Line: 13
        -- upvalues: packet (ref), u1 (copy)
        return packet(u1, p2);
    end;
end;