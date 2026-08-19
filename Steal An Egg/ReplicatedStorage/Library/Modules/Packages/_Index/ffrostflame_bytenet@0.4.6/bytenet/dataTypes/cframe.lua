-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local writef32NoAlloc = bufferWriter.writef32NoAlloc;
local alloc = bufferWriter.alloc;
local u13 = {
    read = function(p1, p2) -- Line: 8, Name: read
        local v3 = buffer.readf32(p1, p2);
        local v4 = buffer.readf32(p1, p2 + 4);
        local v5 = buffer.readf32(p1, p2 + 8);
        local v6 = buffer.readf32(p1, p2 + 12);
        local v7 = buffer.readf32(p1, p2 + 16);
        local v8 = buffer.readf32(p1, p2 + 20);

        return CFrame.new(v3, v4, v5) * CFrame.Angles(v6, v7, v8), 24;
    end,

    write = function(p9) -- Line: 18, Name: write
        -- upvalues: alloc (copy), writef32NoAlloc (copy)
        local X = p9.X;
        local Y = p9.Y;
        local Z = p9.Z;
        local v10, v11, v12 = p9:ToEulerAnglesXYZ();
        alloc(24);
        writef32NoAlloc(X);
        writef32NoAlloc(Y);
        writef32NoAlloc(Z);
        writef32NoAlloc(v10);
        writef32NoAlloc(v11);
        writef32NoAlloc(v12);
    end
};

return function() -- Line: 33
    -- upvalues: u13 (copy)
    return u13;
end;