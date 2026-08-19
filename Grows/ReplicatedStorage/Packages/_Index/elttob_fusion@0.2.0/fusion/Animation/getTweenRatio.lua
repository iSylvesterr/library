-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");

return function(p1, p2) -- Line: 10, Name: getTweenRatio
    -- upvalues: TweenService (copy)
    local DelayTime = p1.DelayTime;
    local Time = p1.Time;
    local v3 = DelayTime + Time;

    if p1.Reverses then
        v3 = v3 + Time;
    end;

    if v3 * (1 + p1.RepeatCount) <= p2 then
        return 1;
    end;

    local v4 = p2 % v3;

    if v4 <= DelayTime then
        return 0;
    end;

    local v5 = (v4 - DelayTime) / Time;

    if v5 > 1 then
        v5 = 2 - v5;
    end;

    return TweenService:GetValue(v5, p1.EasingStyle, p1.EasingDirection);
end;