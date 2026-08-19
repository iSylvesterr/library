-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "ThunderMutual",
        syncRadius = 300,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Thunder,
        suppressions = {
            SkillFuncCondition = "首段无条件占位，与同组轻盈/雷系组一致"
        }
    },
    Skill = {
        {
            baseSkillName = "ThunderMutual1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 20, Name: condition
                return true;
            end
        }
    }
};