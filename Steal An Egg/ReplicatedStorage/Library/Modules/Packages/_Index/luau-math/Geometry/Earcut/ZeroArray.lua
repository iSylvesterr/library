-- Decompiled with Potassium's decompiler.

local u12 = {
    new = function(p1) -- Line: 3, Name: new
        local v2 = newproxy(true);
        local u3 = getmetatable(v2);
        u3.Array = p1 or {};

        function u3.__index(p4, p5) -- Line: 9
            -- upvalues: u3 (copy)
            return u3.Array[p5 + 1];
        end;

        function u3.__newindex(p6, p7, p8) -- Line: 13
            -- upvalues: u3 (copy)
            u3.Array[p7 + 1] = p8;
        end;

        function u3.__len() -- Line: 17
            -- upvalues: u3 (copy)
            return #u3.Array;
        end;

        return v2;
    end,

    getOneIndex = function(p9) -- Line: 24, Name: getOneIndex
        return getmetatable(p9).Array;
    end,

    push = function(p10, p11) -- Line: 29, Name: push
        p10[#p10] = p11;
    end
};

function u12.sort(p13, p14) -- Line: 33
    -- upvalues: u12 (copy)
    table.sort(u12.getOneIndex(p13), p14);
end;

function u12.pop(p15) -- Line: 37
    local v16 = #p15 - 1;
    local v17 = p15[v16];
    p15[v16] = nil;

    return v17;
end;

return u12;