-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local TutorialRunner = require(script.TutorialRunner);

return {
    StartOrder = 3,

    Init = function(p1) -- Line: 10, Name: Init
    end,

    Start = function(p2) -- Line: 12, Name: Start
        -- upvalues: Networking (copy), TutorialRunner (copy)
        local u3 = false;
        Networking.Tutorial.Start.OnClientEvent:Connect(function(p4) -- Line: 14
            -- upvalues: u3 (ref), TutorialRunner (ref)
            if u3 then
                return;
            end;

            u3 = true;
            TutorialRunner(p4);
        end);
        task.spawn(function() -- Line: 22
            -- upvalues: u3 (ref), Networking (ref)
            local LocalPlayer = game:GetService("Players").LocalPlayer;
            local v5 = assert(LocalPlayer);

            while v5:GetAttribute("LoadingScreenDone") ~= true do
                task.wait(0.5);
            end;

            local v6 = 0;

            while not u3 and v6 < 30 do
                v6 = v6 + 1;
                Networking.Tutorial.Ready:Fire();
                task.wait(2);
            end;
        end);
    end
};