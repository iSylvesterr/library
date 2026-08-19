-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {
    Temp = {
        MaxSize = Vector3.new(9, 9, 9),
        MinSize = Vector3.new(0.7, 0.7, 0.7),
        RiseStoneSizeRandomRange = Vector3.new(0, 0, 0),
        ShockLenth = 30,
        StoneNum = 8,
        RiseTime = 0.2,
        WholeTime = 0.2,
        RiseStoneLifeTime = 2,
        RiseStoneDisapearTime = 1,
        FlyMaxSize = Vector3.new(3, 3, 3),
        FlyMinSize = Vector3.new(2, 2, 2),
        FlyStoneLifeTime = 3,
        FlyStoneForce = 160,
        FlyStoneForceRandomRange = 60,
        FlyStoneProbability = 1,
        RiseStoneDisapearStyle = Enum.EasingStyle.Linear,
        RiseStoneDisapearDir = Enum.EasingDirection.In,
        RiseStoneSpawnCFrameOffset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0)
    },
    ["单条向左偏移石块"] = {
        MaxSize = Vector3.new(4, 4, 4),
        MinSize = Vector3.new(1.5, 1.5, 1.5),
        RiseStoneSizeRandomRange = Vector3.new(1, 1, 1),
        ShockLenth = 100,
        StoneNum = 28,
        RiseTime = 0.3,
        WholeTime = 2.8,
        RiseStoneLifeTime = 2.5,
        RiseStoneDisapearTime = 1,
        RiseStoneOrientationRange = Vector3.new(360, 360, 360),
        FlyMaxSize = Vector3.new(3, 3, 3),
        FlyMinSize = Vector3.new(0.5, 0.5, 0.5),
        FlyStoneLifeTime = 2,
        FlyStoneForce = 250,
        FlyStoneForceRandomRange = 10,
        FlyStoneProbability = 0.5,
        RiseStonePoseOffsetRange = CFrame.new(0.5, 0.5, 0.5),
        RiseStoneDisapearStyle = Enum.EasingStyle.Sine,
        RiseStoneDisapearDir = Enum.EasingDirection.Out,
        RiseStoneSpawnCFrameOffset = CFrame.new(2, 0, 0) * CFrame.Angles(0, -0.05235987755982989, 0)
    },
    ["单条向右偏移石块"] = {
        MaxSize = Vector3.new(4, 4, 4),
        MinSize = Vector3.new(1.5, 1.5, 1.5),
        RiseStoneSizeRandomRange = Vector3.new(1, 1, 1),
        ShockLenth = 100,
        StoneNum = 28,
        RiseTime = 0.3,
        WholeTime = 2.8,
        RiseStoneLifeTime = 2.5,
        RiseStoneDisapearTime = 1,
        RiseStoneOrientationRange = Vector3.new(360, 360, 360),
        FlyMaxSize = Vector3.new(3, 3, 3),
        FlyMinSize = Vector3.new(0.5, 0.5, 0.5),
        FlyStoneLifeTime = 2,
        FlyStoneForce = 250,
        FlyStoneForceRandomRange = 10,
        FlyStoneProbability = 0.5,
        RiseStonePoseOffsetRange = CFrame.new(0.5, 0.5, 0.5),
        RiseStoneDisapearStyle = Enum.EasingStyle.Sine,
        RiseStoneDisapearDir = Enum.EasingDirection.Out,
        RiseStoneSpawnCFrameOffset = CFrame.new(-2, 0, 0) * CFrame.Angles(0, 0.05235987755982989, 0)
    }
};
local v3 = {
    Temp = { {
            MinSize = Vector3.new(3, 3, 3),
            MaxSize = Vector3.new(4, 4, 4),
            SpawnOffset = Vector3.new(8, 1, 8),
            Force = 480,
            ForceOffset = 40,
            StoneNum = 10,
            StayTime = 3,
            CanCollide = true
        }, {
            MinSize = Vector3.new(2, 2, 2),
            MaxSize = Vector3.new(3, 3, 3),
            SpawnOffset = Vector3.new(16, 1, 16),
            Force = 420,
            ForceOffset = 40,
            StoneNum = 10,
            StayTime = 2.5,
            CanCollide = true
        }, {
            MinSize = Vector3.new(1, 1, 1),
            MaxSize = Vector3.new(2, 2, 2),
            SpawnOffset = Vector3.new(25, 1, 25),
            Force = 340,
            ForceOffset = 30,
            StoneNum = 20,
            StayTime = 2,
            CanCollide = true
        } },
    Meteor = {
        {
            MinSize = Vector3.new(1, 1, 1),
            MaxSize = Vector3.new(5, 5, 5),
            SpawnOffset = Vector3.new(1, 1, 1),
            DirectionOffset = Vector3.new(0.5, 0, 0.5),
            Force = 200,
            ForceOffset = 40,
            StoneNum = 7,
            StayTime = 3,
            CanCollide = false,
            OrientationOffsetRange = CFrame.Angles(3.141592653589793, 3.141592653589793, 3.141592653589793)
        }
    },
    HanamiWoodMeteor = {
        {
            MinSize = Vector3.new(0.45, 0.45, 0.45),
            MaxSize = Vector3.new(2.2, 2.2, 2.2),
            SpawnOffset = Vector3.new(0.9, 0.9, 0.9),
            DirectionOffset = Vector3.new(0.5, 0, 0.5),
            Force = 200,
            ForceOffset = 40,
            StoneNum = 14,
            StayTime = 3,
            CanCollide = false,
            OrientationOffsetRange = CFrame.Angles(3.141592653589793, 3.141592653589793, 3.141592653589793)
        }
    },
    DinoTrampleFly = {
        {
            MinSize = Vector3.new(0.8, 0.8, 0.8),
            MaxSize = Vector3.new(2.5, 2.5, 2.5),
            SpawnOffset = Vector3.new(2.5, 1, 2.5),
            DirectionOffset = Vector3.new(0.5, 0, 0.5),
            Force = 180,
            ForceOffset = 40,
            StoneNum = 5,
            StayTime = 2.5,
            CanCollide = false,
            OrientationOffsetRange = CFrame.Angles(3.141592653589793, 3.141592653589793, 3.141592653589793)
        }
    },
    DinoBiteFly = {
        {
            MinSize = Vector3.new(0.8, 0.8, 0.8),
            MaxSize = Vector3.new(2.4, 2.4, 2.4),
            SpawnOffset = Vector3.new(2.2, 1, 2.2),
            DirectionOffset = Vector3.new(0.5, 0, 0.5),
            Force = 180,
            ForceOffset = 40,
            StoneNum = 6,
            StayTime = 2.2,
            CanCollide = false,
            OrientationOffsetRange = CFrame.Angles(3.141592653589793, 3.141592653589793, 3.141592653589793)
        }
    },
    ["两圈石头飞起"] = { {
            MinSize = Vector3.new(2.5, 2.5, 2.5),
            MaxSize = Vector3.new(3.3, 3.3, 3.3),
            SpawnOffset = Vector3.new(5, 1, 5),
            Force = 250,
            ForceOffset = 40,
            StoneNum = 2,
            StayTime = 3,
            CanCollide = true
        }, {
            MinSize = Vector3.new(1, 1, 1),
            MaxSize = Vector3.new(2.5, 2.5, 2.5),
            SpawnOffset = Vector3.new(9, 1, 9),
            Force = 350,
            ForceOffset = 40,
            StoneNum = 7,
            StayTime = 2.5,
            CanCollide = true
        } }
};
v1.OneSideShockWaveInfo = v2;
v1.stoneFlyInfo = v3;
v1.landBreakInfo = {
    Temp = {
        {
            MinSize = Vector3.new(5, 2, 5),
            MaxSize = Vector3.new(7, 3, 7),
            PositionOffset = Vector3.new(0, -0.8, -9),
            PositionRamdomOffset = Vector3.new(0.5, 0, 0.5),
            AngleOffset = Vector3.new(0.10471976, 0, 0),
            AngleRandomOffset = Vector3.new(0.034906585, 0.08726646, 0.08726646),
            OriAngle = 0,
            StoneNum = 5,
            Delay = 0,
            LifeTime = 2
        },
        {
            MinSize = Vector3.new(6, 2, 6),
            MaxSize = Vector3.new(7, 3, 7),
            PositionOffset = Vector3.new(0, -1.5, -18),
            PositionRamdomOffset = Vector3.new(1, 0, 1.5),
            AngleOffset = Vector3.new(0.2617994, 0, 0),
            AngleRandomOffset = Vector3.new(0.05235988, 0.08726646, 0.08726646),
            OriAngle = 0,
            StoneNum = 9,
            Delay = 0.03,
            LifeTime = 2
        },
        {
            MinSize = Vector3.new(7, 1.5, 6),
            MaxSize = Vector3.new(9, 2.5, 9),
            PositionOffset = Vector3.new(0, -1.5, -28),
            PositionRamdomOffset = Vector3.new(3, 0.5, 3),
            AngleOffset = Vector3.new(0.34906584, 0, 0),
            AngleRandomOffset = Vector3.new(0.05235988, 0.08726646, 0.08726646),
            OriAngle = 0,
            StoneNum = 12,
            Delay = 0.05,
            LifeTime = 2
        }
    },
    Meteor = { {
            MinSize = Vector3.new(2, 2, 2),
            MaxSize = Vector3.new(3, 3, 3),
            PositionOffset = Vector3.new(0, -0.8, -18),
            PositionRamdomOffset = Vector3.new(2, 2, 2),
            AngleOffset = Vector3.new(0, 0, 0),
            AngleRandomOffset = Vector3.new(3.1415927, 3.1415927, 3.1415927),
            OriAngle = 0,
            StoneNum = 24,
            Delay = 0,
            LifeTime = 2
        } },
    LavaBall = { {
            MinSize = Vector3.new(2, 2, 2),
            MaxSize = Vector3.new(3, 3, 3),
            PositionOffset = Vector3.new(0, -0.8, -18),
            PositionRamdomOffset = Vector3.new(2, 2, 2),
            AngleOffset = Vector3.new(0, 0, 0),
            AngleRandomOffset = Vector3.new(3.1415927, 3.1415927, 3.1415927),
            OriAngle = 0,
            StoneNum = 12,
            Delay = 0,
            LifeTime = 2
        } },
    MeteorEnwind = { {
            MinSize = Vector3.new(2, 2, 2),
            MaxSize = Vector3.new(3, 3, 3),
            PositionOffset = Vector3.new(0, -0.8, -18),
            PositionRamdomOffset = Vector3.new(2, 2, 2),
            AngleOffset = Vector3.new(0, 0, 0),
            AngleRandomOffset = Vector3.new(3.1415927, 3.1415927, 3.1415927),
            OriAngle = 0,
            StoneNum = 24,
            Delay = 0,
            LifeTime = 3.1
        } },
    HanamiWoodMeteorEnwind = { {
            MinSize = Vector3.new(1.05, 1.05, 1.05),
            MaxSize = Vector3.new(1.85, 1.85, 1.85),
            PositionOffset = Vector3.new(0, -0.8, -18),
            PositionRamdomOffset = Vector3.new(1.55, 1.55, 1.55),
            AngleOffset = Vector3.new(0, 0, 0),
            AngleRandomOffset = Vector3.new(3.1415927, 3.1415927, 3.1415927),
            OriAngle = 0,
            StoneNum = 38,
            Delay = 0,
            LifeTime = 3.1
        } },
    HitLand1 = { {
            MinSize = Vector3.new(4.5, 3, 1.5),
            MaxSize = Vector3.new(6, 3, 2.5),
            PositionOffset = Vector3.new(0, -0.8, -30),
            PositionRamdomOffset = Vector3.new(0.5, 0, 0.5),
            AngleOffset = Vector3.new(0.5235988, 0.10471976, 0),
            AngleRandomOffset = Vector3.new(0.034906585, 0.08726646, 0.08726646),
            OriAngle = 0,
            StoneNum = 12,
            Delay = 0.03,
            LifeTime = 3.5,
            ScaleOutTime = 2.5
        } },
    HitLand2 = { {
            MinSize = Vector3.new(6, 3, 3),
            MaxSize = Vector3.new(7, 3, 4),
            PositionOffset = Vector3.new(0, -1.5, -40),
            PositionRamdomOffset = Vector3.new(1, 0, 1.5),
            AngleOffset = Vector3.new(0.43633232, 0.10471976, 0),
            AngleRandomOffset = Vector3.new(0.05235988, 0.08726646, 0.08726646),
            OriAngle = 0,
            StoneNum = 14,
            Delay = 0.03,
            LifeTime = 3.5,
            ScaleOutTime = 3
        } },
    HitLand3 = { {
            MinSize = Vector3.new(8, 4, 4),
            MaxSize = Vector3.new(10, 4, 5),
            PositionOffset = Vector3.new(0, -2.5, -55),
            PositionRamdomOffset = Vector3.new(1, 0, 1.5),
            AngleOffset = Vector3.new(0.34906584, 0.10471976, 0),
            AngleRandomOffset = Vector3.new(0.05235988, 0.08726646, 0.08726646),
            OriAngle = 0,
            StoneNum = 18,
            Delay = 0.03,
            LifeTime = 3.5,
            ScaleOutTime = 3
        } },
    SmallHitLand1 = { {
            MinSize = Vector3.new(3.5, 3, 1.5),
            MaxSize = Vector3.new(5, 3, 2.5),
            PositionOffset = Vector3.new(0, -0.8, -10),
            PositionRamdomOffset = Vector3.new(0.5, 0, 0.5),
            AngleOffset = Vector3.new(0.34906584, 0.10471976, 0),
            AngleRandomOffset = Vector3.new(0.034906585, 0.08726646, 0.08726646),
            OriAngle = 0,
            StoneNum = 6,
            Delay = 0.03,
            LifeTime = 3.5,
            ScaleOutTime = 2.5
        } },
    DinoTrample = { {
            MinSize = Vector3.new(2.2, 2.2, 2.2),
            MaxSize = Vector3.new(3.4, 3.4, 3.4),
            PositionOffset = Vector3.new(0, -0.8, -24),
            PositionRamdomOffset = Vector3.new(2.5, 1.5, 2.5),
            AngleOffset = Vector3.new(0, 0, 0),
            AngleRandomOffset = Vector3.new(3.1415927, 3.1415927, 3.1415927),
            OriAngle = 0,
            StoneNum = 8,
            Delay = 0,
            LifeTime = 2.5
        } },
    DinoBite = { {
            MinSize = Vector3.new(2, 2, 2),
            MaxSize = Vector3.new(3.2, 3.2, 3.2),
            PositionOffset = Vector3.new(0, -0.8, -24),
            PositionRamdomOffset = Vector3.new(2.2, 1.2, 2.2),
            AngleOffset = Vector3.new(0, 0, 0),
            AngleRandomOffset = Vector3.new(3.1415927, 3.1415927, 3.1415927),
            OriAngle = 0,
            StoneNum = 8,
            Delay = 0,
            LifeTime = 1.583
        } }
};

return v1;