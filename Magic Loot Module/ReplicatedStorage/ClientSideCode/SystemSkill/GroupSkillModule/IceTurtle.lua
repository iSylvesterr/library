-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "IceTurtle",
        syncRadius = 300,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Ice,
        suppressions = {
            SkillFuncCondition = "首段无条件占位，与轻盈/冰系组一致"
        }
    },
    Skill = {
        {
            baseSkillName = "IceTurtle1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 20, Name: condition
                return true;
            end
        }
    }
};