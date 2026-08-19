-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent.Parent);

return function(p1, p2, p3) -- Line: 3
    -- upvalues: Parent (copy)
    local v4 = Parent.Gradient.new(p1, Parent.Templates.Chrome.Color, 0);
    v4:SetRotation(-90, 1);
    v4:SetOffsetSpeed(p2, 1);
    local v5, v6;

    if p1:IsA("ImageLabel") and p1.BackgroundTransparency == 1 then
        v5 = nil;
        v6 = nil;
    else
        v6 = Parent.Stroke.new(p1, p3);
        v5 = Parent.Gradient.new(v6.Instance, Parent.Templates.Chrome.Color, 0);
        v5:SetRotation(-89, 1);
        v5:SetOffsetSpeed(p2 * 0.58, 1);
    end;

    return {
        Effects = { v4, v5, v6 }
    };
end;