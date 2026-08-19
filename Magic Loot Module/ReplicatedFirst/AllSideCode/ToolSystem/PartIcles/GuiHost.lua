-- Decompiled with Potassium's decompiler.

local CoreGui = game:GetService("CoreGui");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Selection = game:GetService("Selection");
local success = pcall(function() -- Line: 12
    -- upvalues: Selection (copy)
    return Selection:Get();
end);

return {
    resolveContainer = function() -- Line: 16, Name: resolveContainer
        -- upvalues: success (copy), CoreGui (copy), RunService (copy), Players (copy)
        if success then
            return CoreGui;
        end;

        local v1 = RunService:IsClient() and Players.LocalPlayer;

        if v1 then
            return v1:FindFirstChildOfClass("PlayerGui") or v1:WaitForChild("PlayerGui", 5);
        end;

        return nil;
    end
};