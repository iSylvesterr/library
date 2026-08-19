-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local writeu8NoAlloc = bufferWriter.writeu8NoAlloc;
local alloc = bufferWriter.alloc;
local u4 = {
    write = function(p1) -- Line: 8, Name: write
        -- upvalues: alloc (copy), writeu8NoAlloc (copy)
        alloc(3);
        writeu8NoAlloc(p1.R * 255);
        writeu8NoAlloc(p1.G * 255);
        writeu8NoAlloc(p1.B * 255);
    end,

    read = function(p2, p3) -- Line: 14, Name: read
        return Color3.fromRGB(buffer.readu8(p2, p3), buffer.readu8(p2, p3 + 1), (buffer.readu8(p2, p3 + 2))), 3;
    end
};

return function() -- Line: 19
    -- upvalues: u4 (copy)
    return u4;
end;