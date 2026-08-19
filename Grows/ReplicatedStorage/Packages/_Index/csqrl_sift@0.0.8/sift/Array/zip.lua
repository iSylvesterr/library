-- Decompiled with Potassium's decompiler.

local reduce = require(script.Parent.reduce);

return function(...) -- Line: 20, Name: zip
    -- upvalues: reduce (copy)
    local v1 = { ... };
    local v2 = {};

    if select("#", ...) == 0 then
        return v2;
    end;

    for i = 1, reduce(v1, function(p3, p4) -- Line: 30
        return math.min(p3, #p4);
    end, #v1[1]) do
        local v5 = {};

        for _, v in ipairs(v1) do
            table.insert(v5, v[i]);
        end;

        table.insert(v2, v5);
    end;

    return v2;
end;