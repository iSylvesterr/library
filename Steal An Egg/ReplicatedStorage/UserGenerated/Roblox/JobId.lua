-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local JobId = game.JobId;

if #JobId ~= 0 and JobId ~= "00000000-0000-0000-0000-000000000000" then
    return JobId;
end;

assert(RunService:IsStudio());

if not RunService:IsServer() then
    local v1;

    while true do
        v1 = script:GetAttribute("Studio");

        if type(v1) == "string" then
            break;
        end;

        task.wait();
    end;

    return v1;
end;

local v2 = HttpService:GenerateGUID(false):lower();
script:SetAttribute("Studio", v2);

return v2;