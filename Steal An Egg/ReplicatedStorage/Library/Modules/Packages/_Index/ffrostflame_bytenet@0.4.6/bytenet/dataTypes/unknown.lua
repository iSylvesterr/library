-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
local readRefs = require(script.Parent.Parent.process.readRefs);
require(script.Parent.Parent.types);
local writeReference = bufferWriter.writeReference;
local alloc = bufferWriter.alloc;

return function() -- Line: 8
    -- upvalues: alloc (copy), writeReference (copy), readRefs (copy)
    return {
        write = function(p1) -- Line: 10, Name: write
            -- upvalues: alloc (ref), writeReference (ref)
            alloc(1);
            writeReference(p1);
        end,

        read = function(p2, p3) -- Line: 15, Name: read
            -- upvalues: readRefs (ref)
            local v4 = readRefs.get();

            if v4 then
                return v4[buffer.readu8(p2, p3)], 1;
            end;

            return nil, 1;
        end
    };
end;