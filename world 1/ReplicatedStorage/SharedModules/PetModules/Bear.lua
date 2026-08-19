-- Decompiled with Potassium's decompiler.

return {
    AssetName = "Bear",
    Big = true,
    Huge = true,
    WanderLike = "Deer",
    Pivot = Vector3.new(0, 180, 0),
    HandGrip = Vector3.new(0, 180, 0),
    Animations = {
        Idle = "Idle",
        Walk = "Walk",
        Charge = "Charge",
        Tackle = "Tackle",
        IdleAngry = "IdleAngry",
        Throw = "Throw"
    },
    FollowSpeed = 26,
    WanderSpeed = 6,
    WanderPauseMin = 5,
    WanderPauseMax = 20,
    Behaviors = {
        BearTackle = {
            CheckIntervalMin = 0.25,
            CheckIntervalMax = 0.5,
            ChancePerCheck = 1,
            AttackSpeed = 18,
            TackleRadius = 4,
            TackleRadiusBig = 6,
            TackleRadiusHuge = 8,
            HoldDuration = 2,
            TackleAnimDuration = 0.6,
            PinHeight = 0.5,
            LiftHeight = 5,
            LiftHeightBig = 9,
            LiftHeightHuge = 15,
            LiftDuration = 0.5,
            ThrowAnimDuration = 0.7,
            ThrowForce = 65,
            ThrowUp = 40,
            ChaseLegTimeout = 6,
            ShovelAggroCooldown = 10,
            Cooldown = 5
        }
    }
};