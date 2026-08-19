-- Decompiled with Potassium's decompiler.

local ElementTp = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp;
local ProjectileSpellTemplate = require(script.Parent._Templates.ProjectileSpellTemplate);
local PoisonBaseMagic = require(script.Parent.Parent.GroupSkillModule.PoisonBaseMagic);

return ProjectileSpellTemplate.create({
    startupDuration = 0.2866666666666667,
    explodingDuration = 0.3,
    recoveryDuration = 0.2,
    visualFadeoutTime = 2,
    actionOverTime = 1.3333333333333333,
    flySpeed = 130,
    maxFlyTime = 0.5,
    bezierSeed = 30000,
    startupResName = "毒系普攻三段起手",
    explosionResName = "毒系普攻魔法弹爆炸",
    explosionLightResName = "毒系普攻爆炸灯",
    trailResName = "毒系尾迹",
    projectileResName = "毒系普攻魔法弹",
    animationName = "魔法弹3",
    animationSpeed = 1.5,
    releaseSound = "音效-毒系普攻-法阵3",
    flySound = "音效-毒系普攻-飞行3",
    expSound = "音效-毒系普攻-攻击3",
    animationFadeTime = 0.1,
    hitbox1Size = Vector3.new(4, 4, 4),
    hitbox2Size = Vector3.new(4, 4, 4),
    hitbox2DamageRate = 1,
    skillConfSkillId = 10206001,
    refreshAimOnEnterProjectileFlying = true,
    skillElementType = ElementTp.Poison,
    trailParent = workspace.Debris,
    obstacleRaycastMinFlightTime = PoisonBaseMagic.Data and PoisonBaseMagic.Data.obstacleRaycastMinFlightTime or 0,
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