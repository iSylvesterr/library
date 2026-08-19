-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local ProjectileSpellTemplate = require(script.Parent._Templates.ProjectileSpellTemplate);
local BaseMagic = require(script.Parent.Parent.GroupSkillModule.BaseMagic);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local v1 = UtilsSystem.SystemGameConfig.Get();

if v1 then
    v1 = v1["技能系统"];
end;

if v1 then
    v1 = v1["默认普攻技能ID"];
end;

local v2 = nil;

if type(v1) == "number" then
    if v1 <= 0 then
        v1 = v2;
    end;
else
    v1 = v2;
end;

return ProjectileSpellTemplate.create({
    impactNextState = "Exploding",
    startupDuration = 0.75,
    explodingDuration = 0.3,
    recoveryDuration = 0.2,
    visualFadeoutTime = 2,
    actionOverTime = 1.1,
    flySpeed = 60,
    maxFlyTime = 1,
    bezierSeed = 10000,
    startupResName = "火焰普攻一段起手",
    explosionResName = "火焰普攻爆炸",
    explosionLightResName = "普攻爆炸灯",
    trailResName = "火焰普攻魔杖尾迹",
    projectileResName = "火焰普攻魔法弹",
    animationName = "魔法弹1-慢",
    releaseSound = "玩家普攻-施法1",
    flySound = "玩家普攻-飞行1",
    expSound = "玩家普攻-爆炸1",
    explosionVisualYOffset = 3,
    animationFadeTime = 0.1,
    hitbox1Size = Vector3.new(2, 2, 2),
    hitbox2Size = Vector3.new(3, 3, 3),
    hitbox2DamageRate = 1,
    skillElementType = ElementTp.Fire,
    skillConfSkillId = v1,
    trailParent = workspace.Debris,
    obstacleRaycastMinFlightTime = BaseMagic.Data and BaseMagic.Data.obstacleRaycastMinFlightTime or 0,
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
        middlePointCount = 4,
        objectValuePathSegments = {}
    },
    telegraph = {
        enabled = true,
        lockAtStartupElapsed = 0.4
    }
});