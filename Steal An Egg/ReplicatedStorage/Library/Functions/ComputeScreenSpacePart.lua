-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");

return function(p1, p2) -- Line: 3
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local ViewportSize = CurrentCamera.ViewportSize;
    local v3 = math.rad(CurrentCamera.FieldOfView) * 0.5;
    local v4 = math.tan(v3);
    local v5 = p1 * 2 * (v4 * ViewportSize.X / ViewportSize.Y);
    local v6 = CurrentCamera:ViewportPointToRay(ViewportSize.X * 0.5, ViewportSize.Y * 0.5, p1 - p2 * 0.5);

    return CFrame.lookAt(Vector3.new(0, 0, 0), v6.Direction) + v6.Origin, Vector3.new(v5, p1 * 2 * v4, p2);
end;