-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "FrostTriSpire",
    syncRadius = 300,
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Ice,
    suppressions = {
        SkillFuncCondition = "首段无条件占位，与同组冰锥一致"
    }
};
v1.Skill = {
    {
        baseSkillName = "FrostTriSpire1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 21, Name: condition
            return true;
        end
    }
};

return v1;