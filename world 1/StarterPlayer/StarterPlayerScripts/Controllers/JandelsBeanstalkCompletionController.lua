-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local ScreenConfetti = require(ReplicatedStorage.ClientModules.Effects.ScreenConfetti);
local u2 = nil;

function v1.Init(p3) -- Line: 19
end;

function v1.Start(p4) -- Line: 21
    -- upvalues: Networking (copy), u2 (ref), ScreenConfetti (copy)
    Networking.Beanstalk.Completed.OnClientEvent:Connect(function() -- Line: 22
        -- upvalues: u2 (ref), ScreenConfetti (ref)
        if u2 and u2:IsActive() then
            u2:Stop();
        end;

        u2 = ScreenConfetti.Play(ScreenConfetti.GrandPrizeParams);
    end);
end;

return v1;