-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local u3 = {
    length = 1,

    read = function(p1, p2) -- Line: 11, Name: read
        return buffer.readu8(p1, p2) == 1, 1;
    end,

    write = bufferWriter.writebool
};

return function() -- Line: 20
    -- upvalues: u3 (copy)
    return u3;
end;