-- Decompiled with Potassium's decompiler.

local bufferWriter = require(script.Parent.Parent.process.bufferWriter);
require(script.Parent.Parent.types);
local writeu16 = bufferWriter.writeu16;

return function(u1, u2) -- Line: 7
    -- upvalues: writeu16 (copy)
    local write = u1.write;
    local write2 = u2.write;

    return {
        read = function(p3, p4) -- Line: 16, Name: read
            -- upvalues: u1 (copy), u2 (copy)
            local v5 = buffer.readu16(p3, p4);
            local v6 = p4 + 2;
            local v7 = {};

            for _ = 1, v5 do
                local v8, v9 = u1.read(p3, v6);
                local v10 = v6 + v9;
                local v11, v12 = u2.read(p3, v10);
                v6 = v10 + v12;
                v7[v8] = v11;
            end;

            return v7, v6 - p4;
        end,

        write = function(p13) -- Line: 38, Name: write
            -- upvalues: writeu16 (ref), write (copy), write2 (copy)
            local v14 = 0;

            for _ in p13 do
                v14 = v14 + 1;
            end;

            writeu16(v14);

            for i, v in p13 do
                write(i);
                write2(v);
            end;
        end
    };
end;