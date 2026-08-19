-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local u3 = {
    write = bufferWriter.writef32,

    read = function(p1, p2) -- Line: 9, Name: read
        return buffer.readf32(p1, p2), 4;
    end
};

return function() -- Line: 14
    -- upvalues: u3 (copy)
    return u3;
end;