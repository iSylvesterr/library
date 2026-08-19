-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "LightSword",
        skillCooldown = 1,
        syncRadius = 120,
        Recovery = 0.5,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Light,
        suppressions = {
            SkillFuncCondition = "单段即时施法，首段无条件；由 RP15 Saber 迁出，无连招窗口"
        }
    },
    Skill = {
        {
            baseSkillName = "LightSword1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 24, Name: condition
                return true;
            end
        }
    }
};