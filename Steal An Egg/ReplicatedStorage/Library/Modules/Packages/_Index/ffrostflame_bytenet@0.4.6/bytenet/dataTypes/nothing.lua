-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.types);
local u1 = {
    write = function() -- Line: 4, Name: write
    end,

    read = function() -- Line: 6, Name: read
        return nil, 0;
    end
};

return function() -- Line: 11
    -- upvalues: u1 (copy)
    return u1;
end;