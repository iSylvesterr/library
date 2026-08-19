-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local writeu16 = bufferWriter.writeu16;

return function(p1) -- Line: 10
    -- upvalues: writeu16 (copy)
    local write = p1.write;
    local read = p1.read;

    return {
        read = function(p2, p3) -- Line: 15, Name: read
            -- upvalues: read (copy)
            local v4 = buffer.readu16(p2, p3);
            local v5 = p3 + 2;
            local v6 = table.create(v4);

            for i = 1, v4 do
                local v7, v8 = read(p2, v5);
                v6[i] = v7;
                v5 = v5 + v8;
            end;

            return v6, v5 - p3;
        end,

        write = function(p9) -- Line: 30, Name: write
            -- upvalues: writeu16 (ref), write (copy)
            local v10 = #p9;
            writeu16(v10);

            for i = 1, v10 do
                write(p9[i]);
            end;
        end
    };
end;