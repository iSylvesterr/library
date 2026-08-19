-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent.Parent);

return function(p1, p2, p3) -- Line: 3
    -- upvalues: Parent (copy)
    local v4 = Parent.Gradient.new(p1, Parent.Templates.Ice.Color, 0);
    v4:SetRotation(-65, 1);
    v4:SetOffsetSpeed(p2, 1);
    local v5 = Parent.Stroke.new(p1, p3);
    local v6 = Parent.Gradient.new(v5.Instance, Parent.Templates.Ice.Color, 0);
    v6:SetRotation(-61, 1);
    v6:SetOffsetSpeed(p2 * 0.23, 1);

    return {
        Effects = { v4, v6, v5 }
    };
end;