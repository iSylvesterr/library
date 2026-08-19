-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "IceLotusBloom",
        syncRadius = 150,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Ice,
        suppressions = {
            SkillFuncCondition = "首段无条件，function 占位与项目他组技能一致"
        }
    },
    Skill = {
        {
            baseSkillName = "IceLotusBloom1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 20, Name: condition
                return true;
            end
        }
    }
};