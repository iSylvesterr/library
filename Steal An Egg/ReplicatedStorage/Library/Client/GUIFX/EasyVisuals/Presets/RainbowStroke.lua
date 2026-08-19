-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent.Parent);

return function(p1, p2, p3) -- Line: 3
    -- upvalues: Parent (copy)
    local v4 = Parent.Stroke.new(p1, p3);
    local v5 = Parent.Gradient.new(v4.Instance, Parent.Templates.Rainbow.Color, 0);
    v5:SetOffsetSpeed(-p2, 1);

    return {
        Effects = { v5, v4 }
    };
end;