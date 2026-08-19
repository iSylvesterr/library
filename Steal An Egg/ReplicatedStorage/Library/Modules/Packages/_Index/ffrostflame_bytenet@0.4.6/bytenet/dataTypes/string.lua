-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local writeu16 = bufferWriter.writeu16;
local writestring = bufferWriter.writestring;
local dyn_alloc = bufferWriter.dyn_alloc;
local u6 = {
    read = function(p1, p2) -- Line: 12, Name: read
        local v3 = buffer.readu16(p1, p2);

        return buffer.readstring(p1, p2 + 2, v3), v3 + 2;
    end,

    write = function(p4) -- Line: 17, Name: write
        -- upvalues: writeu16 (copy), dyn_alloc (copy), writestring (copy)
        local v5 = string.len(p4);
        writeu16(v5);
        dyn_alloc(v5);
        writestring(p4);
    end
};

return function() -- Line: 26
    -- upvalues: u6 (copy)
    return u6;
end;