-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "ChainPoisonBurst",
    syncRadius = 300,
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Poison,
    suppressions = {
        SkillFuncCondition = "原因：首段无条件派生，与同组弹道技能占位一致"
    }
};
v1.Skill = {
    {
        baseSkillName = "ChainPoisonBurst1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 26, Name: condition
            return true;
        end
    }
};

return v1;