-- Decompiled with Potassium's decompiler.

local IsFinite = require(script.Parent.IsFinite);

return function(p1) -- Line: 3
    -- upvalues: IsFinite (copy)
    local v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13 = p1:GetComponents();
    local v14 = IsFinite(v2) and (IsFinite(v3) and IsFinite(v4)) and (IsFinite(v5) and IsFinite(v6) and (IsFinite(v7) and IsFinite(v8)) and (IsFinite(v9) and IsFinite(v10) and (IsFinite(v11) and IsFinite(v12)))) and IsFinite(v13);

    return v14;
end;