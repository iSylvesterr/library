-- Decompiled with Potassium's decompiler.

local ImpactContext = require(script.Parent.Parent.Parent.Parent.BaseSkill.ImpactContext);
local ImpactResolver = require(script.Parent.Parent.Parent.Parent.BaseSkill.ImpactResolver);

return {
    resolveImpact = function(p1, p2) -- Line: 36, Name: resolveImpact
        -- upvalues: ImpactContext (copy), ImpactResolver (copy)
        local v3 = ImpactContext.fromImpact(p2);

        if v3 then
            return ImpactResolver.resolveImpact(v3, p1);
        end;

        return false;
    end,

    ImpactType = {
        Enemy = "Enemy",
        Obstacle = "Obstacle",
        Timeout = "Timeout",
        Ground = "Ground",
        Shield = "Shield"
    },
    ImpactSource = {
        Hitbox = "Hitbox",
        Raycast = "Raycast",
        Lifetime = "Lifetime"
    }
};