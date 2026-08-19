-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Registry = require(script.Parent.Registry);
local SkillDot = require(script.Parent.SkillDot);
local EnvDot = require(script.Parent.EnvDot);
local Util = require(script.Parent.Util);

return {
    run = function(p1) -- Line: 18, Name: run
        -- upvalues: Registry (copy), Players (copy), EnvDot (copy), Util (copy), SkillDot (copy)
        local v2 = Registry.getEntries();

        for i = #v2, 1, -1 do
            local v3 = v2[i];
            local defender = v3.defender;

            if defender.Parent then
                local v4 = defender:GetAttribute(v3.genKey);

                if type(v4) == "number" and v4 == v3.myGen then
                    local v5 = false;
                    local v6;

                    if v3.isEnvHazard == true then
                        local v7 = Players:GetPlayerFromCharacter(defender);

                        if v7 and defender == v7.Character then
                            local v8 = defender:FindFirstChildOfClass("Humanoid");
                            v6 = (not v8 or v8.Health <= 0) and true or v5;
                        else
                            v6 = true;
                        end;
                    else
                        local v9 = Players:GetPlayerByUserId(v3.casterUserId);
                        v6 = not (v9 and v9.Parent) and true or v5;
                    end;

                    if v6 then
                        Registry.removeAtIndex(i);
                    else
                        local v10 = Players:GetPlayerByUserId(v3.casterUserId);

                        if v3.isEnvHazard == true then
                            if v3.nextTickAt <= p1 and p1 < v3.endAt then
                                EnvDot.applyTick(defender, v3.eleTp, v3.coeff, v3.interval, v3.playDotHit == true);
                                v3.nextTickAt = v3.nextTickAt + v3.interval;
                            end;
                        else
                            local v11 = 0;

                            while v3.nextTickAt <= p1 and (v3.nextTickAt <= v3.endAt and v11 < Util.SKILL_DOT_MAX_CATCHUP) do
                                SkillDot.applyTick(defender, v10, v3.eleTp, v3.coeff, v3.casterUserId, v3.playDotHit == true);
                                v3.nextTickAt = v3.nextTickAt + v3.interval;
                                v11 = v11 + 1;
                            end;

                            if Util.SKILL_DOT_MAX_CATCHUP <= v11 and (v3.nextTickAt <= p1 and v3.nextTickAt <= v3.endAt) then
                                v3.nextTickAt = p1 + v3.interval;
                            end;
                        end;
                    end;
                else
                    Registry.removeAtIndex(i);
                end;

                if v2[i] == v3 and v3.endAt <= p1 then
                    Registry.removeAtIndex(i);
                end;
            else
                Registry.removeAtIndex(i);
            end;
        end;
    end
};