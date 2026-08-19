-- Decompiled with Potassium's decompiler.

return {
    AssetName = "Fox",
    Big = true,
    Huge = true,
    Pivot = Vector3.new(0, 180, 0),
    HandGrip = Vector3.new(0, 180, 0),
    Animations = {
        Idle = "Idle",
        Walk = "Walk"
    },
    WanderSpeed = 8,
    WanderPauseMin = 0.6,
    WanderPauseMax = 1.4,
    Behaviors = {
        StealSeed = {
            CheckIntervalMin = 5,
            CheckIntervalMax = 10,
            ChancePerCheck = 0.85,
            Cooldown = 10,
            NoOpCooldown = 3,
            TravelSpeed = 20,
            LegTimeout = 20,
            StealDuration = 3,
            DeliveryRadius = 8
        }
    }
};