-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "HanamiWoodSpike",
        skillCooldown = 2,
        syncRadius = 300,
        predictPresentation = true,
        skillElementType = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp.Earth,
        suppressions = {
            SkillFuncCondition = "首段无条件占位，与同组冰霜三棘一致"
        }
    },
    Skill = {
        {
            baseSkillName = "HanamiWoodSpike1",
            breakLastSkill = false,

            condition = function(p1) -- Line: 21, Name: condition
                return true;
            end
        }
    }
};