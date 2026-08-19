-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "ThunderStrike",
    syncRadius = 300,
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Thunder,
    suppressions = {
        SkillFuncCondition = "首段无条件占位，与同组冰霜三棘一致"
    }
};
v1.Skill = {
    {
        baseSkillName = "ThunderStrike1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 21, Name: condition
            return true;
        end
    }
};

return v1;