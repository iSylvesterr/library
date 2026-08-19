-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "ElectricBall",
    skillCooldown = 1,
    Recovery = 1.5,
    syncRadius = 150,
    preCastMoveStrategy = "RetreatFromTarget",
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Thunder,
    suppressions = {
        SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
    }
};
v1.Skill = {
    {
        baseSkillName = "ElectricBall1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 31, Name: condition
            return true;
        end
    }
};

return v1;