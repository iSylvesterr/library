-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u7 = {
    GetWakingDuration = function() -- Line: 23, Name: GetWakingDuration
        return 0.63;
    end,

    ResolveHitDistance = function(p1) -- Line: 27, Name: ResolveHitDistance
        -- upvalues: Asserts (copy)
        Asserts.optional.number(p1);
        local v2 = p1 or 10;
        Asserts.cond(v2 > 0);

        return v2;
    end,

    ResolveWalkSpeed = function(p3, p4, p5) -- Line: 35, Name: ResolveWalkSpeed
        -- upvalues: Asserts (copy)
        Asserts.number(p3);
        Asserts.number(p4);
        Asserts.number(p5);
        Asserts.cond(p3 > 0);
        Asserts.cond(p4 > 0);
        Asserts.cond(p5 >= 0);
        local v6 = math.max(p4, 0.001);

        if p5 <= v6 then
            return p3;
        end;

        return math.min(p3 * ((p5 / v6 - 1) * 0.5 + 1), p3 * 4);
    end
};

function u7.ResolveCatchDuration(p8, p9, p10, p11, p12) -- Line: 53
    -- upvalues: Asserts (copy), u7 (copy)
    Asserts.number(p8);
    Asserts.number(p9);
    Asserts.number(p10);
    Asserts.number(p11);
    Asserts.number(p12);
    Asserts.cond(p8 > 0);
    Asserts.cond(p9 > 0);
    Asserts.cond(p10 > 0);
    Asserts.cond(p11 >= 0);
    Asserts.cond(p12 >= 0);

    if p11 <= p10 then
        return 0;
    end;

    if u7.ResolveWalkSpeed(p8, p9, p10) <= p12 then
        return nil;
    end;

    local v13 = math.max(p9, 0.001);
    local v14 = v13 * 7;
    local v15 = 0;
    local v16 = math.max(p10, v14);

    if v16 < p11 then
        v15 = v15 + (p11 - v16) / (p8 * 4 - p12);
    end;

    local v17 = math.max(p10, v13);
    local v18 = math.min(p11, v14);

    if v17 < v18 then
        local v19 = p8 * 0.5 / v13;
        local v20 = p8 * 0.5;
        v15 = v15 + math.log((v20 + v19 * v18 - p12) / (v20 + v19 * v17 - p12)) / v19;
    end;

    local v21 = math.min(p11, v13);

    if p10 < v21 then
        v15 = v15 + (v21 - p10) / (p8 - p12);
    end;

    return v15;
end;

return u7;