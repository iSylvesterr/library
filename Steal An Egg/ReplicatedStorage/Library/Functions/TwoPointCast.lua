-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");

return function(p1, p2, p3) -- Line: 3
    -- upvalues: Workspace (copy)
    local Magnitude = (p1 - p2).Magnitude;

    return Workspace:Raycast(p1, CFrame.lookAt(p1, p2).LookVector * Magnitude, p3);
end;