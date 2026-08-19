-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "FireMeteor",
        syncRadius = 150,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Fire,
        suppressions = {
            SkillFuncCondition = "单段即时施法，首段无条件"
        }
    },
    Skill = {
        {
            baseSkillName = "FireMeteor1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 23, Name: condition
                return true;
            end
        }
    }
};