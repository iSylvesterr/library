-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.UserGenerated.FastFlags.SharedFastFlags);

if RunService:IsClient() then
    return require(ReplicatedStorage.UserGenerated.Client.ClientFastFlags);
end;

if RunService:IsServer() then
    local ServerScriptService = game:GetService("ServerScriptService");

    return require(ServerScriptService.UserGenerated.Server.ServerFastFlags);
end;

error("RunContext");

return nil;