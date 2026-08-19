-- Decompiled with Potassium's decompiler.

return {
    AssetName = "Turkey",
    Big = true,
    Huge = true,
    WanderLike = "Turkey",
    Pivot = Vector3.new(0, 180, 0),
    HandGrip = Vector3.new(0, 180, 0),
    Animations = {
        Idle = "Idle",
        Walk = "Walk",
        Peck = "Pecking"
    },
    FollowSpeed = 26,
    WanderSpeed = 6,
    WanderPauseMin = 5,
    WanderPauseMax = 20,
    SeedChancePerSecond = 0.01,
    PeckWaitBefore = 1,
    PeckToSeedDelay = 1,
    SeedFindDebounce = 5,
    SeedFrontDistance = 3,
    SizeSeedFrontDistance = {
        Big = 5,
        Huge = 9
    }
};