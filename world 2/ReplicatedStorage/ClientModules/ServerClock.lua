-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u1 = {};
local u2 = 0;
local u3 = false;
local u4 = 0;
local u5 = 0;

local function applySample(p6) -- Line: 48
    -- upvalues: u2 (ref), u4 (ref), u5 (ref), u3 (ref)
    if type(p6) ~= "number" or p6 <= 0 then
        return;
    end;

    u2 = p6 - os.time();
    u4 = p6;
    u5 = os.clock();
    u3 = true;
end;

function u1.Now() -- Line: 57
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u2 (ref)
    if u3 then
        return u4 + (os.clock() - u5);
    end;

    local success, result = pcall(function() -- Line: 64
        return workspace:GetServerTimeNow();
    end);

    if success and (type(result) == "number" and result > 0) then
        return result;
    end;

    return os.time() + u2;
end;

function u1.Seconds() -- Line: 74
    -- upvalues: u1 (copy)
    local v7 = u1.Now();

    return math.floor(v7);
end;

function u1.IsSynced() -- Line: 79
    -- upvalues: u3 (ref)
    return u3;
end;

local u8 = false;

function u1.Start() -- Line: 85
    -- upvalues: u8 (ref), RunService (copy), Networking (copy), u2 (ref), u4 (ref), u5 (ref), u3 (ref)
    if u8 or not RunService:IsClient() then
        return;
    end;

    u8 = true;
    task.spawn(function() -- Line: 89
        -- upvalues: Networking (ref), u2 (ref), u4 (ref), u5 (ref), u3 (ref)
        while true do
            local success, result = pcall(function() -- Line: 93
                -- upvalues: Networking (ref)
                return Networking.ServerClock.Sync:Fire();
            end);

            if success and (type(result) == "number" and result > 0) then
                u2 = result - os.time();
                u4 = result;
                u5 = os.clock();
                u3 = true;
            end;

            task.wait(u3 and 60 or 5);
        end;
    end);
end;

if RunService:IsClient() and Players.LocalPlayer then
    u1.Start();
end;

return u1;