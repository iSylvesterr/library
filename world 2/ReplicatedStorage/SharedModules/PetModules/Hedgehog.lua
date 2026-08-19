-- Decompiled with Potassium's decompiler.

return {
    AssetName = "Hedgehog",
    Big = true,
    Huge = true,
    WanderLike = "Deer",
    Pivot = Vector3.new(0, 180, 0),
    HandGrip = Vector3.new(0, 180, 0),
    Animations = {
        Idle = "Idle",
        Walk = "Walk",
        Charge = "Rolling",
        Tackle = "Tackle"
    },
    FollowSpeed = 38,
    WanderSpeed = 6,
    WanderPauseMin = 5,
    WanderPauseMax = 20,
    Behaviors = {
        HedgehogRoll = {
            CheckIntervalMin = 0.25,
            CheckIntervalMax = 0.5,
            ChancePerCheck = 1,
            AttackSpeed = 18,
            RampDuration = 6,
            MaxChaseSpeedMultiplier = 2,
            TackleRadius = 4,
            TackleRadiusBig = 6,
            TackleRadiusHuge = 8,
            StunDuration = 2,
            KnockbackForce = 30,
            KnockbackUp = 18,
            TackleAnimDuration = 0.6,
            ChaseLegTimeout = 6,
            ShovelAggroCooldown = 10,
            Cooldown = 5
        }
    }
};