-- Decompiled with Potassium's decompiler.

local ElementTp = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp;
local ProjectileSpellTemplate = require(script.Parent._Templates.ProjectileSpellTemplate);
local FireBaseMagic = require(script.Parent.Parent.GroupSkillModule.FireBaseMagic);

return ProjectileSpellTemplate.create({
    impactNextState = "Exploding",
    startupDuration = 0.16666666666666669,
    explodingDuration = 0.3,
    recoveryDuration = 0.2,
    visualFadeoutTime = 2,
    actionOverTime = 1.1666666666666667,
    flySpeed = 200,
    maxFlyTime = 0.5,
    minTrackedMoveTime = 0.03,
    bezierSeed = 10000,
    startupResName = "火系普攻一段起手",
    explosionResName = "火系普攻爆炸",
    explosionLightResName = "火系普攻爆炸灯",
    trailResName = "火系普攻魔杖尾迹",
    projectileResName = "火系普攻魔法弹",
    animationName = "魔法弹1",
    animationSpeed = 1.2,
    releaseSound = "玩家普攻-施法1",
    flySound = "玩家普攻-飞行1",
    expSound = "玩家普攻-爆炸1",
    animationFadeTime = 0.1,
    hitbox1Size = Vector3.new(4, 4, 4),
    hitbox2Size = Vector3.new(4, 4, 4),
    hitbox2DamageRate = 1,
    skillConfSkillId = 10207001,
    refreshAimOnEnterProjectileFlying = true,
    skillElementType = ElementTp.Fire,
    trailParent = workspace.Debris,
    obstacleRaycastMinFlightTime = FireBaseMagic.Data and FireBaseMagic.Data.obstacleRaycastMinFlightTime or 0,
    hitboxConfig = { {
            HitboxIndex = 2,
            HitPolicy = {
                hitOncePerTarget = true,
                hitOncePerActivation = true
            }
        } },
    tracking = {
        enabled = true,
        objectValueName = "NowTargetCurrent",
        curveRefreshInterval = 0,
        middlePointCount = 8,
        objectValuePathSegments = {}
    }
});