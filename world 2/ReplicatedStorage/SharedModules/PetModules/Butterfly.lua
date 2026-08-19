-- Decompiled with Potassium's decompiler.

return {
    AssetName = "Butterfly",
    Big = true,
    Huge = true,
    Pivot = Vector3.new(-90, 180, 0),
    HandGrip = Vector3.new(0, 0, 0),
    IsFlying = true,
    AirHeight = 6,
    FollowAirHeight = 3,
    PerchHoverHeight = 3,
    LandDelay = 1,
    LandDuration = 0.8,
    TakeoffDuration = 0.8,
    Animations = {
        Fly = "Fly",
        Land = "Land",
        GroundIdle = "GroundIdle"
    },
    HeldAnimation = "GroundIdle",
    WanderSpeed = 9,
    WanderPauseMin = 0.6,
    WanderPauseMax = 1.4,
    WanderWaypointCountMin = 3,
    WanderWaypointCountMax = 5,
    WanderMinSegmentLength = 10,
    WanderMaxTurnAngleDeg = 70,
    WanderHeightJitter = 2,
    PerchIntervalMin = 20,
    PerchIntervalMax = 30,
    PerchDurationMin = 5,
    PerchDurationMax = 8,
    PerchHopIntervalMin = 99999,
    PerchHopIntervalMax = 99999,
    EatChancePerSecond = 0,
    OrbitChancePerSecond = 0
};