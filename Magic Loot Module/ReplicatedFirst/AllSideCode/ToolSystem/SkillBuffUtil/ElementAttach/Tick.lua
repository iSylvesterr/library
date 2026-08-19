-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local EnumMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr;
local Config = require(script.Parent.Parent.Config);
local SkillDot = require(script.Parent.Parent.Dot.SkillDot);
local Registry = require(script.Parent.Registry);

return {
    run = function(p1) -- Line: 21, Name: run
        -- upvalues: Registry (copy), EnumMgr (copy), Players (copy), Config (copy), SkillDot (copy)
        local v2 = Registry.getEntries();
        local Dot = EnumMgr.ElementTraitKind.Dot;

        for i = #v2, 1, -1 do
            local v3 = v2[i];

            if v3.traitKind == Dot then
                local owner = v3.owner;

                if owner:IsA("Model") and owner.Parent then
                    if p1 < v3.endAt then
                        local v4 = Players:GetPlayerByUserId(v3.casterUserId or 0);

                        if v4 and v4.Parent then
                            local nextTickAt = v3.nextTickAt;
                            local tickInterval = v3.tickInterval;

                            if nextTickAt and (tickInterval and tickInterval > 0) then
                                local v5 = Config.getPrimaryScalarFromBuffInst(v3.buffInstId);

                                if v5 and (v5 > 0 and v5 == v5) then
                                    local v6 = 0;

                                    while nextTickAt <= p1 and (nextTickAt <= v3.endAt and v6 < 1) do
                                        local v7 = v3.tier * v5;

                                        if v7 > 0 and v7 == v7 then
                                            SkillDot.applyTick(owner, v4, v3.elementTp, v7, v3.casterUserId, v3.playDotHit == true);
                                        end;

                                        nextTickAt = p1 + tickInterval;
                                        v6 = v6 + 1;
                                    end;

                                    v3.nextTickAt = nextTickAt;
                                end;
                            end;
                        else
                            Registry.removeAtIndex(i);
                        end;
                    end;
                else
                    Registry.removeAtIndex(i);
                end;
            end;
        end;
    end
};