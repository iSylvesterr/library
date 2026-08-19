-- Decompiled with Potassium's decompiler.

local ElementTp = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp;
local ProjectileSpellTemplate = require(script.Parent._Templates.ProjectileSpellTemplate);
local DarkBaseMagic = require(script.Parent.Parent.GroupSkillModule.DarkBaseMagic);

return ProjectileSpellTemplate.create({
    startupDuration = 0.16666666666666666,
    explodingDuration = 0.3,
    recoveryDuration = 0.2,
    visualFadeoutTime = 2,
    actionOverTime = 0.8666666666666667,
    flySpeed = 130,
    maxFlyTime = 0.45,
    bezierSeed = 20004,
    startupResName = "暗系普攻二段起手",
    explosionResName = "暗系普攻魔法弹爆炸",
    explosionLightResName = "暗系普攻爆炸灯",
    trailResName = "夜骐普攻尾迹",
    projectileResName = "暗系普攻魔法弹",
    animationName = "魔法弹2",
    animationSpeed = 1.5,
    releaseSound = "音效-夜骐普攻-法阵",
    flySound = "音效-夜骐普攻-飞行-2",
    expSound = "音效-夜骐普攻-爆炸-2",
    animationFadeTime = 0.1,
    hitbox1Size = Vector3.new(4, 4, 4),
    hitbox2Size = Vector3.new(4, 4, 4),
    hitbox2DamageRate = 1,
    skillConfSkillId = 10205001,
    refreshAimOnEnterProjectileFlying = true,
    skillElementType = ElementTp.Dark,
    trailParent = workspace.Debris,
    obstacleRaycastMinFlightTime = DarkBaseMagic.Data and DarkBaseMagic.Data.obstacleRaycastMinFlightTime or 0,
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