-- Decompiled with Potassium's decompiler.

local CurrentCamera = workspace.CurrentCamera;
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 2
    -- upvalues: CurrentCamera (ref)
    CurrentCamera = workspace.CurrentCamera;
end);

return function(p1) -- Line: 6
    -- upvalues: CurrentCamera (ref)
    if p1 then
        local v2, v3 = CurrentCamera:WorldToScreenPoint(p1);

        return UDim2.fromOffset(v2.X, v2.Y), v3;
    end;
end;