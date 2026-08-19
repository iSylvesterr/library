-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");

if RunService:IsServer() then
    return require(script.KnitServer);
end;

local KnitServer = script:FindFirstChild("KnitServer");

if KnitServer and RunService:IsRunning() then
    KnitServer:Destroy();
end;

return require(script.KnitClient);