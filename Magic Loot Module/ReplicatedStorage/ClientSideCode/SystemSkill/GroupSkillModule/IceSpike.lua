-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "IceSpike",
    skillCooldown = 1,
    syncRadius = 300,
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Ice,
    suppressions = {
        SkillFuncCondition = "原因：首段无条件派生，与同组火箭 FireArrow 占位一致"
    }
};
v1.Skill = {
    {
        baseSkillName = "IceSpike1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 27, Name: condition
            return true;
        end
    }
};

return v1;