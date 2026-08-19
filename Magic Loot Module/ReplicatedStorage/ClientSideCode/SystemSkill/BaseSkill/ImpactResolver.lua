-- Decompiled with Potassium's decompiler.

local SkillEventConst = require(script.Parent.SkillEventConst);
local u1 = {
    Enemy = SkillEventConst.EnemyHit,
    Obstacle = SkillEventConst.ObstacleHit,
    Timeout = SkillEventConst.Timeout,
    Ground = SkillEventConst.ObstacleHit,
    Shield = SkillEventConst.ObstacleHit
};

return {
    resolveImpact = function(p2, p3) -- Line: 26, Name: resolveImpact
        -- upvalues: u1 (copy), SkillEventConst (copy)
        if not (p2 and p3) then
            return false;
        end;

        local skillRunData = p3.skillRunData;

        if not (skillRunData and skillRunData.Logic) then
            return false;
        end;

        if skillRunData.Logic.hasExploded then
            return false;
        end;

        if skillRunData.State.current ~= "ProjectileFlying" then
            return false;
        end;

        skillRunData.Logic.hasExploded = true;
        skillRunData.Logic.impactPosition = p2.hitPosition;
        skillRunData.Logic.impactType = p2.impactType;
        skillRunData.Logic.impactTargetId = p2.targetId;
        local v4 = u1[p2.impactType] or SkillEventConst.Timeout;
        local v5 = {
            hitPosition = p2.hitPosition,
            hitType = p2.impactType,
            targetId = p2.targetId
        };
        local skillModule = p3.skillModule;

        if skillModule and type(skillModule.onProjectileImpact) == "function" then
            skillModule.onProjectileImpact(p3, p2);
        end;

        p3:TryTransition(v4, v5);

        return true;
    end
};