-- Decompiled with Potassium's decompiler.

local u1 = {};

return function(p2) -- Line: 3
    -- upvalues: u1 (copy)
    local v3 = u1[p2];

    if not v3 then
        v3 = PhysicalProperties.new(p2);
        u1[p2] = v3;
    end;

    return v3;
end;