-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent.Parent);

return function(p1, p2) -- Line: 3
    -- upvalues: Parent (copy)
    local v3 = Parent.Gradient.new(p1, Parent.Templates.Gold.Color, 0);
    v3:SetRotation(-75, 1);
    v3:SetOffsetSpeed(p2, 1);

    return {
        Effects = { v3 }
    };
end;