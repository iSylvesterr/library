-- Decompiled with Potassium's decompiler.

return {
    ["轻攻击震"] = {
        shakeTypeName = "Attack",
        audienceName = "Attacker",
        maxShakeCount = 1,
        shakeCooldown = 0.1,
        minDamage = 1
    },
    ["中等碰撞震"] = {
        shakeTypeName = "Clash",
        audienceName = "Attacker",
        maxShakeCount = 1,
        shakeCooldown = 0.35,
        minDamage = 1
    },
    ["大碰撞震"] = {
        shakeTypeName = "BigClash",
        audienceName = "Nearby",
        maxShakeCount = 1,
        shakeCooldown = 0.5,
        minDamage = 1,
        nearbyRadius = 120
    },
    ["长碰撞震"] = {
        shakeTypeName = "LongClash",
        audienceName = "Nearby",
        maxShakeCount = 1,
        shakeCooldown = 0.5,
        minDamage = 1,
        nearbyRadius = 120
    },
    ["魔法命中震"] = {
        shakeTypeName = "MagicHit",
        audienceName = "Victim",
        maxShakeCount = 1,
        shakeCooldown = 0.35,
        minDamage = 1
    },
    ["攻击者受击震"] = {
        shakeTypeName = "Clash",
        audienceName = "AttackerAndVictim",
        maxShakeCount = 1,
        shakeCooldown = 0.35,
        minDamage = 1
    }
};