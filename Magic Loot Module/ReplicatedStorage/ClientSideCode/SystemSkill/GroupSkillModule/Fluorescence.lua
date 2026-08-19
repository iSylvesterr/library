-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "Fluorescence",
        syncRadius = 300,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Light,
        suppressions = {
            SkillFuncCondition = "功能性法术：无派生，首段无条件占位"
        }
    },
    Skill = {
        {
            baseSkillName = "Fluorescence1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 20, Name: condition
                return true;
            end
        }
    }
};