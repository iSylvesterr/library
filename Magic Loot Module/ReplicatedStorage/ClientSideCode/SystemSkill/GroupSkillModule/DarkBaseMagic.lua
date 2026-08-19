-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "DarkBaseMagic",
        skillCooldown = 1,
        syncRadius = 120,
        obstacleRaycastMinFlightTime = 0.2,
        predictPresentation = false,
        InterruptionPriority = 1,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Dark,
        suppressions = {
            SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
        }
    },
    ChainWindows = {
        Combo2 = {
            baseSkillName = "DarkMagicMissile2",
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
            baseSkillName = "DarkMagicMissile3",
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
            baseSkillName = "DarkMagicMissile1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 32, Name: condition
                return true;
            end
        },
        {
            baseSkillName = "DarkMagicMissile2",
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
            baseSkillName = "DarkMagicMissile3",
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