-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local writebool = bufferWriter.writebool;

return function(p1) -- Line: 6
    -- upvalues: writebool (copy)
    local read = p1.read;
    local write = p1.write;

    return {
        read = function(p2, p3) -- Line: 16, Name: read
            -- upvalues: read (copy)
            if buffer.readu8(p2, p3) == 0 then
                return nil, 1;
            end;

            local v4, v5 = read(p2, p3 + 1);

            return v4, v5 + 1;
        end,

        write = function(p6) -- Line: 27, Name: write
            -- upvalues: writebool (ref), write (copy)
            local v7 = p6 ~= nil;
            writebool(v7);

            if v7 then
                write(p6);
            end;
        end
    };
end;