-- Decompiled with Potassium's decompiler.

return {
    AssetName = "Bunny",
    Big = true,
    Huge = true,
    Pivot = Vector3.new(0, 180, 0),
    HandGrip = Vector3.new(0, 180, 0),
    Animations = {
        Idle = "Idle",
        Walk = "Walk"
    },
    WanderSpeed = 18,
    FollowSpeed = 18,
    WanderPauseMin = 2,
    WanderPauseMax = 6,
    TurnHopCountWeights = {
        [0] = 0.45,
        [1] = 0.4,
        [2] = 0.15
    },
    TurnHopDist = 1.5,
    TurnHopSpeed = 18,
    TurnHopMinGap = 0.6
};