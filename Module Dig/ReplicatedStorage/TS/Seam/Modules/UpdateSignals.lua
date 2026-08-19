-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");

if RunService:IsClient() then
    v1.OnFrameUpdate = RunService.RenderStepped;
    v1.OnFramePreUpdate = RunService.PreRender;

    return v1;
end;

v1.OnFrameUpdate = RunService.Heartbeat;
v1.OnFramePreUpdate = RunService.Heartbeat;

return v1;