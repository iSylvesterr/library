-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "ShootAway",
    skillCooldown = 1,
    Recovery = 1.9,
    syncRadius = 150,
    predictPresentation = true,
    aimLeadEnabled = true,
    aimLeadSeconds = 0.5,
    aimLeadMaxStuds = 30,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.None,
    suppressions = {
        SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
    }
};
v1.Skill = {
    {
        baseSkillName = "ShootAway1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 33, Name: condition
            return true;
        end
    }
};

return v1;