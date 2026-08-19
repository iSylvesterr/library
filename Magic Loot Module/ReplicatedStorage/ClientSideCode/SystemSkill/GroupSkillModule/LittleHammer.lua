-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "LittleHammer",
        syncRadius = 120,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Space,
        suppressions = {
            SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
        }
    },
    Skill = {
        {
            baseSkillName = "LittleHammer1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 21, Name: condition
                return true;
            end
        }
    }
};