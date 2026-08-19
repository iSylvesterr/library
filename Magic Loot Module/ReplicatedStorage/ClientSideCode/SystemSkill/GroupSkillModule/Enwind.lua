-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "Enwind",
    skillCooldown = 2,
    syncRadius = 300,
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Earth,
    suppressions = {
        SkillFuncCondition = "首段无条件占位，与冰霜三棘组一致"
    }
};
v1.Skill = {
    {
        baseSkillName = "Enwind1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 22, Name: condition
            return true;
        end
    }
};

return v1;