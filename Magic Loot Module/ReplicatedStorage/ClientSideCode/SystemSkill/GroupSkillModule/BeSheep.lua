-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "BeSheep",
    skillCooldown = 999999,
    syncRadius = 300,
    dungeonPassiveTp = 2,
    predictPresentation = false,
    InterruptionPriority = 0,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Space,
    suppressions = {
        SkillFuncCondition = "副本被动每关触发，首段始终可释放"
    }
};
v1.Skill = {
    {
        baseSkillName = "BeSheep1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 31, Name: condition
            return true;
        end
    }
};

return v1;