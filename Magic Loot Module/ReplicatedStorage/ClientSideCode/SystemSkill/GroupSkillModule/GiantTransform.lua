-- Decompiled with Potassium's decompiler.

return {
    Data = {
        skillName = "GiantTransform",
        skillElementType = nil,
        skillCooldown = 999999,
        syncRadius = 120,
        predictPresentation = false,
        dungeonPassiveTp = 1,
        InterruptionPriority = 0,
        suppressions = {
            SkillFuncCondition = "副本被动单段技能，无条件派生，首段始终可释放"
        }
    },
    Skill = {
        {
            baseSkillName = "GiantTransform1",
            breakLastSkill = false,

            condition = function() -- Line: 27, Name: condition
                return true;
            end
        }
    }
};