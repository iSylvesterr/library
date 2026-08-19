-- Decompiled with Potassium's decompiler.

return {
    AssetName = "Dog",
    Big = true,
    Huge = true,
    WanderLike = "Dog",
    Pivot = Vector3.new(0, 180, 0),
    HandGrip = Vector3.new(0, 180, 0),
    Animations = {
        Idle = "Idle",
        Walk = "Walk",
        Bite = "Bite",
        Dig = "Dig"
    },
    FollowSpeed = 29.9,
    WanderSpeed = 6.9,
    WanderPauseMin = 5,
    WanderPauseMax = 20,
    DigWaitBefore = 1,
    DigToCrateDelay = 1,
    CrateFindDebounce = 5,
    CrateFrontDistance = 3,
    SizeCrateFrontDistance = {
        Big = 5,
        Huge = 9
    },
    Behaviors = {
        DogBite = {
            CheckIntervalMin = 0.25,
            CheckIntervalMax = 0.5,
            ChancePerCheck = 1,
            AttackSpeed = 20.7,
            ChaseSpeedMultiplier = 1.3,
            BiteRadius = 4,
            BiteRadiusBig = 6,
            BiteRadiusHuge = 8,
            BiteAnimDuration = 0.5,
            BiteHoldDuration = 1,
            StunDuration = 2,
            ChaseLegTimeout = 6,
            Cooldown = 5
        }
    }
};