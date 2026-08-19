-- Decompiled with Potassium's decompiler.

local u3 = {
    LEAP_STANDARD_TOTAL = 1.42,
    LEAP_PHASE_WINDUP = 0.5,
    LEAP_PHASE_MOVE = 0.7,
    LEAP_PHASE_RECOVERY = 0.22,
    MIN_FEASIBLE_MOVE_HORIZ = 2,

    computeMovePhaseDuration = function(p1) -- Line: 32, Name: computeMovePhaseDuration
        local v2 = math.max(p1, 2) / 120;

        return math.clamp(v2, 0.4, 0.9);
    end
};

function u3.computeFromHorizDist(p4) -- Line: 37
    -- upvalues: u3 (copy)
    local v5 = u3.computeMovePhaseDuration(p4);
    local v6 = v5 * 2.0285714285714285;
    local v7 = v6 / 1.42;

    return {
        total = v6,
        windup = 0.5 * v7,
        move = v5,
        recovery = 0.22 * v7,
        animSpeed = 1.42 / v6
    };
end;

function u3.sampleArcHeight(p8, p9) -- Line: 51
    local v10 = math.clamp(p8, 0, 1);

    if p9 <= 0 then
        return 0;
    end;

    if v10 <= 0.5 then
        local v11 = v10 / 0.5;

        return (1 - (1 - v11) * (1 - v11)) * p9;
    end;

    local v12 = (v10 - 0.5) / 0.5;

    return (1 - v12 * v12) * p9;
end;

function u3.sampleDisplacementU(p13, p14) -- Line: 66
    return p13 <= p14.windup and 0 or (p13 >= p14.windup + p14.move and 1 or math.clamp((p13 - p14.windup) / p14.move, 0, 1));
end;

function u3.maxLeapTotalDuration() -- Line: 77
    -- upvalues: u3 (copy)
    return u3.computeFromHorizDist((1 / 0)).total;
end;

function u3.minLeapTotalDuration() -- Line: 81
    -- upvalues: u3 (copy)
    return u3.computeFromHorizDist(0).total;
end;

u3.RECOVERY_FACE_ALIGNED_MIN_DOT = 0.995;
u3.RECOVERY_FACE_TRACK_RATE = 10;

function u3.isFlatLookAligned(p15, p16, p17) -- Line: 90
    -- upvalues: u3 (copy)
    local v18 = p17 or u3.RECOVERY_FACE_ALIGNED_MIN_DOT;
    local v19 = Vector3.new(p15.LookVector.X, 0, p15.LookVector.Z);
    local v20 = Vector3.new(p16.LookVector.X, 0, p16.LookVector.Z);

    return (v19.Magnitude < 0.01 or v20.Magnitude < 0.01) and true or v18 <= v19.Unit:Dot(v20.Unit);
end;

return u3;