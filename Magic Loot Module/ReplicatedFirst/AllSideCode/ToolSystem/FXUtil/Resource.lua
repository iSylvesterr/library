-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local RunService = game:GetService("RunService");
    local Debris = game:GetService("Debris");
    local Players = game:GetService("Players");
    local SoundModule = UtilsSystem.SoundModule;

    function p1.Debris(u2, p3) -- Line: 27
        -- upvalues: Debris (copy)
        task.delay(p3 or 0, function() -- Line: 30
            -- upvalues: Debris (ref), u2 (copy)
            Debris:AddItem(u2, 0);
        end);
    end;

    function p1.PlaySound(p4, p5, p6, p7, p8, p9, p10, p11) -- Line: 51
        -- upvalues: RunService (copy), Players (copy), SoundModule (copy)
        local v12 = {
            SoundName = p5,
            Is2D = p8 == nil,
            PlayPosition = p8
        };

        if RunService:IsServer() then
            for _, v in pairs(Players:GetPlayers()) do
                SoundModule:PlaySound(v, v12);
            end;

            return;
        end;

        if p4.Releaser and p4.Releaser ~= Players.LocalPlayer then
            return;
        end;

        SoundModule:PlaySoundLocal(v12);
    end;
end;