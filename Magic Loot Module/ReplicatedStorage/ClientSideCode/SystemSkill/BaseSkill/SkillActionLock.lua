-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");

return {
    turn_On_Action_Lock = function(p1) -- Line: 12, Name: turn_On_Action_Lock
        -- upvalues: RunService (copy), Players (copy)
        if not p1 then
            return;
        end;

        if RunService:IsClient() then
            local v2 = Players:GetPlayerFromCharacter(p1);

            if v2 then
                local LocalPlayer = Players.LocalPlayer;

                if v2 == LocalPlayer then
                    LocalPlayer:SetAttribute("SkillActionLock", true);
                end;
            else
                p1:SetAttribute("SkillActionLock", true);
            end;
        end;
    end,

    turn_Off_Action_Lock = function(p3) -- Line: 34, Name: turn_Off_Action_Lock
        -- upvalues: RunService (copy), Players (copy)
        if not p3 then
            return;
        end;

        if RunService:IsClient() then
            local v4 = Players:GetPlayerFromCharacter(p3);

            if v4 then
                local LocalPlayer = Players.LocalPlayer;

                if v4 == LocalPlayer then
                    LocalPlayer:SetAttribute("SkillActionLock", false);
                end;
            else
                p3:SetAttribute("SkillActionLock", false);
            end;
        end;
    end
};