-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent.Parent);

return function(p1, p2) -- Line: 3
    -- upvalues: Parent (copy)
    local v3 = Parent.Gradient.new(p1, Parent.Templates.Ghost.Color, Parent.Templates.Ghost.Transparency);
    v3:SetOffsetSpeed(p2, 1);
    v3:SetTransparencyOffsetSpeed(p2 * 0.9, 1);

    return {
        Effects = { v3 }
    };
end;