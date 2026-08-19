-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local writef32NoAlloc = bufferWriter.writef32NoAlloc;
local alloc = bufferWriter.alloc;
local u4 = {
    read = function(p1, p2) -- Line: 12, Name: read
        return Vector2.new(buffer.readf32(p1, p2), (buffer.readf32(p1, p2 + 4))), 8;
    end,

    write = function(p3) -- Line: 16, Name: write
        -- upvalues: alloc (copy), writef32NoAlloc (copy)
        alloc(8);
        writef32NoAlloc(p3.X);
        writef32NoAlloc(p3.Y);
    end
};

return function() -- Line: 23
    -- upvalues: u4 (copy)
    return u4;
end;