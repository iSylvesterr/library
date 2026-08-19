-- Decompiled with Potassium's decompiler.

local u1 = nil;

return {
    set = function(p2) -- Line: 6, Name: set
        -- upvalues: u1 (ref)
        u1 = p2;
    end,

    get = function() -- Line: 10, Name: get
        -- upvalues: u1 (ref)
        return u1;
    end
};