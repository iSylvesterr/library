-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "DinoTrample",
        syncRadius = 150,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Earth,
        suppressions = {
            SkillFuncCondition = "首段无条件，function 占位与项目他组技能一致"
        }
    },
    Skill = {
        {
            baseSkillName = "DinoTrample1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 25, Name: condition
                return true;
            end
        }
    }
};