-- Decompiled with Potassium's decompiler.

return {
    ACTIVITY_GRACE_SECONDS = 300,
    ACTIVITY_DECAY_SECONDS = 600,
    ACTIVITY_MIN_MULTIPLIER = 0.1,

    activityMultiplier = function(p1) -- Line: 5, Name: activityMultiplier
        return p1 <= 300 and 1 or 1 - math.min((p1 - 300) / 600, 1) * 0.9;
    end
};