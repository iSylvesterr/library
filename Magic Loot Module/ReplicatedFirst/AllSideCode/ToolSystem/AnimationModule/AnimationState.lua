-- Decompiled with Potassium's decompiler.

local u1 = {
    animationTrackCache = {},
    animatorDestroyConnections = {},
    animationMarkerConnections = {},
    animationTimeUpdateConnections = {},
    animationOriginalSpeedCache = {},
    animationEndConnections = {}
};

function u1.CleanupAnimator(p2) -- Line: 28
    -- upvalues: u1 (copy)
    local v3 = u1.animatorDestroyConnections[p2];

    if v3 then
        v3:Disconnect();
        u1.animatorDestroyConnections[p2] = nil;
    end;

    local v4 = u1.animationTrackCache[p2];

    if v4 then
        for _, v in pairs(v4) do
            v:Stop();
            v:Destroy();
        end;

        u1.animationTrackCache[p2] = nil;
    end;

    u1.animationMarkerConnections[p2] = nil;
    local v5 = u1.animationTimeUpdateConnections[p2];

    if v5 then
        for _, v in pairs(v5) do
            v:Disconnect();
        end;

        u1.animationTimeUpdateConnections[p2] = nil;
    end;

    u1.animationOriginalSpeedCache[p2] = nil;
    local v6 = u1.animationEndConnections[p2];

    if v6 then
        for _, v in pairs(v6) do
            v:Disconnect();
        end;

        u1.animationEndConnections[p2] = nil;
    end;
end;

return u1;