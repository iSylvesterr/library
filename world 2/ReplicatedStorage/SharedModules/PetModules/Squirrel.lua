-- Decompiled with Potassium's decompiler.

return {
    AssetName = "Squirrel",
    Big = true,
    Huge = true,
    Pivot = Vector3.new(0, 270, 0),
    HandGrip = Vector3.new(0, 90, 0),
    Animations = {
        Idle = "Idle",
        Walk = "Walk"
    },
    WanderSpeed = 18,
    FollowSpeed = 18,
    WanderPauseMin = 0.6,
    WanderPauseMax = 1.4,
    Behaviors = {
        PickFruit = {
            CheckIntervalMin = 1,
            CheckIntervalMax = 1,
            ChancePerCheck = 0.01,
            Cooldown = 0,
            TravelSpeed = 20,
            LegTimeout = 20,
            PickDuration = 1,
            DeliveryRadius = 3.5
        }
    }
};