-- Decompiled with Potassium's decompiler.

local u1 = {};

return {
    set = function(p2, p3) -- Line: 11, Name: set
        -- upvalues: u1 (copy)
        u1[p2] = p3;
    end,

    ref = function() -- Line: 16, Name: ref
        -- upvalues: u1 (copy)
        return u1;
    end
};