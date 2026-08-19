-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local EmitDuration = require(ReplicatedStorage.SharedModules.EmitDuration);

function v1.Init(p2) -- Line: 31
end;

function v1.Start(p3) -- Line: 33
    -- upvalues: Networking (copy), ReplicatedStorage (copy), Debris (copy), EmitDuration (copy)
    Networking.Beanstalk.Spawned.OnClientEvent:Connect(function() -- Line: 34
        -- upvalues: ReplicatedStorage (ref), Debris (ref), EmitDuration (ref)
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("Beanstalk");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("BeanstalkSpawnVFX");
        end;

        if not Assets then
            warn("[JandelsBeanstalkSpawnVFXController] Assets.Beanstalk.BeanstalkSpawnVFX not found");

            return;
        end;

        local v4 = Assets:Clone();
        v4.Parent = workspace;
        Debris:AddItem(v4, EmitDuration(v4) + 2);
    end);
end;

return v1;