-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "Thunder",
        syncRadius = 120,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Thunder,
        suppressions = {
            SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
        }
    },
    Skill = {
        {
            baseSkillName = "Thunder1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 18, Name: condition
                return true;
            end
        }
    }
};