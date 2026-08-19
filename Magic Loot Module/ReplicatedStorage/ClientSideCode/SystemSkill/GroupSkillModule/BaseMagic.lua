-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "BaseMagic",
        skillCooldown = 1,
        hitPresentationProfile = "通用受击",
        syncRadius = 120,
        obstacleRaycastMinFlightTime = 0.2,
        predictPresentation = false,
        InterruptionPriority = 1,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.None,
        suppressions = {
            SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
        }
    },
    ChainWindows = {
        Combo2 = {
            baseSkillName = "MagicMissile2",
            open = {
                state = "ProjectileFlying",
                elapsed = 0.1
            },
            close = {
                state = "Recovery",
                elapsed = 0.1
            }
        },
        Combo3 = {
            baseSkillName = "MagicMissile3",
            open = {
                state = "ProjectileFlying",
                elapsed = 0.1
            },
            close = {
                state = "Recovery",
                elapsed = 0.1
            }
        }
    },
    Skill = {
        {
            baseSkillName = "MagicMissile1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 35, Name: condition
                return true;
            end
        },
        {
            baseSkillName = "MagicMissile2",
            breakLastSkill = false,
            condition = {
                all = { {
                        type = "chain_input",
                        index = 2,
                        buffer = 0.25
                    }, {
                        type = "window",
                        name = "Combo2"
                    } }
            }
        },
        {
            baseSkillName = "MagicMissile3",
            breakLastSkill = false,
            condition = {
                all = { {
                        type = "chain_input",
                        index = 3,
                        buffer = 0.25
                    }, {
                        type = "window",
                        name = "Combo3"
                    } }
            }
        }
    }
};