-- Decompiled with Potassium's decompiler.

local u1 = {
    Strategies = {
        RetreatFromTarget = {
            id = "RetreatFromTarget",
            triggerDistLt = 30,
            minDistAfter = 50,
            faceMode = "AttackTarget",
            wallBackoffFallback = 3,
            minFeasibleMoveHoriz = 2,
            probeUpStuds = 50,
            probeDownStuds = 100,
            maxDropBelowStartStuds = 30
        },
        ApproachSpawnGround = {
            id = "ApproachSpawnGround",
            skipMoveDistLt = 30,
            faceMode = "MoveTarget",
            wallBackoffFallback = 3,
            minFeasibleMoveHoriz = 2,
            probeUpStuds = 50,
            probeDownStuds = 100,
            maxDropBelowStartStuds = 30
        },
        ApproachMultThunderStart = {
            id = "ApproachMultThunderStart",
            skipMoveDistLt = 30,
            faceMode = "MoveTarget",
            wallBackoffFallback = 3,
            minFeasibleMoveHoriz = 2,
            probeUpStuds = 50,
            probeDownStuds = 100,
            maxDropBelowStartStuds = 30
        }
    }
};

function u1.get(p2) -- Line: 66
    -- upvalues: u1 (copy)
    if type(p2) == "string" and p2 ~= "" then
        return u1.Strategies[p2];
    end;

    return nil;
end;

return u1;