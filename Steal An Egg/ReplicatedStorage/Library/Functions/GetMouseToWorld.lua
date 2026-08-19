-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local CurrentCamera = workspace.CurrentCamera;
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 4
    -- upvalues: CurrentCamera (ref)
    CurrentCamera = workspace.CurrentCamera;
end);

return function(p1, p2) -- Line: 8
    -- upvalues: UserInputService (copy), GuiService (copy), CurrentCamera (ref)
    local v3 = UserInputService:GetMouseLocation();
    local v4 = GuiService:GetGuiInset();
    local v5 = CurrentCamera:ScreenPointToRay(v3.X + v4.X, v3.Y - v4.Y);

    return workspace:Raycast(v5.Origin, v5.Direction * (p2 or 1000), p1);
end;