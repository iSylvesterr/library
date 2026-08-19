-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent.Parent);

return function(p1, p2, p3, p4, p5, p6) -- Line: 3
    -- upvalues: Parent (copy)
    local v7 = Parent.Gradient.new(p1, p4, 0);
    v7:SetOffsetSpeed(p2, 1);

    if typeof(p6) == "table" then
        for _, v in p6 do
            local v8 = v7[v.Function];

            if typeof(v8) == "function" and typeof(v.Package) == "table" then
                v8(v7, unpack(v.Package));
            end;
        end;
    end;

    return {
        Effects = { v7 }
    };
end;