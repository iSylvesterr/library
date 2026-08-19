-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");

return {
    fromImpact = function(p1) -- Line: 18, Name: fromImpact
        -- upvalues: Players (copy)
        if not p1 then
            return nil;
        end;

        local v2;

        if p1.target then
            local v3 = Players:GetPlayerFromCharacter(p1.target);
            v2 = v3 and v3.UserId or nil;
        else
            v2 = nil;
        end;

        return {
            shouldExplode = true,
            penetrate = false,
            ricochet = false,
            stopProjectile = true,
            hitPosition = p1.position,
            impactType = p1.type or "Timeout",
            targetId = v2,
            spawnedEffects = {},
            _normal = p1.normal,
            _target = p1.target,
            _hitResult = p1.hitResult,
            _source = p1.source
        };
    end
};