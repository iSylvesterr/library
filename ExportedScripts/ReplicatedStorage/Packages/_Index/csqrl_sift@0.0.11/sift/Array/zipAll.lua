-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
local reduce = require(script.Parent.reduce);
local None = require(Parent.None);

return function(...) -- Line: 24, Name: zipAll
    -- upvalues: reduce (copy), None (copy)
    local v1 = { ... };
    local v2 = {};

    if select("#", ...) == 0 then
        return v2;
    end;

    for i = 1, reduce(v1, function(p3, p4) -- Line: 33
        return math.max(p3, #p4);
    end, #v1[1]) do
        local v5 = {};

        for _, v in ipairs(v1) do
            local v6 = v[i];

            if v6 == nil then
                v6 = None;
            end;

            table.insert(v5, v6);
        end;

        table.insert(v2, v5);
    end;

    return v2;
end;