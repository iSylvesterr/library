-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerScriptService = game:GetService("ServerScriptService");
require(ReplicatedStorage.UserGenerated.ABTests.SharedABTests);

if RunService:IsServer() then
    return require(ServerScriptService.UserGenerated.Server.ServerABTests);
end;

return require(ReplicatedStorage.UserGenerated.Client.ClientABTests);