-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local writeu16 = bufferWriter.writeu16;
local writecopy = bufferWriter.writecopy;
local dyn_alloc = bufferWriter.dyn_alloc;
local u7 = {
    read = function(p1, p2) -- Line: 9, Name: read
        local v3 = buffer.readu16(p1, p2);
        local v4 = buffer.create(v3);
        buffer.copy(v4, 0, p1, p2 + 2, v3);

        return v4, v3 + 2;
    end,

    write = function(p5) -- Line: 18, Name: write
        -- upvalues: writeu16 (copy), dyn_alloc (copy), writecopy (copy)
        local v6 = buffer.len(p5);
        writeu16(v6);
        dyn_alloc(v6);
        writecopy(p5);
    end
};

return function() -- Line: 29
    -- upvalues: u7 (copy)
    return u7;
end;