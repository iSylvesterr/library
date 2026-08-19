-- Decompiled with Potassium's decompiler.

local None = require(script.Parent.Parent.None);

return function(...) -- Line: 27, Name: merge
    -- upvalues: None (copy)
    local v1 = {};

    for i = 1, select("#", ...) do
        local v2 = select(i, ...);

        if type(v2) == "table" then
            for i2, v in pairs(v2) do
                if v == None then
                    local v = nil;
                end;

                v1[i2] = v;
            end;
        end;
    end;

    return v1;
end;