-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "BlazingBody",
        syncRadius = 300,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Fire,
        suppressions = {
            SkillFuncCondition = "单段施法，首段无条件"
        }
    },
    Skill = {
        {
            baseSkillName = "BlazingBody1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 20, Name: condition
                return true;
            end
        }
    }
};