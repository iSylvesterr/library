-- Decompiled with Potassium's decompiler.

local Lerp = require(script.Parent.Lerp);

return function(p1, p2) -- Line: 3
    -- upvalues: Lerp (copy)
    local R = p1.R;
    local G = p1.G;
    local B = p1.B;
    local v3 = R * 0.299 + G * 0.587 + B * 0.114;
    local v4 = Lerp(v3, R, 1 + p2);
    local v5 = Lerp(v3, G, 1 + p2);
    local v6 = Lerp(v3, B, 1 + p2);

    return Color3.new(v4, v5, v6);
end;