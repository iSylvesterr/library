-- Decompiled with Potassium's decompiler.

local CameraShaker = require(script.CameraShaker);
local CurrentCamera = workspace.CurrentCamera;
local v2 = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(p1) -- Line: 3
    -- upvalues: CurrentCamera (copy)
    CurrentCamera.CFrame = CurrentCamera.CFrame * p1;
end);
v2:Start();

return v2;