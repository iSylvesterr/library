-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.types);
local u3 = {
    write = require(script.Parent.Parent.process.bufferWriter).writeu8,

    read = function(p1, p2) -- Line: 9, Name: read
        return buffer.readu8(p1, p2), 1;
    end
};

return function() -- Line: 14
    -- upvalues: u3 (copy)
    return u3;
end;