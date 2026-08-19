-- Decompiled with Potassium's decompiler.

return {
    AssetName = "IceSerpent",
    Big = true,
    Huge = true,
    Pivot = Vector3.new(0, 90, 0),
    HandGrip = Vector3.new(0, 270, 0),
    IsFlying = true,
    AlwaysFlying = true,
    AirHeight = 6,
    FollowAirHeight = 3,
    FollowDistanceMult = 1.5,
    BigFollowDistanceMult = 2.2,
    HugeFollowDistanceMult = 2.5,
    BigScale = 1.6,
    HugeScale = 3.2,
    Animations = {
        Fly = "Fly",
        FlyIdle = "FlyIdle",
        Breathe = "Breathe"
    },
    WanderSpeed = 9,
    WanderPauseMin = 0.6,
    WanderPauseMax = 1.4,
    WanderWaypointCountMin = 3,
    WanderWaypointCountMax = 5,
    WanderMinSegmentLength = 10,
    WanderMaxTurnAngleDeg = 70,
    WanderHeightJitter = 2,
    FullOrientation = true,
    NeverPerch = true,
    EatChancePerSecond = 0,
    OrbitChancePerSecond = 0,
    Behaviors = {
        IceSerpentDefend = {
            CheckIntervalMin = 0.25,
            CheckIntervalMax = 0.5,
            ChancePerCheck = 1,
            Cooldown = 0,
            ApproachSpeed = 22,
            BreathDuration = 1.5,
            BreathCooldown = 8,
            ApproachLegTimeout = 8
        }
    }
};