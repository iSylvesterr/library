-- Decompiled with Potassium's decompiler.

local u1 = {
    hitOncePerActivation = false,
    hitOncePerTarget = true,
    repeatHitCooldown = 0,
    canPierceEnemy = false,
    canPierceObstacle = false,
    stopOnFirstEnemy = true,
    stopOnObstacle = true,
    allowFriendlyFire = false,
    allowSelfHit = false
};
local u6 = {
    default = function() -- Line: 47, Name: default
        -- upvalues: u1 (copy)
        local v2 = {};

        for i, v in pairs(u1) do
            v2[i] = v;
        end;

        return v2;
    end,

    merge = function(p3, p4) -- Line: 61, Name: merge
        if not p4 then
            return p3;
        end;

        local v5 = {};

        for i, v in pairs(p3) do
            v5[i] = v;
        end;

        for i, v in pairs(p4) do
            if v ~= nil then
                v5[i] = v;
            end;
        end;

        return v5;
    end
};

function u6.fromHitboxEntry(p7) -- Line: 80
    -- upvalues: u6 (copy)
    local v8 = u6.default();

    if p7 then
        p7 = p7.HitPolicy;
    end;

    return u6.merge(v8, p7);
end;

return u6;